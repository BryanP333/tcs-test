SHELL := /bin/bash
#################################################################################################
##       Makefile for Altus Performance Platform / APP-Benchmarking Environment rebuilds       ##
#################################################################################################

provision = ./infra/scripts/provisioner.sh

#########################################################################################################
##       Tasks to plan, create & destroy Altus Performance Platform / APP-Benchmarking resources     ###
#########################################################################################################

component-plan:
	$(provision) component-plan $(env) $(component) $(assume_role)

component-build:
	$(provision) component-build $(env) $(component) $(assume_role)

component-destroy:
	$(provision) component-destroy $(env) $(component) $(assume_role)
