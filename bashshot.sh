health=5
magazin=6
bullets=2
damage=1

lenscounter=1
lenscounter1=$lenscounter
lenscounter2=$lenscounter

handcuffscounter=1
handcuffscounter1=$handcuffscounter
handcuffscounter2=$handcuffscounter

beercounter=1
beercounter1=$beercounter
beercounter2=$beercounter

cigarettecounter=1
cigarettecounter1=$cigarettecounter
cigarettecounter2=$cigarettecounter

sawcounter=1
sawcounter1=$sawcounter
sawcounter2=$sawcounter

healthbar1=$health
healthbar2=$health

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
	local lenscounter=0
	local handcuffscounter=0
	local beercounter=0
	local cigarettecounter=0
	local sawcounter=0
	if [ $current == $player1 ]
	then
		handcuffscounter=$handcuffscounter1
		lenscounter=$lenscounter1
		beercounter=$beercounter1
		cigarettecounter=$cigarettecounter1
		sawcounter=$sawcounter1
	else
		handcuffscounter=$handcuffscounter2
		lenscounter=$lenscounter2
		beercounter=$beercounter2
		cigarettecounter=$cigarettecounter2
		sawcounter=$sawcounter2
	fi
	clear
	statusbar
	echo -e $current", выбери бонус:"
	echo "1)лупа		"$lenscounter
	echo "2)наручники	"$handcuffscounter
	echo "3)пиво		"$beercounter
	echo "4)сигарета	"$cigarettecounter
	echo "5)ножовка	"$sawcounter
	echo "6)вернуться"
	echo "7)справка"
	local choose=0
	read choose
	if [ $choose == 1 ]
	then
		if [ $lenscounter -gt 0 ]
		then
			lens
		else
			bonuserror
		fi
	elif [ $choose == 2 ]
	then
		if [ $handcuffscounter -gt 0 ]
		then
			handcuffs
		else
			bonuserror
		fi
	elif [ $choose == 3 ]
	then
		if [ $beercounter -gt 0 ]
		then
			beer
		else
			bonuserror
		fi
	elif [ $choose == 4 ]
	then
		if [ $cigarettecounter -gt 0 ]
		then
			cigarette
		else
			bonuserror
		fi
	elif [ $choose == 5 ]
	then
		if [ $sawcounter -gt 0 ]
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
	else 
		echo -e "\033[32mхолостой\033[0m"
	fi
	sleep 2s
	clear
	if [ $current == $player2 ]
	then
		lenscounter2=$[$lenscounter2-1]
	else
		lenscounter1=$[$lenscounter1-1]
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
			handcuffscounter2=$[$handcuffscounter2-1]
		else
			handcuffscounter1=$[$handcuffscounter1-1]
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
		beercounter2=$[$beercounter2-1]
	else
		beercounter1=$[$beercounter1-1]
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
		cigarettecounter1=$[$cigarettecounter1-1]
		healthbar1=$[healthbar1+1]
	else
		cigarettecounter2=$[$cigarettecounter2-1]
		healthbar2=$[healthbar2+1]
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
		sawcounter1=$[$sawcounter1-1]
	else
		sawcounter2=$[$sawcounter2-1]
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
	if [ $healthbar1 == 0 ] || [ $healthbar2 == 0 ]
	then
		gameover="True"
		echo -e "Выиграл, "$winner"!"
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

dealer() {
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
	local rand=$[$[RANDOM%100+1]*$[100-$chance]/100]
	local mood=$[$chance+$rand]
	local plank=85
	if [ $mood -gt $plank ]
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
	echo "1)выстрелить в себя"
	echo "2)выстрелить в опонента"
	echo "3)посмотреть бонусы"
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
	echo -e $player1"'s health: " $healthbar1" | "$player2"'s health: " $healthbar2
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

counter=0
current=$player1
next=$player2
magazinlen=$magazin
last="empty"
gameover="False"
handcuffsstatus="Unlocked"
handcuffsstatuslast="Unlocked"
while [ $counter != $magazinlen ] && [ $gameover == "False" ]
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
done
