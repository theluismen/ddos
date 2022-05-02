#!/bin/bash

## FUNCTIONS
function FUNC_VERBOSE_INFO(){
	echo -e "URL:\t\t$1"
	[[ "$2" == "0" ]] && echo -e "HTTPS:\t\tDisabled" || echo -e "HTTPS:\t\tEnabled"
    echo -e "DELAY:\t\t$3"
    echo -e "REQUESTS:\t$4"
}

function FUNC_USAGE_INFO(){
	echo "usage: $1 -u <url> [-v] [-S] [-d <delay>] [-n <requests>]"
	echo -e "  -v\t\tverbose"
	echo -e "  -u <url>\tURL to send GET requests"
	echo -e "  -d <delay>\tDelay between GET requests"
	echo -e "  -n <requests>\tNumber of GET requests"
	echo -e "  -S\t\tEnable HTTPS"
}

## CONSTANTES Y VARIABLES
URL=''
NUMBER_OF_REQUESTS=1
MODE_HTTPS=0
MODE_VERBOSE=0
DELAY=0
CURL_COMMAND="curl"
## MAIN
# OPTIONS HANDLING
#  u -> url
#  S -> enable HTTPS
#  d -> delay between GET requests
#  n -> number of requests
while getopts ':Su:d:n:v' OPT; do
	case $OPT in
		'v')
			MODE_VERBOSE=1
		;;
		'S')
			MODE_HTTPS=1
		;;
		'u')
			URL=$OPTARG
		;;
		'd')
			DELAY=$OPTARG
		;;
		'n')
			NUMBER_OF_REQUESTS=$OPTARG
		;;
	esac
done

##  POSTHANDLING OPTIONS
# FORCE TO GIVE -u OPTION
if [[ -z $URL ]]; then
	FUNC_USAGE_INFO $(basename $0)
	exit 1
fi
# ENABLE HTTPS
if [[ $MODE_HTTPS ]]; then
	CURL_COMMAND="$CURL_COMMAND --ssl -k"
fi
# SHOW VERBOSE INFO
if [[ $MODE_VERBOSE -eq 1 ]]; then
	FUNC_VERBOSE_INFO $URL $MODE_HTTPS $DELAY $NUMBER_OF_REQUESTS
	echo
fi

##BUCLE PARA LAS PETICIONES
i=0
while (( $i < $NUMBER_OF_REQUESTS )); do
	$CURL_COMMAND $URL 2> /dev/null | grep "h2" | sed 's/^  *//g'
	sleep $DELAY
	(( i++ ))
done
