#!/run/current-system/sw/bin/bash
while true; do
    # define some default strings
    BAT=""
    MUTE=false

    BRIGHT=$(/run/current-system/sw/bin/light -G | sed 's/\.00//g')

    if [[ $BRIGHT == "0" ]]; then
        BRIGHT=""
    else
        BRIGHT="l:$BRIGHT"
    fi

    if [[ $(/run/current-system/sw/bin/amixer get Master | grep 'Left:' | awk '{ print $6 }') == '[off]' ]]; then
        VOL="v:off|"
    else

        VOL=$(/run/current-system/sw/bin/amixer get Master | grep 'Left:' | awk '{ print $5 }' | sed 's/\[*]*//g')
        VOL="v:$VOL|"
    fi

    if [[ $(/run/current-system/sw/bin/acpi | /run/current-system/sw/bin/awk '!/rate/' | /run/current-system/sw/bin/awk '{ print $3 }') = 'Discharging,' ]]; then
        BAT=$(/run/current-system/sw/bin/acpi | /run/current-system/sw/bin/awk '!/rate/' | /run/current-system/sw/bin/awk '{ print $4 }' | sed 's/\,//g') 
        BAT="|b:$BAT"
    fi

    STATUSSTRING="[$VOL$BRIGHT$BAT] / $USER@$(hostname) \\ $(date '+%R %d.%m.%Y')"
    /run/current-system/sw/bin/xsetroot -name "$STATUSSTRING" -d ":0"
    sleep 1 
done

