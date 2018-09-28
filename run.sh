#!/bin/sh

# i find "blue" renders better than "black" for white backgrounds
# shades of the color will be used to separ
COLOR='--color blue --background white'

# 8.5 x 11
SIZE_PRINT='--width 3300 --height 2550 --margin 30'
SIZE_PRINT_DRAFT='--width 1100 --height 850 --margin 10'
SIZE_WIDESCREEN='--width 1920 --height 1080 --margin 15'

WORDCLOUD='wordcloud_cli --stopwords stopwords.txt --relative_scaling 0.5'


control_c() {
    kill $PID
    exit
}

trap control_c SIGINT



for i in chap*.txt; do
    [ -f "$i" ] || break
	
	PID=$!
	
	# filename without extension
	filename=$(basename -- "$i")
	extension="${filename##*.}"
	filename="${filename%.*}"
	
	# Note: sed replacements require gnu-sed
	# remove gutenberg footnotes, [FN#1] etc.
	# remove roman numerals from chapter titles
	# remove footer (last three lines)
	# replace all 'Yog' to 'Yoga'
	ghead -n -3 $i \
	| gsed -Ee 's/\[FN.+\]//g' \
		-e 's/\bCHAPTER\b [I|V|X]+//g' \
		-e 's/\bYog\b/Yoga/g' \
		-e 's/\bBrahm\b/Brahman/g' \
	| $WORDCLOUD $COLOR $SIZE_PRINT_DRAFT --imagefile $filename.print.png 
	
	
	# wordcloud_cli $COLOR $SIZE_WIDESCREEN --text $i --imagefile $i.png
done

# special thanks to:
# https://stackoverflow.com/questions/965053/extract-filename-and-extension-in-bash
# https://sed.js.org/
# https://stackoverflow.com/questions/30003570/how-to-use-gnu-sed-on-mac-os-x
# https://stackoverflow.com/questions/1032023/sed-whole-word-search-and-replace
# https://stackoverflow.com/questions/10831764/combine-multiple-sed-commands
# https://stackoverflow.com/questions/7071444/use-sed-to-convert-roman-numerals-to-arabic-numerals
# https://stackoverflow.com/questions/5810232/catching-keyboard-interrupt/6759644

# text from:
# https://www.gutenberg.org/files/2388/2388-h/2388-h.htm
