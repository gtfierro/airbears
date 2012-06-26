#!/bin/sh
echo "Enter your calnet id and press [Enter]:"
read username
echo "Enter your calnet password and press [Enter]:"
read -s password
password=$(echo $password | sed -e 's/\//\\\//g')

echo "Initializing LocationChanger.plist..."
cp LocationChanger.plist newLocationChanger.plist
sed -i '' -e "s/username/$username/" newLocationChanger.plist
sed -i '' -e "s/password/$password/" newLocationChanger.plist

echo "creating airport syslink for simplicity... (may require sudo)"
sudo ln -s /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport /usr/sbin/airport
echo "Making airbears.sh executable and hashing password..."
chmod +x /usr/bin/airbears.sh
echo "Copying it into /usr/bin/... (may require sudo)"
sudo cp airbears.sh /usr/bin/airbears.sh
echo "Copying LocationChanger.plist into ~/Library/LaunchAgents..."
cp newLocationChanger.plist ~/Library/LaunchAgents/LocationChanger.plist
rm newLocationChanger.plist
echo "Loading ~/LibraryLaunchAgents/LocationChanger.plist..."
launchctl load ~/Library/LaunchAgents/LocationChanger.plist
echo "install succeeded"
