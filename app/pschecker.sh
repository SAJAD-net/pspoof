#!/usr/bin/bash

installer() {

	if [ -d $HOME/.pschecker ]; then
		echo "[!]- this is also installed in --> $HOME/.pschecker !"
	else
		echo "[!]- installation started"
		ch=$(pwd)
		cd $HOME
		mkdir .pschecker
		cd .pschecker
		mkdir src
		mkdir out
		mkdir lib
		sr=$HOME/.pschecker/src
		cd $ch
		cp pschecker.sh $sr
		echo -n "[+]- are you want to mkae alias for pschecker [y/n] ? "
		read st
		cd $HOME
		if [[ $st == "y" || $st == "Y" ]]; then
			if [ $SHELL == "/usr/bin/zsh" ]; then
				sudo echo  alias pschecker=\"bash $HOME/.pschecker/src/pschecker.sh\" >> .zshrc;
			elif [ echo $SHELL == "/bin/bash" ]; then
				sudo echo  alias pschecker=\"bash $HOME/.pschecker/src/pschecker.sh\" >> .bashrc;
			fi
			echo "[!]- maked alias pschecker for you !"
		else
			echo "[!]- not maked alias pschecker for you !"
		fi
		cd $HOME/.pschecker/lib
		echo -n "[+]- are you want to run automatic of time's [y/n] ? "
		read t
		if [[ $t == "y" || $t == "Y" ]]; then

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
		echo "[!]- pschecker installed in $HOME/.pschecker/"
		echo "[!]- finished !"
	fi
}

configure() {
	initialize() {
		echo "time=1h" > config.conf
	}
	config() {
		echo -n "[+]- enter your time for run pschecker --> [{1..9d OR h OR m}] --> "
		read time
		echo time=$time > config.conf
		echo "[!]- config successfully changed !"
	}
}	

checker() {
	echo "[!]- started pschecker"
	cd $HOME/.pschecker/out/
	date >> logs
	ps -ef >> logs
	echo "[!]- copied result to $HOME/.pschecker/out/logs file "
	echo "[!]- finished !"
}

reader() {

	less $HOME/.pschecker/out/logs

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
else
	echo "[!]- enter valid argument !"
	echo """
	[1] -i --> install
	[2] -s --> start process gathering
	[3] -c --> configure
	[4] -r --> read logs
	""" 
fi
