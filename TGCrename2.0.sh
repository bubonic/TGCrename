#!/bin/bash

#filetype = `ls -1 | head -1 | awk -F '.' '{print $2}'`

if [ $# -lt 1 ]; then
	echo "Usage: $0 [y_option] [bulkfile]"
	echo "y_option :"
	echo "	-n Don't trust the renaming scheme and be prompted to rename each file"
	echo " 	-y Trust the renaming a little bit (recommended)"
	echo " 	-yy Trust the renaming fully (not recommended)"
	echo "bulkfile (optional) - an optional argument to specify an absolute path to a file containg TGC directory names to run this renaming in bulk"
	echo ""
	exit
fi

FILETYPE=(.mp4 .wmv .mkv .m4v .avi .flv .AVI .mov .m4a)
ytoall=$1
BULKFILE=$2
LFILES=()
TITLE=$CNAME" (TGC"$CNUM") S01E"
DIR=`pwd`
TGCFILE=$DIR"/AllTGCnameno.csv"
lev=()
answer="y"
i=0

getCourseNameFromDIR() {
	COURSENAME=`echo $DIRNAME | sed 's/TTC - //g'`
	COURSENAME=`echo $COURSENAME | sed 's/TTC//g'`
	COURSENAME=`echo $COURSENAME | sed 's/Video //g'`
	COURSENAME=`echo $COURSENAME | sed 's/VIDEO //g'`
	COURSENAME=`echo $COURSENAME | sed 's/\[//g'`
	COURSENAME=`echo $COURSENAME | sed 's/\]//g'`
	COURSENAME=`echo $COURSENAME | sed 's/^[ \t]*//'`
	echo "Course Name: $COURSENAME"
}


getMultiFiles() {
	while [ "$i" -lt "${#FILETYPE[@]}" ]; do
        	filetmp=`ls -m | grep "${FILETYPE[$i]}"`
        	lret=$?
		shopt -s nullglob
		LFILES=(*${FILETYPE[$i]})
		if [ "$lret" -eq "0" ]; then
			break
		fi
        	let i++
	done
}

levenshtein() {
    if [ "$#" -ne "2" ]; then
        echo "Usage: $0 word1 word2" >&2
    elif [ "${#1}" -lt "${#2}" ]; then
        levenshtein "$2" "$1"
    else
        local str1len=$((${#1}))
        local str2len=$((${#2}))
        local d i j
        for i in $(seq 0 $(((str1len+1)*(str2len+1)))); do
            d[i]=0
        done
        for i in $(seq 0 $((str1len))); do
            d[$((i+0*str1len))]=$i
        done
        for j in $(seq 0 $((str2len))); do
            d[$((0+j*(str1len+1)))]=$j
        done

        for j in $(seq 1 $((str2len))); do
            for i in $(seq 1 $((str1len))); do
                [ "${1:i-1:1}" = "${2:j-1:1}" ] && local cost=0 || local cost=1
                local del=$((d[(i-1)+str1len*j]+1))
                local ins=$((d[i+str1len*(j-1)]+1))
                local alt=$((d[(i-1)+str1len*(j-1)]+cost))
                d[i+str1len*j]=$(echo -e "$del\n$ins\n$alt" | sort -n | head -1)
            done
        done
        echo ${d[str1len+str1len*(str2len)]}
    fi
}
findCourseTitle() {
	COURSEtmp=`$DIR/levenstein.pl "$COURSENAME" "$TGCFILE"`
	COURSE=`echo $COURSEtmp | awk -F "[" '{print $1}'`
	COURSENO=`echo $COURSEtmp | awk -F "[" '{print $2}'`
	echo "---------------------------------------------- "
	echo "Course Name: $COURSE"
	echo "Course No.: $COURSENO"
	if [ "$ytoall" == "-yy" ]; then
		TITLE=$COURSE" (TGC"$COURSENO") S01E"
	else
		read -p "Is this correct? (y/n): " answer
	fi
	if [ "$answer" == "y" ]; then
		TITLE=$COURSE" (TGC"$COURSENO") S01E"
	elif [ "$answer" == "n" ]; then
		echo "Enter the Course name and Course No. manually"
		echo -ne "Course Name: "
		read CNAME
		echo -ne "Course No.: "
		read CNUM
		TITLE=$CNAME" (TGC"$CNUM") S01E"
	fi
}
renameLFILES() {
	while [ "$i" -lt "${#LFILES[@]}" ]; do
		temp=`echo ${LFILES[$i]} | grep -i "s01E[0-9][0-9]"`
		result=$?
		if [ "$result" -eq "0" ]; then
			mv "${LFILES[$i]}" "`echo ${LFILES[$i]} | perl -p -e 's/.*S01E//gi'`"
		fi
		temp=`echo ${LFILES[$i]} | grep -i "L[0-9]"`
		result=$?
		if [ "$result" -eq "0" ]; then
			mv "${LFILES[$i]}" "`echo ${LFILES[$i]} | perl -p -e 's/^L//gi'`"
		fi
		temp=`echo ${LFILES[$i]} | grep -i "lecture-"`
		result=$?
		if [ "$result" -eq "0" ]; then
#			mv "${LFILES[$i]}" "`echo ${LFILES[$i]} | sed 's/.*[Ll]ecture-//g'`"
			mv "${LFILES[$i]}" "`echo ${LFILES[$i]} | perl -p -e 's/.*lecture-//gi'`"
		fi
		temp=`echo ${LFILES[$i]} | grep -i "lecture [0-9][0-9]"`
		result=$?
		if [ "$result" -eq "0" ]; then
#			mv "${LFILES[$i]}" "`echo ${LFILES[$i]} | sed 's/.*[Ll]ecture //g'`"
			mv "${LFILES[$i]}" "`echo ${LFILES[$i]} | perl -p -e 's/.*lecture //gi'`"
		fi
		temp=`echo ${LFILES[$i]} | grep -i "lecture[0-9][0-9]"`
        	result=$?
        	if [ "$result" -eq "0" ]; then
#               	 mv "${LFILES[$i]}" "`echo ${LFILES[$i]} | sed 's/.*[Ll]ecture//g'`"
                	mv "${LFILES[$i]}" "`echo ${LFILES[$i]} | perl -p -e 's/.*lecture//gi'`"
        	fi
        	temp=`echo ${LFILES[$i]} | grep -i "lect[0-9][0-9]"`
        	result=$?
        	if [ "$result" -eq "0" ]; then
#               	 mv "${LFILES[$i]}" "`echo ${LFILES[$i]} | sed 's/.*[Ll][Ee][Cc][Tt]/g'`"
                	mv "${LFILES[$i]}" "`echo ${LFILES[$i]} | perl -p -e 's/.*?lect/\1/i'`"
        	fi
		temp=`echo ${LFILES[$i]} | grep -i "_[0-9]{3,4}"`
		result=$?
		if [ "$result" -eq "0" ]; then
			mv "${LFILES[$i]}" "`echo ${LFILES[$i]} | perl -p -e 's/.*_[0-9]{3,4}//gi'`"
		fi
		temp=`echo ${LFILES[$i]} | grep -i "session-[0-9][0-9]"`
		result=$?
		if [ "$result" -eq "0" ]; then
			mv "${LFILES[$i]}" "`echo ${LFILES[$i]} | perl -p -e 's/.*session-//gi'`"
		fi
		temp=`echo ${LFILES[$i]} | grep -i "Lesson "`
		result=$?
		if [ "$result" -eq "0" ]; then
			mv "${LFILES[$i]}" "`echo ${LFILES[$i]} | perl -p -e 's/.*Lesson //gi'`"
		fi
		temp=`echo ${LFILES[$i]} | grep -i "_[0-9][0-9]\."`
		result=$?
		if [ "$result" -eq "0" ]; then
			mv "${LFILES[$i]}" "`echo ${LFILES[$i]} | perl -p -e 's/.*_//gi'`"
		fi

		let i++
	done
}
finishRenameLFILES() {
	while [ "$i" -lt "${#LFILES[@]}" ]; do
		if [ "$ytoall" == "-y" ] || [ "$ytoall" == "-yy" ]; then
			mv "${LFILES[$i]}" "$TITLE${LFILES[$i]}"
		elif [ "$ytoall" == "-n" ]; then
			echo -ne "Rename ${LFILES[$i]} to $TITLE${LFILES[$i]} (y/n)"
			read rnresp
			if [ "$rnresp" == "y" ]; then
				mv "${LFILES[$i]}" "$TITLE${LFILES[$i]}"
			else
				echo -ne "Rename ${LFILES[$i]} to: "
				read newname
				mv "${LFILES[$i]}" "$newname"
			fi
		else
			echo "I'm unaware of an option: $ytoall"
			break
		fi
		let i++
	done
}

if [ ! -z $BULKFILE ]; then
	while IFS='' read -u 3 -r path || [[ -n "$path" ]]; do
                echo "Changing to directory: $path"
                cd "$path"
		DIRNAME=${PWD##*/}
		getCourseNameFromDIR
		findCourseTitle
		getMultiFiles
		i=0
		renameLFILES
		i=0
		unset LFILES
		getMultiFiles
		i=0
		finishRenameLFILES
	done 3< "$BULKFILE"
	exit

else
	echo -ne "Enter absolute path  of the TGC course files: "
	read CDIR
	echo "changing directory to $CDIR"
	cd "$CDIR"
	DIRNAME=${PWD##*/}
	getCourseNameFromDIR
	findCourseTitle
	getMultiFiles
	i=0
	renameLFILES
	i=0
	unset LFILES
	getMultiFiles
	i=0
	finishRenameLFILES
fi
