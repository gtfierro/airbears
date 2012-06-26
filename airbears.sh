#!/bin/bash

# automatically change configuration of Mac OS X based on location
# author: Onne Gorter <o.gorter@gmail.com>
# url: http://tech.inhelsinki.nl/locationchanger/
# version: 0.4
# edited and expanded by: Gabe Fierro <gtfierro225@gmail.com>

# get a little breather before we get data for things to settle down
sleep 2

# get various system information
SSID=`/System/Library/PrivateFrameworks/Apple80211.framework/Versions/A/Resources/airport -I\
     | grep ' SSID:' | cut -d ':' -f 2 | tr -d ' '`
     EN0IP=`ifconfig en0 | grep 'inet ' | cut -d' ' -f 2`
     EN1IP=`ifconfig en1 | grep 'inet ' | cut -d' ' -f 2`

     if [ -z $LOCATION ]; then
     LOCATION="automatic"
     REASON=Fallback
     fi

# get some time to figure ip addresses out ...
     sleep 3
     if ping -c 1 linux; then
# if necessary, start a proxy for synergy on host 'linux'
     ps -x | grep -E '[0-9] ssh.*-R24800:'  || \
       ssh -fN linux -R24800:127.0.0.1:24800 
# if not running, start synergys with display name macosx
       ps -x | grep -E '[0-9] synergys'  || \
         synergys -n macosx
         fi
# do some stuff here if you want to
         scselect Automatic
#lpoptions -d "Default Printer"

# do some stuff here that needs to happen after every network change

         echo `date` "Location: $LOCATION - $REASON" >> $HOME/.locationchanger.log

         USERNAME="$(perl -MURI::Escape -e 'print uri_escape($ARGV[0]);' "$1")"
         PASSWORD="$(perl -MURI::Escape -e 'print uri_escape($ARGV[0]);' "$2")"

         if [[ `airport -I | awk '/ SSID:/ {print $2}'` = "AirBears" ]]; then
           if [[ `ping -c 1 google.com | awk '/packets received/ {print $4}'` = "0" ]]; then
             sedex="s/^.*type=\"hidden\" name=\"lt\" value=\"\([^\"].*\)\".*$/username=$USERNAME\&password=$PASSWORD\&_eventId=submit\&lt=\1/' | sed 's/[ ]/+/"
             curl https://auth.berkeley.edu/cas/login?service=https%3a%2f%2fwlan.berkeley.edu%2fcgi-bin%2flogin%2fcalnet.cgi%3fsubmit%3dCalNet%26url%3d -silent | awk '/ type="hidden" name="lt" value="/ {print $0 }' | sed $sedex | sed 's/[ ]/+/' | curl https://auth.berkeley.edu/cas/login?service=https%3a%2f%2fwlan.berkeley.edu%2fcgi-bin%2flogin%2fcalnet.cgi%3fsubmit%3dCalNet%26url%3d -silent -c cookiejar.txt -L --data @- | awk '/Authentication complete./ {print $0}' | sed "s/^.*\(Authentication[^<]*\)<p.*$/\1/"
           else
             echo "Already logged in, or Airport is being finnicky and isn't getting an IP. Try again in a few minutes if you don't have a connection."
           fi
         fi
         if [ -f cookiejar.txt ]; then
           rm cookiejar.txt
         fi
         echo $USERNAME $PASSWORD
         exit 0

