#!/bin/bash
# Flags for mandatory args and default values
SFLAG=false
TFLAG=false
RETRY_MAX=5
SCRIPT_ARG=
PWD=$(pwd)

# Echo help text
usage() { 
echo "$(basename "$0") -- shell script wrapper to retry command line scripts a set amount of times or until success 

Where:
    -h  Show this help text
    -s  Set the script to be run (example: retry.sh -s \"/usr/lib/myscript.sh -v\")
    -r  Max retries (default 5)" 1>&2; exit 1;
}

# Parse args
while getopts 's:r:h' option; do
	case "$option" in
		h) usage
		   ;;
		s) SCRIPT_ARG=${OPTARG}
		   SFLAG=true
		   ;;
		r) RETRY_MAX=${OPTARG}
		   TFLAG=true
		   ;;
		:) printf "Missing argument for -%s\n" "$OPTARG" >&2
		   usage
		   ;;
		\?) printf "Illegal option: -%s\n" "$OPTARG" >&2
		   usage 
		   ;;
	esac
done

shift $(($OPTIND -1))

# Check if mandatory args are set
if ! $SFLAG
then
	echo "A script must be speficied using the -s argument. (example: retry.sh -s \"/usr/lib/myscript.sh -v\")" >&2
	exit 1
fi

# Run the script specified in the args
runscript() {
	eval $SCRIPT_ARG
}

while [ $RETRY_MAX -gt 0 ]
do
	runscript
	if [ $? -eq 0 ]
	then
        	# Executing script returned 0 (succeded)
		RETRY_MAX=0
	else
		RETRY_MAX=$((RETRY_MAX-1));
        	# Executing script returned anything other than 0 (failed)
	fi

done

