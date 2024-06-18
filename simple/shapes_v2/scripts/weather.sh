#!/bin/bash

UNIT="°C"
APIID="API KEY HERE"
# go to https://home.openweathermap.org/api_keys to generate an api key
LOCID="1259229"
# the location id can be found in the url after you search for your location on the same website
# for ex., the url of Pune,IN is https://openweathermap.org/city/1259229 and the id here is 1259229

# if jq starts throwing an error, hardcode APIID and LOCID into the url

URL="http://api.openweathermap.org/data/2.5/weather?APPID="$APIID"&id="$LOCID"&units=metric"
RESULTS=`curl -s $URL`
ICON_CODE=`echo $RESULTS | jq -r ".weather[].icon"`
ICON_HEX="#eb6f92"
RESULTS_PARSED=`echo $RESULTS | jq .main.temp | cut -f1 -d"."`
case "${ICON_CODE:2:1}" in
"d")    DAYTIME="Day"
;;"n")  DAYTIME="Night"
esac
case "${ICON_CODE:0:2}" in
"01")   OP=" Clear"
;;"02") OP="  Cloudy"
;;"03") OP=" Cloudy"
;;"04") OP=" Cloudy"
;;"09") OP="󰖗  Rainy"
;;"10") OP="  Rainy"
;;"11") OP="   Stormy"
;;"13") OP=" Snowy"
;;"40") OP="  Misty"
;;"50") OP="  Misty"
;;*)    OP=" Check internet"
esac

case $1 in
1)   echo "LONG" > ~/.config/polybar/shapes_v2/scripts/current-weather.txt
;;2) echo "SHORT" > ~/.config/polybar/shapes_v2/scripts/current-weather.txt
esac

case `cat ~/.config/polybar/shapes_v2/scripts/current-weather.txt` in
"SHORT") echo "%{F$ICON_HEX}| $OP $RESULTS_PARSED $UNIT %{F-}"
;;*)     echo "%{F$ICON_HEX}| $OP $DAYTIME $RESULTS_PARSED $UNIT %{F-}"
esac
