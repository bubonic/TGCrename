# About

If you're like me and working on a headless machine with a PLEX server installed, you've probably had to do a bunch
of commands like:

> for i in *; do echo "FILE: $i" && mv "$i" "`echo "$i" | sed 's/.*lecture-//g'`"; done

and again and again until you got the TGC course video files named corretly. Well, I got tired of doing this so I 
wrote a shell and perl script to do all the work for us.

TGCrename2.0.sh is a bulk TGC course renamer. TGCrename.sh is deprecated at this time as TGCrename2.0.sh handles single courses or a bulkfile list. 

These three files:

* AllTGC_TItlesandCNonly.csv - All TGC course names and numbers separated by '['.
* levenstein.pl - A fuzzy matching algorithm written in PERL.
* TGCrename.sh - The brain (or heart) of it all.

will use the data in the directory name to find the best course match and will rename all the multimedia files
to an appropriate name that the TGC.bundle Agent can then use to collect metadata.

# Usage

> ./TGCrename2.0.sh y_option [bulkfile]

There are two options that can be used:

-y , Trust TGCrename2.0.shto automatically rename all the files, but will prompt for acceptance of matching course.

-yy , Fully trust TGCrename2.0.shto do everything for you. i.e., it finds the correct course and names all the files correctly.

If you just run:

> ./TGCrename2.0.sh

it will show a usage menu

If you run:

> ./TGCrename2.0.sh -y

It will prompt for acceptance of the course name and will use that data to automatcially rename the files.

if you run: (not recommnded)

> ./TGCrename2.0.sh -yy

It won't prompt you for any acceptance and will use the data collected to automatically rename the files. This means you are
fully trusting the program. (It tends to work 52% of the time, but it's up to you what level of trust you would like).

if you run:

> ./TGCrename2.0 -y /home/bubonic/tgcfiles

where tgcfiles is a text file of directors containing your TGC lectures like the following:

> /home/bubonic/Downloads/TheGreatCourses/TTC - Great Music of the Twentieth Century

> /home/bubonic/Downloads/TheGreatCourses/TTC - Law School for Everyone

> /home/bubonic/Downloads/TheGreatCourses/TTC - Radio Astronomy

> /home/bubonic/Downloads/TheGreatCourses/TTC - The Great Trials of World History

> /home/bubonic/Downloads/TheGreatCourses/TTC - The Rise of Rome

> /home/bubonic/Downloads/TheGreatCourses/TTC - Understanding Imperial China

> /home/bubonic/Downloads/TheGreatCourses/TTC - Why You Are Who You Are

It will prompt for verification of the course found and rename all those found in the tgcfiles file. 


