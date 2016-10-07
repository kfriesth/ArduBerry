#!/usr/bin/env bash

if [[ -f /home/pi/quiet_mode ]]
then
quiet_mode=1
else
quiet_mode=0
fi

if [[ "$quiet_mode" -eq "0" ]]
then
	echo " _____ _ ";
	echo " | __ \ | | ";
	echo " | | | | _____ _| |_ ___ _ __ ";
	echo " | | | |/ _ \ \/ / __/ _ \ '__| ";
	echo " | |__| | __/> <| || __/ | ";
	echo " |_____/ \___/_/\_\\__\___|_| _ _ ";
	echo " |_ _| | | | | (_) ";
	echo " | | _ __ __| |_ _ ___| |_ _ __ _ ___ ___ ";
	echo " | | | '_ \ / _\` | | | / __| __| '__| |/ _ \/ __|";
	echo " _| |_| | | | (_| | |_| \__ \ |_| | | | __/\__ \ ";
	echo " |_____|_| |_|\__,_|\__,_|___/\__|_| |_|\___||___/ ";
	echo " ";
	echo " ";
	echo " "
	printf "Welcome to Arduberry Installer.\nPlease ensure internet connectivity before running this script.\n
	NOTE: Raspberry Pi wil reboot after completion."
	printf "Special thanks to Joe Sanford at Tufts University.  This script was derived from his work.  Thank you Joe!"
	printf " "
	echo "Must be running as Root user"
	echo " "
	echo "Press ENTER to begin..."
	# read
	sleep 5
 
	echo " "
	echo "Check for internet connectivity..."
	echo "=================================="
	wget -q --tries=2 --timeout=20 --output-document=/dev/null http://raspberrypi.org
	if [ $? -eq 0 ];then
		echo "Connected"
	else
		echo "Unable to Connect, try again !!!"
		exit 0
	fi
fi
 
 echo " "
 echo "Installing Dependencies"
 echo "======================="
 sudo apt-get install python-pip git libi2c-dev python-serial python-rpi.gpio i2c-tools python-smbus arduino minicom -y
 echo "Dependencies installed"
 
 git clone git://git.drogon.net/wiringPi
 cd wiringPi
 ./build
 echo "wiringPi Installed"
 
 echo " "
 echo "Removing blacklist from /etc/modprobe.d/raspi-blacklist.conf . . ."
 echo "=================================================================="
 if grep -q "#blacklist i2c-bcm2708" /etc/modprobe.d/raspi-blacklist.conf; then
 	echo "I2C already removed from blacklist"
 else
 	sudo sed -i -e 's/blacklist i2c-bcm2708/#blacklist i2c-bcm2708/g' /etc/modprobe.d/raspi-blacklist.conf
 	echo "I2C removed from blacklist"
 fi
 if grep -q "#blacklist spi-bcm2708" /etc/modprobe.d/raspi-blacklist.conf; then
 	echo "SPI already removed from blacklist"
 else
 	sudo sed -i -e 's/blacklist spi-bcm2708/#blacklist spi-bcm2708/g' /etc/modprobe.d/raspi-blacklist.conf
 	echo "SPI removed from blacklist"
 fi
 
 #Adding in /etc/modules
 echo " "
 echo "Adding I2C-dev and SPI-dev in /etc/modules . . ."
 echo "================================================"
 if grep -q "i2c-dev" /etc/modules; then
 	echo "I2C-dev already there"
 else
 	echo i2c-dev >> /etc/modules
 	echo "I2C-dev added"
 fi
 if grep -q "i2c-bcm2708" /etc/modules; then
 	echo "i2c-bcm2708 already there"
 else
 	echo i2c-bcm2708 >> /etc/modules
 	echo "i2c-bcm2708 added"
 fi
 if grep -q "spi-dev" /etc/modules; then
 	echo "spi-dev already there"
 else
 	echo spi-dev >> /etc/modules
 	echo "spi-dev added"
 fi
 
 #Adding ARDUINO setup files
 echo " "
 echo "Making changes to Arduino . . ."
 echo "==============================="
 cd /tmp
 wget http://project-downloads.drogon.net/gertboard/avrdude_5.10-4_armhf.deb
 sudo dpkg -i avrdude_5.10-4_armhf.deb
 sudo chmod 4755 /usr/bin/avrdude
 
 cd /tmp
 wget http://project-downloads.drogon.net/gertboard/setup.sh
 chmod +x setup.sh
 sudo ./setup.sh
 
 cd /etc/minicom
 sudo wget http://project-downloads.drogon.net/gertboard/minirc.ama0
 sudo sed -i '/Exec=arduino/c\Exec=gksu arduino' /usr/share/applications/arduino.desktop
 echo " "
if [[ "$quiet_mode" -eq "0" ]]
then
	echo "Please restart to implement changes!"
	echo "  _____  ______  _____ _______       _____ _______ "
	echo " |  __ \|  ____|/ ____|__   __|/\   |  __ \__   __|"
	echo " | |__) | |__  | (___    | |  /  \  | |__) | | |   "
	echo " |  _  /|  __|  \___ \   | | / /\ \ |  _  /  | |   "
	echo " | | \ \| |____ ____) |  | |/ ____ \| | \ \  | |   "
	echo " |_|  \_\______|_____/   |_/_/    \_\_|  \_\ |_|   "
	echo " "
	echo "Please restart to implement changes!"
	echo "To Restart type sudo reboot"
fi 