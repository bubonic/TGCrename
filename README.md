# About

If you're like me and working on a headless machine with a PLEX server installed, you've probably had to do a bunch
of commands like:

> for i in *; do echo "FILE: $i" && mv "$i" "`echo "$i" | sed 's/.*lecture-//g'`"; done

and again and again until you got the TGC course video files named corretly. Well, I got tired of doing this so I 
wrote a shell and perl script to do all the work for us.

These three files:

* AllTGC_TItlesandCNonly.csv - All TGC course names and numbers separated by '['.
* levenstein.pl - A fuzzy matching algorithm written in PERL.
* TGCrename.sh - The brain (or heart) of it all.

will use the data in the directory name to find the best course match and will rename all the multimedia files
to an appropriate name that the TGC.bundle Agent can then use to collect metadtata.

# Usage

First, copy all files in this repository to the course directoryd:

> cp AllTGC_TItlesandCNonly.csv levenstein.pl TGCrename.sh directory_of_course_containing_lecture_files

Then cd to the course directory and run

> ./TGCrename [option]

There are two options that can be used:

-y , Trust TGCrename to automatically rename all the files, but will prompt for acceptance of matching course.
-yy , Fully trust TGCrename to do everything for you. i.e., it finds the correct course and names all the files correctly.

If you just run:

> ./TGCrename 

within the course directly, it will prompt for acceptance of course name and will prompt for acceptance to rename each file.

If you run:

> ./TGCrename -y

It will prompt for acceptance of the course name and will use that data to automatcially rename the files.

if you run:

> ./TGCrename -yy

It won't prompt you for any acceptance and will use the data collected to automatically rename the files. This means you are
fully trusting the program. (It tends to work almost all the time, but it's up to you what level of trust you would like).


