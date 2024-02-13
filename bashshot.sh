health=2
magazin=3
bullets=1
damage=1
fin=3

lensnum=0
lensnum1=$lensnum
lensnum2=$lensnum

handcuffsnum=0
handcuffsnum1=$handcuffsnum
handcuffsnum2=$handcuffsnum

beernum=0
beernum1=$beernum
beernum2=$beernum

cigarettenum=0
cigarettenum1=$cigarettenum
cigarettenum2=$cigarettenum

sawnum=0
sawnum1=$sawnum
sawnum2=$sawnum

healthbar1=$health
healthbar2=$health

bonusgenerator() {
	
	lensnum=0
	handcuffsnum=0
	beernum=0
	cigarettenum=0
	sawnum=0
	
	for ((i = 0; i < $[$level*2-bonussumcounter]; i++))
	do
		local bonuschooser=$[$RANDOM%5]
		if [ $bonuschooser == 0 ]
		then
			lensnum=$[$lensnum+1]
		elif [ $bonuschooser == 1 ]
		then
			handcuffsnum=$[$handcuffsnum+1]
		elif [ $bonuschooser == 2 ]
		then
			beernum=$[$beernum+1]
		elif [ $bonuschooser == 3 ]
		then
			cigarettenum=$[$cigarettenum+1]
		elif [ $bonuschooser == 4 ]
		then
			sawnum=$[$sawnum+1]
		fi
	done
}

bonusgiver() {
	bonussumcounter=$[$lensnum1+$handcuffsnum1+$beernum1+$cigarettenum1+$sawnum1]
	bonusgenerator
	lensnum1=$[$lensnum1+$lensnum]
	handcuffsnum1=$[$handcuffsnum1+$handcuffsnum]
	beernum1=$[beernum1+$beernum]
	cigarettenum1=$[$cigarettenum1+$cigarettenum]
	sawnum1=$[$sawnum1+$sawnum]
	
	bonussumcounter=$[$lensnum2+$handcuffsnum2+$beernum2+$cigarettenum2+$sawnum2]
	bonusgenerator
	lensnum2=$[$lensnum2+$lensnum]
	handcuffsnum2=$[$handcuffsnum2+$handcuffsnum]
	beernum2=$[beernum2+$beernum]
	cigarettenum2=$[$cigarettenum2+$cigarettenum]
	sawnum2=$[$sawnum2+$sawnum]
}

bonusinfo() {
clear
	echo -e "Лупа — позволяет посмотреть, какой патрон сейчас заряжен\n"
	
	echo -e "Сигареты — добавляют одно очко здоровья\n"

	echo -e "Банка пива — позволяет выстрелить в воздух\n"

	echo -e "Ножовка — отрезает часть дула, позволяя нанести двойной урон\n"

	echo -e "Наручники — противник пропускает ход\n"
	read 
}

bonuserror() {
	clear
	statusbar
	echo -e $current
	echo "у вас нет этого"
	sleep 2s
	clear
}

bonuses() {
	local lensnum=0
	local handcuffsnum=0
	local beernum=0
	local cigarettenum=0
	local sawnum=0
	if [ $current == $player1 ]
	then
		handcuffsnum=$handcuffsnum1
		lensnum=$lensnum1
		beernum=$beernum1
		cigarettenum=$cigarettenum1
		sawnum=$sawnum1
	else
		handcuffsnum=$handcuffsnum2
		lensnum=$lensnum2
		beernum=$beernum2
		cigarettenum=$cigarettenum2
		sawnum=$sawnum2
	fi
	clear
	statusbar
	echo -e $current", выбери бонус:"
	echo "1) лупа		"$lensnum
	echo "2) наручники	"$handcuffsnum
	echo "3) пиво		"$beernum
	echo "4) сигарета	"$cigarettenum
	echo "5) ножовка	"$sawnum
	echo "6) вернуться"
	echo "7) справка"
	local choose=0
	read choose
	if [ $choose == 1 ]
	then
		if [ $lensnum -gt 0 ]
		then
			lens
		else
			bonuserror
		fi
	elif [ $choose == 2 ]
	then
		if [ $handcuffsnum -gt 0 ]
		then
			handcuffs
		else
			bonuserror
		fi
	elif [ $choose == 3 ]
	then
		if [ $beernum -gt 0 ]
		then
			beer
		else
			bonuserror
		fi
	elif [ $choose == 4 ]
	then
		if [ $cigarettenum -gt 0 ]
		then
			cigarette
		else
			bonuserror
		fi
	elif [ $choose == 5 ]
	then
		if [ $sawnum -gt 0 ]
		then
			saw
		else
			bonuserror
		fi
	elif [ $choose == 7 ]
	then
		bonusinfo
		bonuses
	else
		clear
	fi
}

