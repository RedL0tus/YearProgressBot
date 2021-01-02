#!/usr/bin/env bash

# Copyright © 2018-2020 Kay <i@v2bv.net>
# This work is free. You can redistribute it and/or modify it under the
# terms of the Do What The Fuck You Want To Public License, Version 2,
# as published by Sam Hocevar. See the LICENSE file for more details.

set -euo pipefail;

function GET_PERCENTAGE {
	local CURRENT_YEAR;
	CURRENT_YEAR=$(date +%Y);
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
	echo $((CURRENT_DAY*100/TOTAL_DAYS));
}

function DISPLAY {
	local PERCENTAGE;
	PERCENTAGE=$(GET_PERCENTAGE);
	local FILLED=$((LENGTH*PERCENTAGE/100));
	local BLANK=$((LENGTH-FILLED));
	local BAR="";
	for ((i=0;i<FILLED;i++)) {
		BAR="${BAR}▓";
	}
	for ((i=0;i<BLANK;i++)) {
		BAR="${BAR}░";
	}
	echo "${BAR} ${PERCENTAGE}%";
}

function MAIN {
	local BAR_NOW;
	local BAR="";
	BAR_NOW=$(DISPLAY);
	if [ -f "$WORKDIR"/bar ]; then
		BAR=$(cat "$WORKDIR"/bar);
	fi
	echo ">>> Bot started.";
	while true; do
		BAR_NOW=$(DISPLAY);
		if [ "$BAR" == "$BAR_NOW" ]; then
			sleep 100;
			continue;
		fi
		curl -X POST \
			"https://api.telegram.org/bot${API_TOKEN}/sendMessage" \
			-d "chat_id=${CHAT_ID}&text=${BAR_NOW}";
		echo "$BAR_NOW" > "$WORKDIR"/bar;
		BAR="$BAR_NOW";
	done
}

MAIN;
