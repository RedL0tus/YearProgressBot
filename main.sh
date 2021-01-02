#!/bin/bash

# Copyright © 2018 Kay <RedL0tus@users.noreply.github.com>
# This work is free. You can redistribute it and/or modify it under the
# terms of the Do What The Fuck You Want To Public License, Version 2,
# as published by Sam Hocevar. See the LICENSE file for more details.

set -e;

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
	CURRENT_DAY=$(echo "$(date +%j) + 0" | bc);
	echo $(($CURRENT_DAY*100/$TOTAL_DAYS));
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
	local BAR="";
	local BAR_NOW=$(DISPLAY);
	if [ -f "$WORKDIR"/bar ]; then
		BAR=$(cat "$WORKDIR"/bar);
	fi
	echo ">>> Bot started.";
	while true; do
		BAR_NOW=$(DISPLAY);
		if [ "$BAR" != "$BAR_NOW" ]; then
			curl -X POST "https://api.telegram.org/bot${API_TOKEN}/sendMessage" -d "chat_id=${CHAT_ID}&text=${BAR_NOW}";
			echo $BAR_NOW > "$WORKDIR"/bar;
			BAR=$BAR_NOW;
		fi
		sleep 100;
	done
}

MAIN;
