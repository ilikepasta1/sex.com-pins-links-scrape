if [[ -f "sex-pins-links.txt" ]]
then
	echo "removing and creating 'sex-pins-links.txt'.."
	rm "sex-pins-links.txt"
	touch "sex-pins-links.txt"
else
	echo "creating 'sex-pins-links.txt'.."
	touch "sex-pins-links.txt"
fi
WAIT_NUMBER=0
ALL_LINKS_NUMBER=0
PAGE_ARRAY=()
for PAGENUMBER in {1..55}
do
	echo "creating 'refined-links.txt'.."
	echo "" > refined-links.txt
	echo "getting 'www.sex.com/pins?page=$PAGENUMBER' html webpage.."
	wget "https://www.sex.com/pins?page=$PAGENUMBER" -qO sex-pins.html
	RAW_SEX_PINS=$(cat sex-pins.html | grep "/pin/")
	PINS_COUNT=0
	echo "getting pins links.."
	for PIN_LINE in $RAW_SEX_PINS
	do
		PIN_CONTAINS=$(echo $PIN_LINE | grep "/pin/")
		if [[ -n $PIN_CONTAINS ]]
		then
			PINS_COUNT=$(($PINS_COUNT + 1))
			echo $PIN_LINE >> refined-links.txt
		fi
	done
	echo "got $PINS_COUNT lines of pins"
	echo "creating 'refined-links1.txt'.."
	grep -o '".*"' refined-links.txt | sed 's/"//g' > refined-links1.txt
	echo "" > refined-links.txt
	PIN_LINKS=$(cat refined-links1.txt)
	PINS_ARRAY_NUMBER=0
	for PIN in $PIN_LINKS
	do
		if [[ ! ${PINS_ARRAY[*]} =~ ${PIN} ]]
		then
			PINS_ARRAY+=($PIN)
			PINS_ARRAY_NUMBER=$((PINS_ARRAY_NUMBER + 1))
			echo "www.sex.com$PIN" >> sex-pins-links.txt
		fi
	done
	ALL_LINKS_NUMBER=$(wc -l sex-pins-links.txt)
	echo "extracted $PINS_ARRAY_NUMBER links from 'refined-links1.txt'"
	echo "extracted $ALL_LINKS_NUMBER links in total"
	echo "deleting 'refined-links1.txt'.."
	rm refined-links1.txt
	echo "deleting 'refined-links.txt'.."
	rm refined-links.txt
	echo "wating $WAIT_NUMBER seconds.."
	sleep $WAIT_NUMBER
done
echo "deleting 'sex-pins.html'.."
rm sex-pins.html
