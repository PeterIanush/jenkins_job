#!/bin/bash

# Parse arguments
while [ $# -gt 0 ]
do
  case "$1" in
    --environment)
      ENVIRONMENT="$2"
      shift 2 # Discard option and it argument
    ;;

    --region)
      REGION="$2"
      shift 2 # Discard option and it argument
    ;;

    --cluster)
      CLUSTER="$2"
      shift 2 # Discard option and it argument
    ;;

    --vpc)
      VPC="$2"
      shift 2 # Discard option and it argument
    ;;

    --stack-name)
      STACK_NAME="$2"
      shift 2 # Discard option and it argument
    ;;

    --role)
      ROLE="$2"
      shift 2 # Discard option and it argument
    ;;

    --asg)
      ASG_NAME="$2"
      shift 2 # Discard option and it argument
    ;;

    --)
      # Rest of command line arguments are non option arguments
      shift # Discard separator from list of arguments
      break # Finish for loop
    ;;

    -*)
      echo "Unknown option: $1" >&2
      exit 2
    ;;

    *)
      # Non option argument
      break # Finish for loop
    ;;
  esac

done

############################################################################
# Functions                                                                #
############################################################################

function error() {
  TIMESTAMP="`date "+%F %T"`"
  echo "$TIMESTAMP ERROR [$APP] $@" >&2
}

function warn() {
  TIMESTAMP="`date "+%F %T"`"
  echo "$TIMESTAMP WARN [$APP] $@" >&2
}

function info() {
  TIMESTAMP="`date "+%F %T"`"
  echo "$TIMESTAMP INFO [$APP] $@"
}

function fail() {
  error "Sending failure to CFN."
  /opt/aws/bin/cfn-signal --stack=${STACK_NAME} --resource=AutoScalingGroup --success=false --region ${REGION}
  exit 1
}

# Sets hostname based on provided argument
function set_hostname() {
  local _NAME=$1
  local _SHORT_HOSTNAME=$2

  hostname $_NAME
  # Duplicate hostname to /etc/hosts for reliability
  echo -e "$(hostname -I)\t\t$_NAME\t\t$_SHORT_HOSTNAME" >> /etc/hosts
}

function yum_install() {
  local _PACKAGES=$@

  while ! yum install -y $_PACKAGES; do
    warn "Failed to install $_PACKAGES"
    sleep 15
    warn "Trying again."
  done
}

function set_timezone() {
    echo -e "ZONE="CST6CDT"\nUTC=true" > /etc/sysconfig/clock
    unlink /etc/localtime
    ln -s /usr/share/zoneinfo/CST6CDT /etc/localtime
    # Restart crond and rsyslog services after timezone changing. Otherwise cron
    # will starts jobs in UTC. This issue appeared in Amazon linux since version
    # amzn-ami-hvm-2017.09.1.20171103-x86_64-gp2
    /etc/init.d/crond restart
    /etc/init.d/rsyslog restart
}

function set_facts() {
  mkdir -p  /etc/puppetlabs/facter/facts.d/
  cat > /etc/puppetlabs/facter/facts.d/facts.txt << EOF
tag_env=${ENVIRONMENT}
tag_cluster=${CLUSTER}
tag_role=${ROLE}
tag_region=${REGION}
tag_vpc=${VPC}
tag_name=${ENVIRONMENT}-c0-sftp
tag_asg=${ASG_NAME}
EOF
}

function get_hiera_keys() {
  local _LOCAL_DIR='/etc/puppetlabs/code/.keys'

  mkdir -p "$_LOCAL_DIR"
  aws s3 sync s3://bv-sftp-artifacts/hiera-keys "$_LOCAL_DIR" || {
    return 1
  }
  chmod -R 600 "$_LOCAL_DIR"
}

function run_puppet() {
  while :; do
     /opt/puppetlabs/bin/puppet apply /etc/puppetlabs/code/manifests/site.pp --test --ordering manifest
     [ $? == 2 -o $? == 0 ] && break
     sleep 60
  done
}

############################################################################
# Main program                                                             #
############################################################################

# Run function if a command fails.
trap 'fail' ERR

APP="sftp_init"

# Instance full id (e.g. i-0a393cb365940ccae)
INSTANCE_FULL_ID=$(curl -s 'http://169.254.169.254/latest/meta-data/instance-id')

# Instance hostname (e.g. qa-c0-sftp-0a393cb365940ccae)
HOSTNAME="${ENVIRONMENT}-${CLUSTER}-${ROLE}-${INSTANCE_FULL_ID:2}"

# Short instance hostname (e.g, qa-c0-sftp)
SHORT_HOSTNAME="${ENVIRONMENT}-${CLUSTER}-${ROLE}"

info "Set system time zone to CST."
set_timezone

info "Install Puppet and dependencies."
yum_install puppet-agent puppetgem-hiera-eyaml redhat-lsb-core

info "Setting hostname: ${HOSTNAME}."
set_hostname "${HOSTNAME}" "${SHORT_HOSTNAME}"

info "Creating facter file."
set_facts

info "Downloading hiera keys."
get_hiera_keys

info "Running puppet..."
run_puppet

# Send success to the CFN CreatePolicy.
# Signalling CFN stack when it is in CREATE_COMPLETE state leads to not 0 exit code,
# so always exit with 0 to prevent trap 'fail' function execution.
info "Sending success to CFN stack..."
/opt/aws/bin/cfn-signal --stack=${STACK_NAME} --resource=AutoScalingGroup --success=true --region ${REGION} || :