lens() {
	clear
	statusbar
	echo -e $current
	if [ $[gun[counter]] == 1 ]
	then 
		echo -e "\033[31mбоевой\033[0m"
		moodchanger=1
	else 
		echo -e "\033[32mхолостой\033[0m"
		moodchanger=0
	fi
	sleep 2s
	clear
	if [ $current == $player2 ]
	then
		lensnum2=$[$lensnum2-1]
	else
		lensnum1=$[$lensnum1-1]
	fi
}

handcuffs() {
	if [ $handcuffsstatus == 'Locked' ] || [ $handcuffsstatuslast == 'Locked' ]
	then
		clear
		statusbar
		echo -e $next "уже закован в наручники"
		sleep 2s
		clear
	else
		handcuffsstatus='Locked'
		if [ $current == $player2 ]
		then
			handcuffsnum2=$[$handcuffsnum2-1]
		else
			handcuffsnum1=$[$handcuffsnum1-1]
		fi
		clear
		statusbar
		echo -e $current "заковал" $next "в наручники"
		sleep 2s
		clear
	fi
}

beer() {
	if [ $current == $player2 ]
	then
		beernum2=$[$beernum2-1]
	else
		beernum1=$[$beernum1-1]
	fi
	clear
	statusbar
	echo -e $current "выпил пиво"
	sleep 2s
	clear
	statusbar
	echo -e $current "стреляет"
	sleep 2s
	clear
	statusbar
	if [ $[gun[counter]] == 1 ]
	then
		echo -e "\033[31mбах\033[0m"
	else
		echo -e "\033[32mщёлк\033[0m"
	fi
	counter=$[counter+1]
	sleep 2s
	clear
	damage=1
}

cigarette() {
	if [ $current == $player1 ]
	then
		cigarettenum1=$[$cigarettenum1-1]
		if [ $healthbar1 -gt 1 ] || [ 7 -gt $healthbar1 ]
		then
			healthbar1=$[healthbar1+1]
		fi
	else
		cigarettenum2=$[$cigarettenum2-1]
		if [ $healthbar2 -gt 1 ] || [ 7 -gt $healthbar2 ]
		then
			healthbar2=$[healthbar2+1]
		fi
	fi
	clear
	statusbar
	echo -e $current "покурил"
	sleep 2s
	clear
}

saw() {
	if [ $current == $player1 ]
	then
		sawnum1=$[$sawnum1-1]
	else
		sawnum2=$[$sawnum2-1]
	fi
	clear
	statusbar
	echo -e $current "сделал обрез"
	sleep 2s
	clear
	damage=2
}

shot() {
	clear
	statusbar
	if [ $target == 1 ]
	then
		echo -e $current "стреляет в себя"
		if [ $[gun[counter]] == 1 ]
		then
			playerchanger
		fi
	else
		echo -e $current "стреляет в" $next
	fi
	echo -e $shotresult
	sleep 1s
	clear
}

health() {
	if [ $winner == $player1 ]
	then
		healthbar2=$[$healthbar2-$damage]
	else
		healthbar1=$[$healthbar1-$damage]
	fi
	if [ 1 -gt $healthbar1  ] || [ 1 -gt $healthbar2 ]
	then
		gameover="True"
		echo -e "Выиграл "$winner"!"
		sleep 3
	fi
}

winnerqualifier() {
	if [ $[gun[counter]] == 1 ]
	then 
		shotresult="\033[31mбах\033[0m"
		bullets=$[$bullets-1]
		shot
		health
	else
		shotresult="\033[32mщёлк\033[0m"
		shot
	fi
}

playerchanger() {
	last=$current
	current=$next
	next=$last
	handcuffsstatuslast='Unlocked'
	handcuffsstatus='Unlocked'
}

dealerbonus() {
	if [ $moodchanger != 2 ]
	then
		if [ $current == $player1 ]
		then
			if [ $lensnum1 != 0 ] && [ $moodchanger == 1 ]
			then
				lens
			fi
			while [ $cigarettenum1 != 0 ]
			do
				cigarette
			done
			if [ $handcuffsnum1 != 0 ] && [ $handcuffsstatuslast == 'Unocked' ] && [ $handcuffsstatus == 'Unlocked' ]
			then
				local rand=$[$RANDOM%2]
				if [ $rand == 1 ]
				then
					handcuffs
					moodchanger=1
				fi
			fi
			if [ $sawnum1 != 0 ] && [ $moodchanger == 1 ] && [ $healthbar2 -gt 1 ]
			then
				saw
			fi
			if [ $beernum1 != 0 ]
			then
				local rand=$[$RANDOM%2]
				if [ $rand == 1 ] && [ $moodchanger == 1 ]
				then
					beer
				fi
			fi
		else
			if [ $lensnum2 != 0 ] && [ $moodchanger == 1 ]
			then
				lens
			fi
			while [ $cigarettenum2 != 0 ]
			do
				cigarette
			done
			if [ $handcuffsnum2 != 0 ] && [ $handcuffsstatuslast == 'Unocked' ] && [ $handcuffsstatus == 'Unlocked' ]
			then
				local rand=$[$RANDOM%2]
				if [ $rand == 1 ]
				then
					handcuffs
					moodchanger=1
				fi
			fi
			if [ $sawnum2 != 0 ] && [ $moodchanger == 1 ] && [ $healthbar1 -gt 1 ]  
			then
				saw
			fi
			if [ $beernum2 != 0 ]
			then
				local rand=$[$RANDOM%2]
				if [ $rand == 1 ] && [ $moodchanger == 0 ]
				then
					beer
				fi
			fi
		fi
	fi
}

