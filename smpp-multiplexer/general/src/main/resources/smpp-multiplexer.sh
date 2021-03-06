#!/bin/bash

cd /usr/share/smpp-multiplexer/

# Archive for GC-logs
FILE="log/gc.$(date +%Y%m%d%H%M%S).tar.gz"

#GC logs to process
FILES_TO_PROCESS="log/gc.log.* log/error.log"

#Archive GC logs
`/bin/tar -czf $FILE $FILES_TO_PROCESS`

#Java run command
java -cp plugins/* -Xms2048m -Xmx2048m -Xloggc:log/gc.log -verbose:gc -XX:+PrintGCDetails -XX:+PrintGCDateStamps -XX:+PrintGCTimeStamps -XX:+UseGCLogFileRotation -XX:NumberOfGCLogFiles=5 -XX:GCLogFileSize=128K -jar -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=9011 -Dcom.sun.management.jmxremote.authenticate=false -Djava.rmi.server.hostname=`/bin/hostname -i` -Dcom.sun.management.jmxremote.ssl=false -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/usr/share/smpp-multiplexer/log/ -Dlogback.configurationFile=etc/logback.xml ${project.build.finalName}.jar "$@" &> log/error.log &

echo $! > /usr/share/smpp-multiplexer/run.pid
