#!/bin/bash
# Created by Qurius

White='\033[0;37m'
IRed='\033[0;91m' 
printf "${IRed}"

echo " ___________________________________"
echo "|            _____                  |";
echo "|           / ____|                 |";
echo "|   __ _   | (___   ___ __ _ _ __   |";
echo "|  / _\` |   \___ \ / __/ _\` | '\ \  |";
echo "| | (_| |   ____) | (_| (_| | | | | |";
echo "|  \__, |  |_____/ \___\__,_|_| |_| |";
echo "|     | |                           |";
echo "|     |_|                           |";
echo "|__________________________$(printf ${White})by Qurius$(printf ${IRed})|"
echo ""

printf "${White}"

if [ "$1" = "--show" ]
then
	nmap_file=$(find . -type f -name "*.nmap" | grep -v "-")
	less $nmap_file
	exit
fi

# Help message
if [ $# -ne 2 ]
then
	echo "Usage: $0 <host ip> <name of the box>"
	echo "Use --show to see the last qscan output"
	exit
fi

host=$1
boxname=$2

echo "Target:"
echo "	$host"
echo "Files:"
echo "	nmap/$boxname-allports.nmap"
echo "	nmap/$boxname.nmap"
echo ""
echo ""

mkdir nmap 2>/dev/null
echo "[+] Created the nmap directory"

echo "[*] Starting the scan"

# Nmap full port scan
echo "[*] Running the full-port scan"
sudo nmap -sS -T4 -p- -oN nmap/$boxname-allports.nmap $host 1>/dev/null

# Check if -Pn is required
icmp_err=$(cat nmap/$boxname-allports.nmap | grep "65535 closed")

if [ ! -z $icmp_err ]
then
	if [[ $icmp_err = *"65535 closed"* ]]
	then
		echo "Trying with -Pn"
		sudo nmap -sS -T4 -oN nmap/$boxname-allports.nmap $host -Pn 1>/dev/null
	fi
fi

# Parsing the nmap full-port scan output
echo "[*] Parsing the nmap full-port scan output"
open_ports=$(cat nmap/$boxname-allports.nmap | grep -i 'open' | cut -d '/' -f 1 | sed -z 's/\n/,/g') 1>/dev/null
open_ports=${open_ports::-1} # strip the last ','

# Nmap selected ports script scan
if [ ! -z $open_ports ]
then
	echo "[*] Running script scan on ports: $open_ports"
	sudo nmap -sC -sV -oN nmap/$boxname.nmap -p $open_ports $host 1>/dev/null
fi

echo "[+] Scanning of the $boxname machine complete"

less nmap/$boxname.nmap