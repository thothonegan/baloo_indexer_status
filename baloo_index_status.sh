#!/bin/bash

# Seconds to delay between each check
DELAY_TIME=10

# first pass
dbusRef=`kdialog --title "Baloo Status" --progressbar 'Connecting to baloo' 0`

while true; do
	orig=`balooctl status | head -n 3`
	baloo_status=`echo "$orig" | tail -n 2 | head -n 1`
	str=`echo "$orig" | tail -n 1`

	if [[ `echo "$str" | cut -d' ' -f 1` != "Indexed" ]]; then
		# done : do we really need this?
		qdbus ${dbusRef} close
		exit 0
	fi

	# otherwise parse
	initialValue=`echo "$str" | cut -d' ' -f 2`
	finalValue=`echo "$str" | cut -d' ' -f 4`

	qdbus ${dbusRef} setLabelText "${baloo_status}  (${initialValue} / ${finalValue} )"
	qdbus ${dbusRef} org.kde.kdialog.ProgressDialog.value $initialValue
	qdbus ${dbusRef} org.kde.kdialog.ProgressDialog.maximum $finalValue

	if [[ $? != 0 ]]; then
		exit 1 # dialog gone
	fi


	sleep ${DELAY_TIME}
done

