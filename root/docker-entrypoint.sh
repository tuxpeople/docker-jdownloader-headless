#!/busybox/sh

set -x

while true; do
    java -Dsun.jnu.encoding=UTF-8 -Dfile.encoding=UTF-8 -Djava.awt.headless=true -jar /opt/JDownloader/JDownloader.jar -norestart
    PID=$!
    wait $PID
    wait $PID

    echo "restart in 5 seconds" 
    sleep 5
done