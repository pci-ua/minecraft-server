#!/usr/bin/env bash

if [[ -z $MCSERVER_MAX_MEMORY ]]; then
	$MCSERVER_MAX_MEMORY=2
	echo "No max memory usage set. Using 2G as a default."
fi

if ! [[ -d /home/minecraft/server ]]; then
	echo "The server directory is not mounted on /home/minecraft/server inside the container !" > /dev/stderr
	exit 1
fi

cd /home/minecraft/server

# Explication des flags de la JVM : https://docs.papermc.io/paper/aikars-flags
java -Xms${MCSERVER_MAX_MEMORY}G -Xmx${MCSERVER_MAX_MEMORY}G -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -jar /home/minecraft/server/paper.jar --nogui

exit_code=$?
echo -e "\n\nServer stopped with exit code $exit_code."
exit $exit_code
