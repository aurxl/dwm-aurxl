#!/run/current-system/sw/bin/bash
while true; do
    # define some default strings
    BAT=""
    MUTE=false
    NET=""

    BRIGHT=$(light -G | sed 's/\.00//g')

    if [[ $BRIGHT == "0" ]]; then
        BRIGHT=""
    else
        BRIGHT="l:$BRIGHT"
    fi

    if [[ $(amixer get Master | grep 'Left:' | awk '{ print $6 }') == '[off]' ]]; then
        VOL="v:off|"
    else

        VOL=$(amixer get Master | grep 'Left:' | awk '{ print $5 }' | sed 's/\[*]*//g')
        VOL="v:$VOL|"
    fi

    if [[ $(acpi | awk '!/rate/' | awk '{ print $3 }') = 'Discharging,' ]]; then
        BAT=$(acpi | awk '!/rate/' | awk '{ print $4 }' | sed 's/\,//g') 
        BAT="|b:$BAT"
    fi

    if [[ $(wpa_cli status | grep wpa_state | awk 'BEGIN { FS = "=" } ; { print $2 }' ) == 'CONNECTED' ]]; then
        NET=$(wpa_cli status | grep ^ssid | awk 'BEGIN { FS = "=" } ; { print $2 }')
        NET="$NET|"
    fi


    STATUSSTRING="[$NET$VOL$BRIGHT$BAT] / $USER@$(hostname) \\ $(date '+%R %d.%m.%Y')"
    xsetroot -name "$STATUSSTRING" -d ":0"
    sleep 0.5 
done

