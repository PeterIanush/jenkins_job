gem install puppet yamllint

puppet parser validate puppet/modules/*
yamllint /puppet/hieradata/*
yamllint cloudformation/*
