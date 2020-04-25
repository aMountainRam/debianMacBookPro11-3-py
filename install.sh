#!/bin/bash
#
# This part of the repo
# takes care of mainly two things:
#	* network wireless adapter firmware install
#	* python
# then the script continues as a Python script
#

export log_file_name=install.log
export local_dir="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
export app_name=$0
export logs_dir=$local_dir/log
export source_dir=$local_dir/src
export conf_dir=$local_dir/conf
export module_dir=$local_dir/module
export tmp_dir=$local_dir/tmp
export font_dir=$local_dir/font
export TEXT_MODE=0 
export FANCY_PROMPT=0
# some functions - log schemas
source $conf_dir/function_export.sh

# args handling
# Execute getopt on the arguments passed to this program, identified by the special character $@
PARSED_OPTIONS=$(getopt -qn "$0"  -o rhtf -l "remove-logs,help,text-mode,fancy-prompt"  -- "$@")
if [[ $? -ne 0 ]]
then 
	gecho "Unknown option. Please use -h, --help, ? for help." ; 
	exit 1 ;
fi

eval set -- "$PARSED_OPTIONS"
# parsing
while true ; do 
	case "$1" in
		-r | --remove-logs ) remove_logs
			;;
		-h | --help | ? ) help_message
			;;
		-t | --text-mode ) export TEXT_MODE=1
			;;
		-f | --fancy-prompt ) export FANCY_PROMPT=1
			;;
		--)
			shift ;
			break ;
			;;
	esac ; shift ;
done

# The shan't be run as root
if [[ "$EUID" -ne "0" ]]
then
	gecho "Please run the script as root."
	exit 1
fi

# check the logname 
# to run some non-privileged instruction
#
export un=$(logname)
export uhome=$(eval echo "~$un") 

# initiate logs
source $conf_dir/init_log.sh

#
# module 01 -- network wireless adapter
#
source $module_dir/wireless_driver.sh
module_done "wireless_driver"

#
# module 02 -- python
# 	notes:
#		* this might be removed with a venv
#
source $module_dir/python_install.sh
module_done "wireless_driver"

success "Test"
info "Running python script."
#sudo -u $un python3 main.py
exit 0
