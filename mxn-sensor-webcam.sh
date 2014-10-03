#!/bin/sh

### BEGIN INIT INFO
# Provides:          app
# Required-Start:    
# Required-Stop:     
# Should-Start:      
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: start App MXN_SENSOR
### END INIT INFO

MXN_SENSOR_NAME=mxn-sensor-webcam
MXN_SENSOR_PATH=/etc/trik/sensors/$MXN_SENSOR_NAME
MXN_SENSOR_PRIORITY=-1
 
MXN_SENSOR_PIDDIR=/var/run/
MXN_SENSOR_PID=$PIDDIR/$NAME.pid

. /etc/init.d/functions

test -x $MXN_SENSOR_PATH/$NAME || exit 0

#include default options
test -f /etc/default/$MXN_SENSOR_NAME.default && . /etc/default/$MXN_SENSOR_NAME.default 


enviroment () {
        export LD_LIBRARY_PATH=$MXN_SENSOR_PATH:$LD_LIBRARY_PATH
        cd $MXN_SENSOR_PATH

}

set_cam() {
  v4l2-ctl -d $VIDEO_PATH --set-ctrl power_line_frequency=1 2>/dev/null
  v4l2-ctl -d $VIDEO_PATH --set-ctrl white_balance_temperature_auto=0 2>/dev/null
  v4l2-ctl -d $VIDEO_PATH --set-ctrl white_balance_temperature=4000 2>/dev/null
  v4l2-ctl -d $VIDEO_PATH --set-ctrl saturation=180 2>/dev/null
}


fix_cam() {
  v4l2-ctl -d $VIDEO_PATH --set-ctrl exposure_auto=1 2>/dev/null
}

case $1 in 
        start)
                echo -n "Starting  $MXN_SENSOR_NAME daemon : "
                enviroment
                set_cam
                start-stop-daemon -Svb -x ./$MXN_SENSOR_NAME -- $DEFAULT_OPS
                sleep 1
            		fix_cam
                status ./$MXN_SENSOR_NAME
                if [[ $? = 0 ]];
                  then
                    echo "done."
                    exit 0;
                  else
                    echo "failed"
                    exit 1;
                fi
                ;;
        stop)
                echo -n "Stopping $MXN_SENSOR_NAME daemon: "
                start-stop-daemon -Kvx ./$MXN_SENSOR_NAME
                echo "done."
                ;;
        restart|force-reload)
                echo -n "Restarting $MXN_SENSOR_NAME daemon: "
                enviroment
                start-stop-daemon -Kvx ./$MXN_SENSOR_NAME
                set_cam
                start-stop-daemon -Svb -x ./$MXN_SENSOR_NAME -- $DEFAULT_OPS
                sleep 1
            		fix_cam
                status ./$MXN_SENSOR_NAME
                if [[ $? = 0 ]];
                  then
                    echo "done."
                    exit 0;
                  else
                    echo "failed"
                    exit 1;
                fi
                ;;
        status)
                enviroment 
                status ./$MXN_SENSOR_NAME
                exit $?
                ;;
        *)
                echo "Usage: $0 {start|stop|force-reload|restart|status}"
                exit 1
        ;;
esac
exit 0

