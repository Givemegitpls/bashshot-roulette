health=2
magazin=3
bullets=1
damage=1
fin=3

lensnum=0
lenscounter[1]=$lensnum
lenscounter[2]=$lensnum

handcuffsnum=0
handcuffscounter[1]=$handcuffsnum
handcuffscounter[2]=$handcuffsnum

beernum=0
beercounter[1]=$beernum
beercounter[2]=$beernum

cigarettenum=0
cigarettecounter[1]=$cigarettenum
cigarettecounter[2]=$cigarettenum

sawnum=0
sawcounter[1]=$sawnum
sawcounter[2]=$sawnum

healthbar[1]=$health
healthbar[2]=$health

bonusgenerator() {
	
	lensnum=0
	handcuffsnum=4
	beernum=0
	cigarettenum=0
	sawnum=0
	
	for ((a = 0; a < $[$level*2-bonussumcounter]; a++))
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
	for ((i = 1; i < 3; i++))
	do
		bonussumcounter=$[${lenscounter[i]}+${handcuffscounter[i]}+${beercounter[i]}+${cigarettecounter[i]}+${sawcounter[i]}]
		bonusgenerator
		lenscounter[i]=$[${lenscounter[i]}+$lensnum]
		handcuffscounter[i]=$[${handcuffscounter[i]}+$handcuffsnum]
		beercounter[i]=$[${beercounter[i]}+$beernum]
		cigarettecounter[i]=$[${cigarettecounter[i]}+$cigarettenum]
		sawcounter[i]=$[${sawcounter[i]}+$sawnum]
	done
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
		local i=1
	else
		local i=2
	fi
	handcuffsnum=${handcuffscounter[i]}
	lensnum=${lenscounter[i]}
	beernum=${beercounter[i]}
	cigarettenum=${cigarettecounter[i]}
	sawnum=${sawcounter[i]}
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
	elif [ $choose == 6 ]
	then
		clear
	elif [ $choose == 7 ]
	then
		bonusinfo
		bonuses
	else
		clear
		bonuses
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
		local i=2
		lenscounter[i]=$[${lenscounter[i]}-1]
	else
		local i=1
		lenscounter[i]=$[${lenscounter[i]}-1]
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
		if [ $current == $player1 ]
		then
			local i=1
		else
			local i=2
		fi
		handcuffscounter[i]=$[${handcuffscounter[i]}-1]
		clear
		statusbar
		echo -e $current "заковал" $next "в наручники"
		sleep 2s
		clear
	fi
}

beer() {
	if [ $current == $player1 ]
	then
		local i=1
	else
		local i=2
	fi
	beercounter[i]=$[${beercounter[i]}-1]
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
	if [ $[gun[$counter]] == 1 ]
	then
		echo -e "\033[31mбах\033[0m"
		bullets=$[$bullets-1]
	else
		echo -e "\033[32mщёлк\033[0m"
	fi
	counter=$[$counter+1]
	magazin=$[$magazin-1]
	if [ $counter -gt $[$magazinlen-1] ]
	then
		magazinregen
	fi
	sleep 2s
	clear
	damage=1
}

cigarette() {
	if [ $current == $player1 ]
	then
		local i=1
	else
		local i=2
	fi
	cigarettecounter[i]=$[${cigarettecounter[i]}-1]
	if [ ${healthbar[i]} == 1 ] && [ $level == 2 ]
	then
		clear
		statusbar
		echo "здоровье не восполенено"
		sleep 2
		clear
	else
		if [ 7 -gt ${healthbar[i]} ]
		then
			healthbar[i]=$[${healthbar[i]}+1]
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
		local i=1
	else
		local i=2
	fi
	sawcounter[i]=$[${sawcounter[i]}-1]
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
		local i=2
	else
		local i=1
	fi
	healthbar[i]=$[${healthbar[i]}-$damage]
	if [ 1 -gt ${healthbar[1]}  ] || [ 1 -gt ${healthbar[2]} ]
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
 
# playerchangemessage() {
# 	clear
# 	echo -e "\033[31mСмена игроков\033[0m"
# 	sleep 2s
# 	clear
# }

dealerbonus() {
	if [ $moodchanger != 2 ]
	then
		if [ $current == $player1 ]
		then
			local i=1
		else
			local i=2
		fi
		if [ ${lenscounter[i]} != 0 ] && [ $moodchanger == 1 ]
		then
			lens
		fi
		while [ ${cigarettecounter[i]} != 0 ]
		do
			cigarette
		done
		if [ ${handcuffscounter[i]} != 0 ] && [ $handcuffsstatuslast == 'Unlocked' ] && [ $handcuffsstatus == 'Unlocked' ]
		then
			local rand=$[$RANDOM%2]
			if [ $rand == 1 ]
			then
				handcuffs
				moodchanger=1
			fi
		fi
		if [ ${sawcounter[i]} != 0 ] && [ $moodchanger == 1 ] && [ ${healthbar[i]} -gt 1 ]
		then
			saw
		fi
		if [ ${beercounter[i]} != 0 ]
		then
			local rand=$[$RANDOM%2]
			if [ $rand == 1 ] && [ $moodchanger == 1 ]
			then
				beer
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
	if [ $target == 1 ] || [ $target == 2 ] || [ $target == 3 ]
	then
		if [ $target == 3 ]
		then
			bonuses
			targetchoosedialog
		fi
	else
		clear
		targetchoosedialog
	fi
}

targetchoose() {
	if [ $target == 1 ]
	then
		winner=$next
		winnerqualifier
	else
		winner=$current
		winnerqualifier
		if [ $handcuffsstatus != 'Locked' ]
		then
			playerchanger
		fi
		handcuffsstatuslast=$handcuffsstatus
		handcuffsstatus='Unlocked'
	fi
}

statusbar() {
	local health1=${healthbar[1]}
	local health2=${healthbar[2]}
	if [ $level == 2 ]
	then
		if [ ${healthbar[1]} == 1 ]
		then
			local health1="\033[31mx\033[0m"
		fi
		if [ ${healthbar[2]} == 1 ]
		then
			local health2="\033[31mx\033[0m"
		fi
	fi
	echo -e $player1"'s health: " $health1" | "$player2"'s health: " $health2" | level: "$[$level+1]
}

clear
echo "Первый участник, представьтесь"
read player1
player1="\033[31m"$player1"\033[0m"
clear
echo "Второй участник, представьтесь"
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
	if [ $counter -gt $[$magazinlen-1] ] && [ $gameover == "False" ]
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
			healthbar[1]=$health
			healthbar[2]=$health
			magazinregen
		fi
	fi
done
