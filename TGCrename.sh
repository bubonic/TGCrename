#!/bin/bash

#filetype = `ls -1 | head -1 | awk -F '.' '{print $2}'`

FILETYPE=(.mp4 .wmv .mkv .m4v .avi)
ytoall=$1
LFILES=()
TITLE=$CNAME" (TGC"$CNUM") S01E"
DIRNAME=${PWD##*/}
TGCFILE="AllTGC_TItlesandCNonly.csv"
lev=()
answer="y"
i=0

COURSENAME=`echo $DIRNAME | sed 's/TTC - //g'`
COURSENAME=`echo $COURSENAME | sed 's/TTC//g'`
COURSENAME=`echo $COURSENAME | sed 's/Video //g'`
COURSENAME=`echo $COURSENAME | sed 's/VIDEO //g'`
COURSENAME=`echo $COURSENAME | sed 's/\[//g'`
COURSENAME=`echo $COURSENAME | sed 's/\]//g'`
COURSENAME=`echo $COURSENAME | sed 's/^[ \t]*//'`

echo "Course Name: $COURSENAME"
#firstChar="${COURSENAME:0:1}"

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
i=0
#
#while read str2; do
#	lev[$i]=$(levenshtein "$COURSENAME" "$str2");
#	ele=${lev[$i]}
#	if [ "$i" -eq "0" ]; then
#		min="$ele"
#		min_index="$i"
#	fi
#	if [ "$ele" -lt "$min" ]; then
#		min="$ele"
#		min_index="$i"
#		COURSEtmp="$str2"
#	fi
#       echo "$COURSENAME / $str2 : ${lev[$i]}"
#	let i++
#done < <(cat $TGCFILE | grep "^$firstChar.*$")
COURSEtmp=`./levenstein.pl "$COURSENAME" "$TGCFILE"`
COURSE=`echo $COURSEtmp | awk -F "[" '{print $1}'`
COURSENO=`echo $COURSEtmp | awk -F "[" '{print $2}'`
echo " "
echo "Course Name: $COURSE"
echo "Course No.: $COURSENO"
if [ "$ytoall" == "-yy" ]; then
	TITLE=$COURSE" (TGC"$COURSENO") S01E"
else
	echo -ne "Is this correct (y/n):"
	read answer
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

getMultiFiles
i=0
while [ "$i" -lt "${#LFILES[@]}" ]; do
	temp=`echo ${LFILES[$i]} | grep -i "_[0-9][0-9]"`
	result=$?
	if [ "$result" -eq "0" ]; then
		mv "${LFILES[$i]}" "`echo ${LFILES[$i]} | perl -p -e 's/.*_[0-9][0-9]//gi'`"
	fi
	temp=`echo ${LFILES[$i]} | grep -i "s01E[0-9][0-9]"`
	result=$?
	if [ "$result" -eq "0" ]; then
		mv "${LFILES[$i]}" "`echo ${LFILES[$i]} | perl -p -e 's/.*S01E//gi'`"
	fi
	temp=`echo ${LFILES[$i]} | grep -i "^L[0-9]"`
	result=$?
	if [ "$result" -eq "0" ]; then
		mv "${LFILES[$i]}" "`echo ${LFILES[$i]} | perl -p -e 's/^L//gi'`"
	fi
	temp=`echo ${LFILES[$i]} | grep -i "lecture-"`
	result=$?
	if [ "$result" -eq "0" ]; then
#		mv "${LFILES[$i]}" "`echo ${LFILES[$i]} | sed 's/.*[Ll]ecture-//g'`"
		mv "${LFILES[$i]}" "`echo ${LFILES[$i]} | perl -p -e 's/.*lecture-//gi'`"
	fi
	temp=`echo ${LFILES[$i]} | grep -i "lecture[0-9][0-9]"`
        result=$?
        if [ "$result" -eq "0" ]; then
#                mv "${LFILES[$i]}" "`echo ${LFILES[$i]} | sed 's/.*[Ll]ecture//g'`"
                mv "${LFILES[$i]}" "`echo ${LFILES[$i]} | perl -p -e 's/.*lecture//gi'`"
        fi
        temp=`echo ${LFILES[$i]} | grep -i "lect[0-9][0-9]"`
        result=$?
        if [ "$result" -eq "0" ]; then
#                mv "${LFILES[$i]}" "`echo ${LFILES[$i]} | sed 's/.*[Ll][Ee][Cc][Tt]/g'`"
                mv "${LFILES[$i]}" "`echo ${LFILES[$i]} | perl -p -e 's/.*lect//gi'`"
        fi

	let i++
done
i=0
unset LFILES
getMultiFiles
i=0
while [ "$i" -lt "${#LFILES[@]}" ]; do
	if [ "$ytoall" == "-y" ] || [ "$ytoall" == "-yy" ]; then
		mv "${LFILES[$i]}" "$TITLE${LFILES[$i]}"
	elif [ -z "$ytoall" ]; then
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

