#!/bin/bash
#
# install python
# configure powerline
#

## NEED TO CHECK CONNECTION
ping -c 1 google.com 1>/dev/null 2>/dev/null
if [[ $? -ne 0 ]] ; then error "No connection available. Aborting." ; exit 1 ; fi

   #apt update

   #check_install $un python
   #check_install $un python-pip
   #check_install $un python3
   #check_install $un python3-pip

#
# upgrade pip, pip3 
# install python modules:
#	* powerline-status
#	* powerline-gitstatus
#	* virtualenv
#	* ipython
#
   #sudo -u $un python -m pip install --user --upgrade pip
   #sudo -u $un python3 -m pip install --user --upgrade pip
   #sudo -u $un python3 -m pip install --user powerline-status powerline-gitstatus virtualenv ipython
if [[ "$FANCY_PROMPT" -eq "1" ]] 
then 
#
# Powerline configuration
#
# impose sourcing of .bash_powerline
# into .bashrc
#
	bash_p_name=.bash_powerline
	FILE=$uhome/.bashrc
	if [[ ! -f "$FILE" ]] 
	then 
		sudo -u $un touch $FILE
	fi
	cat $FILE | grep "source ~/$bash_p_name" >/dev/null
	if [[ $? -ne 0 ]] ; then 
		echo -e "#\n# sourcing bash script for powerline prompt\n" >> $FILE
		echo -e "if [[ -f \"~/$bash_p_name\" ]] ; then source ~/$bash_p_name ; fi" >> $FILE
	fi
	#
	# write .bash_powerline 
	# with powerline configuration
	#
	path_to_powerline=$( sudo -u $un python3 -m pip show powerline-status | grep Location | awk '{print $2}' )
	path_to_powerline_daemon=$( dirname $(find $uhome -name powerline-daemon) )
	FILE=$uhome/$bash_p_name
	if [[ ! -f $FILE ]] 
	then 
		sudo -u $un touch $FILE
		echo "export PATH=\$PATH:$path_to_powerline_daemon" >> $uhome/$bash_p_name
		echo "powerline-daemon -q" >> $uhome/$bash_p_name
		echo -e "POWERLINE_BASH_CONTINUATION=1\nPOWERLINE_BASH_SELECT=1" >> $uhome/$bash_p_name
		echo ". $path_to_powerline/powerline/bindings/bash/powerline.sh" >> $uhome/$bash_p_name
	fi
	## load terminal configuration file
	#new_prof=$( cat $conf_dir/gnome-terminal-conf.conf | grep profile | awk 'BEGIN { FS=":" } {print $3}' | sed 's/]$//' )
	#new_prof=$( echo $new_prof | sed "s/^/\'/ ; s/$/\'/" )
	#old_list=$( dconf dump /org/gnome/terminal/legacy/profiles:/ | grep list | sed 's/]$//;s/^list=//' )
	#new_list=$( echo "$old_list,'$new_prof']" )
	#dconf load /org/gnome/terminal/legacy/ < $conf_dir/gnome-terminal-conf.conf
	#term_schema=$( gsettings list-schema | grep Terminal.ProfilesList )
	#schema=( $( gsettings list-keys $term_schema ) )
	#gsettings set 
	#dconf write /org/gnome/terminal/legacy/profiles:/list $new_list
	#dconf write /org/gnome/terminal/legacy/profiles:/default /$new_prof
fi

# installing new powerline fonts
if [[ ! -d "$font_dir" ]] ; 
then 
	sudo -u $un mkdir $font_dir ;
	check_install $un git ;
	sudo -u $un git clone https://github.com/powerline/fonts.git $font_dir ;	
fi
if [[ ! -d "$uhome/.local/share/fonts" ]] ; then sudo -u $un mkdir -p $uhome/.local/share/fonts ; fi
sudo -u $un cp $font_dir/Meslo\ Dotted/Meslo\ LG\ L\ DZ\ Regular\ for\ Powerline.ttf $uhome/.local/share/fonts
sudo -u $un cp $font_dir/Meslo\ Dotted/Meslo\ LG\ L\ DZ\ Italic\ for\ Powerline.ttf $uhome/.local/share/fonts
if [[ $? -eq 0 ]]  
then 
	info "Fonts copied." ; 
	sudo -u $un fc-cache ;
	info "Fonts installed." ;
else 
	error "Fonts not copied." ; 
fi