i#!/bin/sh
SERVICE_NAME=html-2-pdf
PID_PATH_NAME=/tmp/$SERVICE_NAME-pid

function bootstrap {
    WORKDIR=/home/judahdonkor/wkspc/$SERVICE_NAME
    PORT=1030 \
    nohup \
    npm run start \
    2>>$WORKDIR/stderr.log \
    >>$WORKDIR/stdout.log \
    &
}

case $1 in
    start)
        echo "Starting $SERVICE_NAME ..."
        if [ ! -f $PID_PATH_NAME ]; then
            bootstrap
            echo $! >$PID_PATH_NAME
            echo "$SERVICE_NAME started ..."
        else
            echo "$SERVICE_NAME is already running ..."
        fi
    ;;
    stop)
        if [ -f $PID_PATH_NAME ]; then
            PID=$(cat $PID_PATH_NAME)
            echo "$SERVICE_NAME stoping ..."
            kill $PID
            echo "$SERVICE_NAME stopped ..."
            rm $PID_PATH_NAME
        else
            echo "$SERVICE_NAME is not running ..."
        fi
    ;;
    restart)
        if [ -f $PID_PATH_NAME ]; then
            PID=$(cat $PID_PATH_NAME)
            echo "$SERVICE_NAME stopping ..."
            kill $PID
            echo "$SERVICE_NAME stopped ..."
            rm $PID_PATH_NAME
            echo "$SERVICE_NAME starting ..."
            bootstrap
            echo $! >$PID_PATH_NAME
            echo "$SERVICE_NAME started ..."
        else
            echo "$SERVICE_NAME is not running ..."
        fi
    ;;
esac
