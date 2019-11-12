#!/bin/bash
# Get info
echo "•"
echo "---"
font="Microsoft Sans Serif"
color="black"
date "+%k:%M"
power_source=($(pmset -g batt | awk 'FNR == 1 {print $4$NF}'))
battery_level=($(pmset -g batt | awk -F"\t" 'FNR == 2 {print $2}' | grep -o '[0-9]\+'))
battery_status=($(pmset -g batt | awk -F";" 'FNR == 2 {print $2}'))
remaining_time=($(pmset -g batt | awk -F";" 'FNR == 2 {print $3}'))
batt_condition=($(system_profiler SPPowerDataType | grep "Condition" | awk '{print $2}'))
batt_cycles=($(system_profiler SPPowerDataType | grep "Cycle Count" | awk '{print $3}'))

# Format things
if [ "$power_source" = "'ACPower'" ]; then
	source_label="AC Power"
	time_label="Charged in:"
else
	source_label="Internal Battery"
	time_label="Time remaining:"
fi

if [ "$remaining_time" = "(no" ]; then remaining_time="Calculating..."; fi

if [ "$battery_status" = "charged" ]; then
	battery_status="Charged"
elif [ "$battery_status" = "discharging" ]; then
	battery_status="Discharging"
elif [ "$battery_status" = "charging" ]; then
	battery_status="Charging"
else
	battery_status="Finalising charge"
fi

# Get the current charge interval
if [ "$power_source" = "'ACPower'" ]; then
	lvl="charging" img_base=""
else
	if [ "$battery_level" -gt 95 ] && [ "$battery_level" -le 100 ]; then
		lvl="0"
	elif [ "$battery_level" -gt 90 ] && [ "$battery_level" -le 95 ]; then
		lvl="1"
	elif [ "$battery_level" -gt 85 ] && [ "$battery_level" -le 90 ]; then
		lvl="2"
	elif [ "$battery_level" -gt 80 ] && [ "$battery_level" -le 85 ]; then
		lvl="3"
	elif [ "$battery_level" -gt 75 ] && [ "$battery_level" -le 80 ]; then
		lvl="4"
	elif [ "$battery_level" -gt 70 ] && [ "$battery_level" -le 75 ]; then
		lvl="5"
	elif [ "$battery_level" -gt 65 ] && [ "$battery_level" -le 70 ]; then
		lvl="6"
	elif [ "$battery_level" -gt 60 ] && [ "$battery_level" -le 65 ]; then
		lvl="7"
	elif [ "$battery_level" -gt 55 ] && [ "$battery_level" -le 60 ]; then
		lvl="8"
	elif [ "$battery_level" -gt 50 ] && [ "$battery_level" -le 55 ]; then
		lvl="9"
	elif [ "$battery_level" -gt 45 ] && [ "$battery_level" -le 50 ]; then
		lvl="10"
	elif [ "$battery_level" -gt 40 ] && [ "$battery_level" -le 45 ]; then
		lvl="11"
	elif [ "$battery_level" -gt 35 ] && [ "$battery_level" -le 40 ]; then
		lvl="12"
	elif [ "$battery_level" -gt 30 ] && [ "$battery_level" -le 35 ]; then
		lvl="13"
	elif [ "$battery_level" -gt 25 ] && [ "$battery_level" -le 30 ]; then
		lvl="14"
	elif [ "$battery_level" -gt 20 ] && [ "$battery_level" -le 25 ]; then
		lvl="15"
	elif [ "$battery_level" -gt 15 ] && [ "$battery_level" -le 20 ]; then
		lvl="16"
	elif [ "$battery_level" -gt 10 ] && [ "$battery_level" -le 15 ]; then
		lvl="17"
	elif [ "$battery_level" -gt 5 ] && [ "$battery_level" -le 10 ]; then
		lvl="18"
	elif [ "$battery_level" -gt 0 ] && [ "$battery_level" -le 5 ]; then
		lvl="19"
	fi
fi

# Reconstruct the icon
suffix=b$lvl
reconstructed_img=$img_base${!suffix}

# Set the display text
display_text="Battery $battery_level%"

# Generate the final output
display_output="$display_text | image=$reconstructed_img size=12"

# Actually display stuff
echo "$display_output | refresh=true"

# Dropdown info
echo "---"

echo "Source: $source_label"
echo "Current charge: $battery_level%"
echo "Status: $battery_status"
if [ "$remaining_time" != "0:00" ] && [ "$battery_status" != "Charged" ]; then
	echo "$time_label $remaining_time"
fi

echo "---"

echo "Cycles: $batt_cycles"
echo "Condition: $batt_condition"

#-------------------------------------------------- CAMBIO-------------------------------------------------- #

#Comment out these lines to remove "last month"
last_month=$(date -v-1m +%m)
last_year=$(date -v-1m +%Y)
last_month_name=$(date -jf %Y-%m-%d "$last_year"-"$last_month"-01 '+%b')
echo "Prev: $last_month_name $last_year|trim=false font=$font"
cal -d "$last_year"-"$last_month" | awk 'NF' | sed 's/ *$//' | while IFS= read -r i; do echo "--$i|trim=false font=$font"; done
echo "---"

#cal |awk 'NF'|while IFS= read -r i; do echo " $i|trim=false font=$font color=$color"|  perl -pe '$b="\b";s/ _$b(\d)_$b(\d) /(\1\2)/' |perl -pe '$b="\b";s/_$b _$b(\d) /(\1)/' |sed 's/ *$//'; done

cal | awk 'NF' | while IFS= read -r i; do echo " $i" | perl -pe '$b="\b";s/ _$b(\d)_$b(\d) /(\1\2)/' | perl -pe '$b="\b";s/_$b _$b(\d) /(\1)/' | sed 's/ *$//' | sed "s/$/|trim=false font=$font color=$color/"; done

#Comment out these lines to remove "next month"
echo "---"
next_month=$(date -v+1m +%m)
next_year=$(date -v+1m +%Y)
next_month_name=$(date -jf %Y-%m-%d "$next_year"-"$next_month"-01 '+%b')
echo "Next: $next_month_name $next_year|trim=false font=$font"
cal -d "$next_year"-"$next_month" | awk 'NF' | sed 's/ *$//' | while IFS= read -r i; do echo "--$i|trim=false font=$font"; done
