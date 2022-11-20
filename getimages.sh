#!/bin/bash
DEFAULT_PATH="/home/gabe/Pictures/unknown.png"
LINKSFILENUMBER=1
while [[ -f "sex-pins-links$LINKSFILENUMBER.txt" ]]; do
	LINKSFILENUMBER=$(($LINKSFILENUMBER+1))
done
LINKSFILENUMBER=$(($LINKSFILENUMBER-1))
FIRSTTIMELOOP=1
for i in $(seq 1 $LINKSFILENUMBER); do
	if [[ $FIRSTTIMELOOP == 1 ]]; then
		echo "do you want to get 'sex-pins-links$i.txt'?"
		FIRSTTIMELOOP=0
	else
		echo "or get 'sex-pins-links$i.txt'?"
	fi
done
LINKSFILENUMBER=$(($LINKSFILENUMBER+1))
echo "input which number.."
read NUMBERINPUT
if [[ $NUMBERINPUT -gt $LINKSFILENUMBER  ]]; then
	echo "invalid input! must be less than $LINKSFILENUMBER"
	exit 0
fi
DATAFILENUMBER=1
while [[ -f "sex-pins-data$NUMBERINPUT-$DATAFILENUMBER.txt" ]]; do
	DATAFILENUMBER=$((DATAFILENUMBER+1))
done
touch "sex-pins-data$NUMBERINPUT-$DATAFILENUMBER.txt"
LINECOUNT=0
LINKS=$(cat "sex-pins-links$NUMBERINPUT.txt")
for LINE in $LINKS; do
	curl -sSL $LINE > tempfile.html
	cat tempfile.html | grep thumbnailUrl | grep content > tempfile0.txt
	TEMPVAR=$(grep -o '".*"' "tempfile0.txt" | sed 's/"//g')
	if [[ -n ${TEMPVAR:21} ]]; then
		echo ${TEMPVAR:21} >> "sex-pins-data$NUMBERINPUT-$DATAFILENUMBER.txt"
		LINECOUNT=$(($LINECOUNT+1))
		echo "success!! got $LINECOUNT lines of image links so far!"
	else
		echo $DEFAULT_PATH >> "sex-pins-data$NUMBERINPUT-$DATAFILENUMBER.txt"
		echo "bummer! got no link. appending default image path"
	fi
done
echo "removing 'tempfile.html'"
rm tempfile.html
echo "removing 'tempfile0.txt'"
rm tempfile0.txt
