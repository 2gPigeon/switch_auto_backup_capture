#!/usr/bin/env bash

LOG_FILE=~/switch_monitor_log.txt
BASE_PATH=$(find /run/user/1000/gvfs/ -maxdepth 1 -name "mtp:host=Nintendo_Nintendo_Switch_*" | head -n 1)

echo "=== Switch Monitor Started at $(date) ===" >> $LOG_FILE

while true; do
    # Switchが接続されているかチェック
    if [ -n "$BASE_PATH" ] && ls "$BASE_PATH/Album" >/dev/null 2>&1; then
        echo "$(date): Switch detected! Starting backup..." >> $LOG_FILE
        ~/switch_copy.sh
        echo "$(date): Backup complete!" >> $LOG_FILE
        sleep 60  # バックアップ終わったらしばらく休憩
    else
        BASE_PATH=$(find /run/user/1000/gvfs/ -maxdepth 1 -name "mtp:host=Nintendo_Nintendo_Switch_*" | head -n 1)
        sleep 5  # なければ5秒後にまたチェック
    fi
done
