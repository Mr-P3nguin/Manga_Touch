#!/bin/sh

#############
# Functions #
#############
die ()	{
	err "$*"
	exit 1
}

err ()	{
	printf "\033[1;31m%s\033[0m\n" "$*" >&2
}

link ()	{
	echo "$1"
	temp=$(curl -As --silent $1 | sed 's/</\n/g')		
	echo "$temp" > file.txt
	exit
}

color_list ()	{
	clear
	max=$((($(echo "$1" | wc -l) + 4) / 5 - 1))
	echo " "	
	echo -e "\e[1;35m	MANGA_TOUCH \e[0m"
	echo " "
	echo -e "\e[1;31m    1)$(echo "$1" | head -n $(($3*5+1)) | tail -n 1)"
	echo -e "\e[1;32m    2)$(echo "$1" | head -n $(($3*5+2)) | tail -n 1)"
	echo -e "\e[1;33m    3)$(echo "$1" | head -n $(($3*5+3)) | tail -n 1)"
	echo -e "\e[1;34m    4)$(echo "$1" | head -n $(($3*5+4)) | tail -n 1)"
	echo -e "\e[1;36m    5)$(echo "$1" | head -n $(($3*5+5)) | tail -n 1)"
	echo " "
	echo -e "\e[1;39m    6)   Go Back One Page"
	echo -e "\e[1;39m    7)   Go Forward One Page"
	echo " "
	read -p $'\e[1;35m Please Select An Option: \e[0m' Selection
	
	case $Selection in
		1) link "$(echo "$2" | head -n $(($3*5+1)) | tail -n 1)";;
		2) echo "2";;
		3) echo "3";;
		4) echo "4";;
		5) echo "5";;
		6) if [ $3 == 0 ]; then
			color_list "$1" "$2" 0
		else
			color_list "$1" "$2" $(($3-1))
		fi;;
		7) if [ $3 == $max ]; then
			color_list "$1" "$2" $max
		else
			color_list "$1" "$2" $(($3+1))
		fi;;
		*) echo "NaN";;
	esac

	: '	
	for index in {1..5}
	do
		a=$(echo "$*" | head -n $index | tail -n 1)
	       	echo -e "\e[1;31m $a"
	done
	'
}

display_manga_list ()	{
	title=$(echo "$*" | grep 'item-title' | grep -Po 'title="\K[^"]*' | sed 's/^/	/g')
	links=$(echo "$*" | grep 'a-h text-nowrap item-title' | grep -Po 'href="\K[^"]*' | sed 's/^/	/g')
	color_list "$title" "$links" 0
	
}

search_manga ()		{
	read -p $'\e[1;35m Search Manga: \e[0m' search #add -sp for not showing entry
	results=$(curl -As --silent "https://manganato.com/search/story/$search" | sed 's/>/\n/' | sed 's/<//g') # | grep 'item-chapter\|item-author\|item-time\|item-title') # | grep -oP '\>.*<')
	#Make sure you can enter special chars even space
	display_manga_list echo "$results" 
}

#########
# Start #
#########

while :; do
	clear
	search_manga
	break
done
#reset
exit
	


item-chapter
item-author
item-time
item-title


##########
# Config #
##########
