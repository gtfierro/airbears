#airbears
##Airbears Internet Reentry Because Every(other) Autologin Really Sucks

Just run ```./install.sh``` and type in your calnet id and password. They *will* be stored in plaintext, so just be aware of that. Don't let anyone poke around in your home directory or whatever, I guess. 

##Usage
You don't have to do anything! After you run ```./install.sh```, it will create a .plist file that will run whenever you connect to a wireless network. It will then check if that network is called 'AirBears', and if it is, it will send your user/pass along to authenticate. Is it secure? Not really, but you know, whatever.

##Credit where credit is due
I took major inspiration from http://tech.inhelsinki.nl/locationchanger/ and some script someone posted on the UCBerkeley subreddit http://sroshi.blogspot.com/2012/02/login-to-airbears-with-single-line-of.html
