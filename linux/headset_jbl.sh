#!/bin/bash
#headset mac
mac="78:44:05:B3:57:FB"
profile="a2dp"
# Special Bluetooth controller, default is empty
btMac=""
#connect|disconnect wait time
waitTime=5

macId="${mac//:/_}"
deviceId="bluez_card.$macId"

declare -A profiles
profiles['a2dp']='a2dp_sink'
profiles['hsp']='headset_head_unit'
profiles['off']='off'

function btCmd() {
    cmd="$1\nquit"
    [ ! -z "$btMac" ] && cmd="select $btMac\n$cmd"
    echo -e "$cmd" | bluetoothctl
}
function setProfile() {
    cmd="pactl set-card-profile $deviceId ${profiles[$1]}"
    echo $cmd
    $cmd
}
function btWaitConnect() {
    conState=$1
    for ((i=1;i<=$waitTime;++i)); do
        tmp="`btCmd "info $mac"|grep 'Connected: '`"
        [ ! -z "`echo "$tmp"|grep $conState`" ] && echo "$tmp" && return 0
        sleep 1s
    done
    echo "$tmp"
    return 1
}
function btConnect() {
    tmp="`btCmd "trust $mac\nconnect $mac" | grep -v 'NEW\|DEL\| quit'`"
    echo "$tmp"

    tmp="`btWaitConnect yes`"
    echo $tmp
    [ -z "`echo "$tmp" | grep yes`" ] && echo -e "Device $mac:\n\tConnected: fail." && return 1
    sleep 2s
    return 0
}
function btDisConnect() {
    tmp="`btCmd "disconnect $mac" | grep -v 'NEW\|DEL\| quit'`"
    echo "$tmp"

    tmp="`btWaitConnect no`"
    echo $tmp
    [ -z "`echo "$tmp" | grep no`" ] && echo -e "Device $mac:\n\tdisconnected: fail." && return 1
    sleep 1s
    return 0    
}


# controller
echo ""
btCtls="`btCmd list | grep '^Controller' | grep " $btMac"`"
echo -e "controller:\n$btCtls"
[ -z "$btCtls" -o ! -z "`echo "$btCtls" | grep "not available"`" ] && exit 1


# connect -> set off
echo ""
tmp="`btCmd paired-devices | grep '^Device' | grep " $mac"`"
echo -e "paired-devices:\n$tmp"
[ `echo "$tmp" | wc -l` != 1 ] && echo "Please pair the Bluetooth headset first: $mac" && exit 1
btConnect || exit $?
setProfile hsp

# reconnect -> set profile
btDisConnect || exit $?
btConnect || exit $?
setProfile $profile
