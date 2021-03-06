#Typos
alias xs='cd'
alias vf='cd'
alias moer='more'
alias moew='more'
alias kk='ll'

#Navigation
alias cd..="cd .."
function cdn(){ for i in `seq $1`; do cd ..; done;}  # cd .. n-times e.g. cnd 4

# Aliases                                
alias install='sudo apt-get install'
alias remove='sudo apt-get remove'
alias update='sudo apt-get update'
alias upgrade='sudo apt-get update && sudo apt-get upgrade'

# Power
alias reboot="sudo shutdown -r now"
alias off="sudo shutdown -h now"

# Some random aliases
alias mkdir="mkdir -p"
alias myip="curl http://ipecho.net/plain; echo"
alias webify="mogrify -resize 690\> *.png" #requires imagemagick


alias cls=clear 						   # more cmd style alias
alias reload='source ~/.bashrc' 				   #reloads .bashrc
alias printBetween='tr -d "\n\r" < gts.phtml | grep -Po '".*?"' '  #print file content between ""
alias fuck='sudo $(history -p \!\!)'                               #redo previous command but with sudo
alias psgrep="ps aux | grep -v grep | grep -i -e VSZ -e"  #show process id of an app

extract () {
   if [ -f $1 ] ; then
       case $1 in
           *.tar.bz2)   tar xvjf $1    ;;
           *.tar.gz)    tar xvzf $1    ;;
           *.bz2)       bunzip2 $1     ;;
           *.rar)       unrar x $1       ;;
           *.gz)        gunzip $1      ;;
           *.tar)       tar xvf $1     ;;
           *.tbz2)      tar xvjf $1    ;;
           *.tgz)       tar xvzf $1    ;;
           *.zip)       unzip $1       ;;
           *.Z)         uncompress $1  ;;
           *.7z)        7z x $1        ;;
           *)           echo "don't know how to extract '$1'..." ;;
       esac
   else
       echo "'$1' is not a valid file!"
   fi
}

#Symfony aliases
alias sf="php app/console"
alias sfdev="php app/console --env=dev"
alias sfprod="php app/console --env=prod"
alias sfcc="rm -rf ./app/cache/*; sf doctrine:cache:clear-metadata; "
#GIT aliases

#create new branch from master
function newbranch(){
    git checkout master
    git pull
    git checkout -b $1
    git push origin $1
    git branch --set-upstream-to=origin/$1
    git branch
}

#feeds aliases
countAllOccurences(){
	if [ -z "$1" ]
  	then
		echo "Specify 1st argument - pattern";
		return 1;
	fi

	if [ -z "$2" ]
  	then
		echo "Specify 2nd argument - file";
		return 1;
	fi
	echo $(grep -ioR "$1" $2 | wc -l)
	
}

feedPrevCsv(){
	if [ -z "$1" ]
  	then
		echo "Specify 1st argument - csv file path";
		return 1;
	fi

	if [ -z "$2" ]
  	then
		echo "Specify 2nd argument - container of product";
		return 1;
	fi

	while IFS=, read name link
	do
		printf "\nI got: $name";
		feedPrev $link $name $2
	done < $1
}

function feedPrev(){
	if [ -z "$1" ]
  	then
		echo "Specify 1st argument - feed link";
		return 1;
	fi
	if [ -z "$2" ]
  	then
		echo "Specify 2nd argument - file name";
		return 1;
	fi
	if [ -z "$3" ]
  	then
		echo "Specify 3rd argument - product container";
		return 1;
	fi

	link=$1;
	name=$2;
	container=$3;

	#download
	#detect if compressed or not to save proper name
	downloaded=$name;
	zipped=false;
	if [[ $link == *"gZip"* ]]
	then
		downloaded="$name.gz";
		zipped=true;
	fi
	if [[ $link == *".gz"* ]]
	then
		downloaded="$name.gz";
		zipped=true;
	fi
	printf "\nDownloading $downloaded";

	#download
	wget $link -O $downloaded;
	#extract if compressed
	if [ "$zipped" = true ] ; then
    	gunzip $downloaded;
	fi	

	mime=$(file --mime-type $name);

	#detect if its csv or xml
	printf "\n$mime";
	if [[ $mime == *"xml"* ]]
	then
		count=$(grep -o "$container" $name | wc -l)
		printf "\nOccurences : $count";
	fi

	if [[ $mime == *"plain"* ]]
	then
		head -n 2 $name;
		count=$(wc -l $name);
		$count--;
		printf "\nOccurences : $count";
	fi
}
