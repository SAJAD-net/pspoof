#!/usr/bin/bash

help() {
	echo """[!]- * pspoof help *

	[1]- pspoof -i #--> install install
	[2]- pspoof -c #--> configure
	[3]- pspoof -s #--> start gathering
	[4]- pspoof -r #--> read logs
	[5]- pspoof -h #--> help

	[!]- how to configure :

		minute    hour    day-of-month   month   day-of-week

	   (*,1..59) (*,1..24) (*,1..31)   (*,1..12)  (*,1..7)

		59	*	  *	        *	  *"""
}
installer() {

	if [ -d $HOME/.pspoof ]; then
		echo "[!]- this is also installed in --> $HOME/.pspoof !"
	else
		echo "[!]- installation started"
		ch=$(pwd)
		cd $HOME
		mkdir .pspoof
		cd .pspoof
		mkdir src
		mkdir out
		mkdir lib
		sr=$HOME/.pspoof/src
		cd $ch
		cp pspoof.sh $sr
		cd ..
		cp README.md $HOME/.pspoof/
		echo -n "[+]- are you want to mkae alias for pspoof [y/n] ? "
		read st
		cd $HOME
		if [[ $st == "y" || $st == "Y" ]]; then
			if [ $SHELL == "/usr/bin/zsh" ]; then
				sudo echo  alias pspoof=\"bash $HOME/.pspoof/src/pspoof.sh\" >> .zshrc;
			elif [ echo $SHELL == "/bin/bash" ]; then
				sudo echo  alias pspoof=\"bash $HOME/.pspoof/src/pspoof.sh\" >> .bashrc;
			fi
			echo "[!]- maked alias pspoof for you !"
		else
			echo "[!]- not maked alias pspoof for you !"
		fi
		cd $HOME/.pspoof/lib
		echo -n "[+]- are you want to run automatic of time's [y/n] ? "
		read t
		if [[ $t == "y" || $t == "Y" ]]; then
			echo "[!]- ok"
			echo -n "[+]- are you want to default configure app time to run [y/n] ? "
			read sm
			if [[ $sm == "y" || $sm == "Y" ]]; then
				configure
				initialize
			else
				configure
				config 
			fi
		fi
		echo "[!]- pspoof installed in $HOME/.pspoof/"
		echo "[!]- finished !"
	fi
}

configure() {
	initialize() {
		echo "59	*	*	*	*	$USER	bash $HOME/.pspoof/src/pspoof.sh -s >> pspoof >> $HOME/.pspoof/out/logs" > pspoof
		sudo cp pspoof /etc/cron.d/
	}
	config() {
		echo -n "[+]- are you want to see help of configure [y/n] ?"
		read n
		if [[ $n == "y" || $m == "Y" ]]; then
			help
		fi	
		echo -n "[+]- enter your time for run pspoof [seperator={1}space] --> "
		read time
		#TODO: check a time is valid
		echo "$time	$USER	bash $HOME/.pspoof/src/pspoof.sh -s >>  $HOME/.pspoof/out/logs" > pspoof
		sudo cp pspoof /etc/cron.d/
		echo "[!]- config successfully changed !"
	}
}	

checker() {
	cd $HOME/.pspoof/out/
	date >> logs
	echo "[S]--> --> --> -->" >> logs
	echo "[!]- started pspoof"
	date >> pspoof
	echo "[S]--> --> --> -->" >> pspoof
	ps -ef >> pspoof
	echo "[E]<-- <-- <-- <--" >> pspoof
	echo "[!]- copied result to $HOME/.pspoof/out/pspoof file "
	echo "[!]- finished !"
	echo "[E]<-- <-- <-- <--" >> logs
}

reader() {

	less $HOME/.pspoof/out/pspoof

}

if [[ $1 == "-i" || $2 == "-i" ]]; then
	installer
elif [[ $1 == "-s" || $2 == "-s" ]]; then 
	checker
elif [[ $1 == "-c" || $2 == "-c" ]]; then
	configure
	config
elif [[ $1 == "-r" || $2 == "-r" ]]; then
	reader
elif [[ $1 == "-h" || $2 == "-h" ]]; then
	help
else
	echo "[!]- enter valid argument !"
	echo """
	[1] -i --> install
	[2] -s --> start process gathering
	[3] -c --> configure
	[4] -r --> read logs
	[5] -h --> help
	""" 
fi