dealer() {
	moodchanger=0
	local replic=$[$RANDOM%3+1]
	statusbar
	echo -e $current:
	if [ $replic == 1 ]
	then
		echo "хм"
	elif [ $replic == 2 ]
	then
		echo "интересно!"
	elif [ $replic == 3 ]
	then
		echo "..."
	fi
	sleep 1
	local chance=$[100*$bullets/$magazin]
	if [ $chance == 0 ]
	then
		moodchanger=2
	fi
	local rand=$[$[RANDOM%100+1]*$[100-$chance]/100]
	local mood=$[$chance+$rand]
	local plank=80
	local moodchangerplank=95
	if [ $mood -gt $moodchangerplank ]
	then
		moodchanger=1
	fi
	dealerbonus
	if [ $mood -gt $plank ] && [ $moodchanger == 0 ] || [ $moodchanger == 1 ]
	then
		target=2
		clear
		statusbar
		echo -e $current:
		echo "Ты готов умереть?"
		sleep 1.5
	else
		target=1
		clear
		statusbar
		echo -e $current:
		echo "Попытаем удачу?"
		sleep 1.5
	fi
}

targetchoosedialog() {
	statusbar
	echo -e $current", выбери цель:"
	echo "1) выстрелить в себя"
	echo "2) выстрелить в оппонента"
	echo "3) посмотреть бонусы"
	read target
	if [ $target == 3 ]
	then
		bonuses
		targetchoosedialog
	fi
}

targetchoose() {
	if [ $target == 1 ]
	then
		winner=$next
		winnerqualifier
	elif [ $target == 2 ]
	then
		winner=$current
		winnerqualifier
		if [ $handcuffsstatus != 'Locked' ]
		then
			playerchanger
		fi
		handcuffsstatuslast=$handcuffsstatus
		handcuffsstatus='Unlocked'
	else
		targetchoosedialog
	fi
}

statusbar() {	
	echo -e $player1"'s health: " $healthbar1" | "$player2"'s health: " $healthbar2" | level: "$[$level+1]
}

clear
echo "Первый участник, введите имя"
read player1
player1="\033[31m"$player1"\033[0m"
clear
echo "Второй участник, введите имя"
read player2
player2="\033[32m"$player2"\033[0m"
clear


magazingenerator() {
	for ((i = 0; i < $bullets; i++))
	do
		gun[i]=1
	done
	for ((i = $bullets; i < $magazin; i++))
	do
		gun[i]=0
	done
	statusbar
	echo ${gun[*]}
	sleep 3s
	clear
	for ((i = 0; i < $magazin; i++))
	do
		changerid1=$[$RANDOM%$magazin]
		changerid2=$i
		changer=${gun[changerid1]}
		gun[changerid1]=${gun[changerid2]}
		gun[changerid2]=$changer
	done
}

magazinregen() {
		clear
		counter=0
		magazinlen=$[$[2**$level]*3]
		bulletsnum=$[1+$[$[$level]*3]]
		magazin=$magazinlen
		bullets=$bulletsnum
		magazingenerator
		bonusgiver
}

counter=0
level=0
current=$player1
next=$player2
last="empty"
gameover="False"
handcuffsstatus="Unlocked"
handcuffsstatuslast="Unlocked"

magazinregen

while [ $level != $fin ]
do
	if [ $current != '\033[31mdealer\033[0m' ] && [ $current != '\033[32mdealer\033[0m' ]
	then
		targetchoosedialog
	else
		dealer
	fi
	targetchoose
	magazin=$[$magazin-1]
	counter=$[$counter+1]
	damage=1
	if [ $counter == $magazinlen ]
	then
		magazinregen
	fi
	if [ $gameover != "False" ]
	then
		level=$[$level+1]
		if [ $level != $fin ]
		then
			clear
			echo "level up"
			sleep 3
			clear
			gameover="False"
			health=$[$health+$level]
			healthbar1=$health
			healthbar2=$health
			magazinregen
		fi
	fi
done
