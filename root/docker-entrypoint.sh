#!/bin/sh

java -Dsun.jnu.encoding=UTF-8 -Dfile.encoding=UTF-8 -Djava.awt.headless=true -jar /opt/JDownloader/JDownloader.jar -norestart

rm -f /opt/JDownloader/JDownloader.jar.*
rm -f /opt/JDownloader/JDownloader.pid