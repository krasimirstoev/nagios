#!/bin/bash
# Check bandwidth plugin for Nagios
#
# Options :
#
#   -iface/--interface)
#       Interface name (eth0 by default)
#
#   -s/--sleep)
#       Sleep time between both statistics measures
#
#   -w/--warning)
#       Warning value (KB/s)
#
#   -c/--critical)
#       Critical value (KB/s)

STATE_OK=0
STATE_WARNING=1
STATE_CRITICAL=2
STATE_UNKNOWN=3
STATE_DEPENDENT=4

while test -n "$1"; do
    case "$1" in
        --interface|-iface)
            OPT_INTERFACE=$2
            shift
            ;;
        --sleep|-s)
            OPT_SLEEP=$2
            shift
            ;;
        --warning|-w)
            OPT_WARN=$2
            shift
            ;;
        --critical|-c)
            OPT_CRIT=$2
            shift
            ;;
        *)
            echo "Unknown argument: $1"
            exit $STATE_UNKNOWN
            ;;
    esac
    shift
done

OPT_WARN=${OPT_WARN:=50}
OPT_CRIT=${OPT_CRIT:=70}
OPT_INTERFACE=${OPT_INTERFACE:=eth0}
OPT_SLEEP=${OPT_SLEEP:=5}

R1=$(cat /sys/class/net/$OPT_INTERFACE/statistics/rx_bytes)
T1=$(cat /sys/class/net/$OPT_INTERFACE/statistics/tx_bytes)
sleep $OPT_SLEEP
R2=$(cat /sys/class/net/$OPT_INTERFACE/statistics/rx_bytes)
T2=$(cat /sys/class/net/$OPT_INTERFACE/statistics/tx_bytes)

TBPS=$(expr $T2 - $T1)
RBPS=$(expr $R2 - $R1)
TKBPS=$(expr $TBPS / 1024)
RKBPS=$(expr $RBPS / 1024)

STATUS="tx $1: $TKBPS kb/s rx $1: $RKBPS kb/s"
if [ "$RKBPS" -ge "$OPT_WARN" ] || [ "$TKBPS" -ge "$OPT_WARN" ]; then
    if [ "$RKBPS" -ge "$OPT_CRIT" ] || [ "$TKBPS" -ge "$OPT_CRIT" ]; then
        EXITSTATUS=$STATE_CRITICAL
        echo "CRITICAL - $STATUS"
    else
        EXITSTATUS=$STATE_OK
        echo "WARNING - $STATUS"
    fi
else
    EXITSTATUS=$STATE_OK
    echo "OK - $STATUS"
fi

exit ${EXITSTATUS:=$STATE_UNKNOWN}
