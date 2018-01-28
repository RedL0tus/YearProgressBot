#!/bin/bash

export LENGTH=20;
export API_TOKEN="";
export CHAT_ID="";

function GET_PERCENTAGE {
        local CURRENT_YEAR=$(date +%Y);
        if [ $((CURRENT_YEAR % 400)) -eq 0 ]; then
                local TOTAL_DAYS=366;
        elif [ $((CURRENT_YEAR % 100)) -eq 0 ]; then
                local TOTAL_DAYS=365;
        elif [ $((CURRENT_YEAR % 4)) -eq 0 ]; then
                local TOTAL_DAYS=366;
        else
                local TOTAL_DAYS=365;
        fi
        CURRENT_DAY=$(echo "$(date +%j) + 0" | bc)
        echo $((200*$CURRENT_DAY/$TOTAL_DAYS % 2 + 100*$CURRENT_DAY/$TOTAL_DAYS));
}

function DISPLAY {
        local PERCENTAGE=$(GET_PERCENTAGE);
        local FILLED=$(($LENGTH*$PERCENTAGE/100));
        local BLANK=$(($LENGTH-$FILLED));
        local BAR="";
	for ((i=0;i<$FILLED;i++)) {
                BAR=${BAR}"▓";
        }
        for ((i=0;i<$BLANK;i++)) {
                BAR=${BAR}"░";
        }
        BAR=${BAR}" "${PERCENTAGE}"%";
	echo $BAR;
}

function MAIN {
	local BAR=$(DISPLAY);
	local BAR_NOW=$(DISPLAY);
	curl -X POST "https://api.telegram.org/bot${API_TOKEN}/sendMessage" -d "chat_id=${CHAT_ID}&text=${BAR_NOW}";
	while true; do
		BAR_NOW=$(DISPLAY);
		if [ $BAR -ne $BAR_NOW ]; then
			curl -X POST "https://api.telegram.org/bot${API_TOKEN}/sendMessage" -d "chat_id=${CHAT_ID}&text=${BAR_NOW}";
			BAR=$BAR_NOW;
		fi
		sleep 100;
	done
}

MAIN;
