#!/bin/bash

CUR_DIR=`pwd`
PACK_PATH="$CUR_DIR/vendor/psycho/prebuilt/app/Home"

# Package manager check to install 'wget'
declare -A osInfo;
osInfo[/etc/redhat-release]=yum
osInfo[/etc/pacman.conf]=pacman
osInfo[/etc/debian_version]=apt-get

if which wget > /dev/null 2> /dev/null
then
	echo "wget package found..."
else
	echo "wget package not found. Trying to install..."
	for f in ${!osInfo[@]}
	do
		if [[ -f $f ]]; then
			echo Package manager: ${osInfo[$f]}
			TEMP=${osInfo[$f]}
		fi
	done

	case "$TEMP" in
		"yum")
			`sudo yum install wget`
		;;
		"apt-get")
			`sudo apt-get intall wget`
		;;
		"pacman")
			`sudo pacman -S wget`
		;;
		*)
			echo "Unknow Distribution! 'wget' couldn't be installed. Please install it manually"
		;;
	esac
fi

wget -q --tries=10 --timeout=20 --spider http://google.com

if [[ $? -eq 0 ]]; then
  echo "Fetching Updated Prebuilds"
  rm -r $PACK_PATH/*.apk
  wget -q -O $PACK_PATH/Home.apk http://teslacoilsw.com/tesladirect/download.pl?packageName=com.teslacoilsw.launcher
else
  echo "Trouble Connecting Internet, Using Old Prebuilds"
fi

rm -r development/samples/Home
