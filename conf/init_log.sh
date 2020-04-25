#!/bin/bash
# Check logs 
# and create them if needed
#
# checks dir log
if [[ ! -d "$logs_dir" ]]
then 
	sudo -u $un mkdir -p $logs_dir
fi
# check log file
if [[ ! -f "$logs_dir/$log_file_name" ]]
then
	sudo -u $un touch $logs_dir/$log_file_name
fi
new_run
info "Logs are written at $logs_dir/$log_file_name"