#!/bin/sh

### BEGIN INIT INFO
# Provides:          app
# Required-Start:    
# Required-Stop:     
# Should-Start:      
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: start App LINE_SENSOR
### END INIT INFO

LINE_SENSOR_NAME=line-sensor-webcam
LINE_SENSOR_PATH=/etc/trik/sensors/$LINE_SENSOR_NAME
LINE_SENSOR_PRIORITY=-1
 
LINE_SENSOR_PIDDIR=/var/run/
LINE_SENSOR_PID=$PIDDIR/$NAME.pid

. /etc/init.d/functions

test -x $LINE_SENSOR_PATH/$NAME || exit 0

#include default options
test -f /etc/default/$LINE_SENSOR_NAME.default && . /etc/default/$LINE_SENSOR_NAME.default 


enviroment () {
        export LD_LIBRARY_PATH=$LINE_SENSOR_PATH:$LD_LIBRARY_PATH
        cd $LINE_SENSOR_PATH

}

set_cam() {
  v4l2-ctl -d $VIDEO_PATH --set-ctrl power_line_frequency=1 2>/dev/null
  v4l2-ctl -d $VIDEO_PATH --set-ctrl white_balance_temperature_auto=0 2>/dev/null
  v4l2-ctl -d $VIDEO_PATH --set-ctrl white_balance_temperature=4000 2>/dev/null
}

case $1 in 
        start)
                echo -n "Starting  $LINE_SENSOR_NAME daemon : "
                enviroment
                set_cam
                start-stop-daemon -Svb -x ./$LINE_SENSOR_NAME -- $DEFAULT_OPS
                sleep 2
                status ./$LINE_SENSOR_NAME
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
                echo -n "Stopping $LINE_SENSOR_NAME daemon: "
                start-stop-daemon -Kvx ./$LINE_SENSOR_NAME
                echo "done."
                ;;
        restart|force-reload)
                echo -n "Restarting $LINE_SENSOR_NAME daemon: "
                enviroment
                start-stop-daemon -Kvx ./$LINE_SENSOR_NAME
                sleep 2
                start-stop-daemon -Svb -x ./$LINE_SENSOR_NAME -- $DEFAULT_OPS
                sleep 2
                status ./$LINE_SENSOR_NAME
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
                status ./$LINE_SENSOR_NAME
                exit $?
                ;;
        *)
                echo "Usage: $0 {start|stop|force-reload|restart|status}"
                exit 1
        ;;
esac
exit 0

