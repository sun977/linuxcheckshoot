#!/bin/bash
HELL=/bin/bash 
PATH=/sbin:/bin:/usr/sbin:/usr/bin

# Update function, applicable to all systems [waiting for update]

cat <<EOF
*********************************************************************
    __     __                      ______            
   / /    /_/____   __  __ _  __ / ____/__  __ ____ 
  / /    / // __ \ / / / /| |/_// / __ / / / // __ \\
 / /___ / // / / // /_/ /_>  < / /_/ // /_/ // / / /
/_____//_//_/ /_/ \__,_//_/|_| \____/ \__,_//_/ /_/ 
                                                    

Version:4.3
Author:sun977
Mail:jiuwei977@foxmail.com
Date:2024.08.07

Update Log:
	2024.06.16:
		1. Optimize the recent 24-hour changed files to only check files and exclude directories /proc, /dev, /sys, /run
		2. Fixed the bug where high-risk port files were not found
		3. Added detection of system environment variables [.bashrc|.bash_profile|.zshrc|.viminfo, etc.]
		4. Added journalctl log output
        2024.07.17:
		1. Fixed logo display bug
	2024.07.30:
		1. Replaced all ifconfig commands with ip
	2024.08.07:
		1. Optimized command format, no longer using `` style
		2. Added sensitive process rule matching, users can customize process rule file dangerspslist.txt
		3. Optimized some output details
		4. Fixed nginx configuration file check bug [only checks nginx.conf, other imported configuration files were not checked]
	2024.x.x:
		2. Support for multiple Linux systems

Check Instructions:
	1. First, collect raw information and save it to the directory output/liuxcheck_[your-ip]_[date]/check_file
	2. Package system logs and application logs and save them to the directory output/liuxcheck_[your-ip]_[date]/check_file/log
	3. During the check, the results will be output to the file output/liuxcheck_[your-ip]_[date]/check_file/checkresult.txt
	4. If any issues are found during the check, they will be directly output to the file output/liuxcheck_[your-ip]_[date]/check_file/saveDangerResult.txt
	5. Some unchecked items may require manual analysis of the original files
	6. Script written in Centos7 environment, if you encounter issues during use, you can contact via email: jiuwei977@foxmail.com
	7. If modified under Windows and then synchronized to Linux, please use the dos2unix tool for format conversion, otherwise errors may occur
	8. Must use the root account during execution, otherwise some items may not be analyzed
	9. The checkrules directory contains some detection rules, which can be modified according to actual conditions

How to Use:
	1. Upload this script to the corresponding server
	2. Execute chmod +x linuxcheck.sh
	3. Execute ./linuxcheck.sh to run the check

Function Design:
	1. Collect basic system environment information
	2. Analyze the raw data and identify suspicious or dangerous items
	3. Add baseline check functionality
	4. Hacker tool check functionality
	5. Applicable to all systems (to be determined)

Check Content:
	1. Basic System Information
		1.1 IP Address Information
		1.2 System Version Information
		1.3 Release Version Information
	2. Network Connections
		2.1 ARP Table Entries
		2.2 ARP Attack
		2.3 Network Connection Information
			2.3.1 Network Connection Status
			2.3.1 Network DNS
		2.4 Network Interface Mode
			2.4.1 Promiscuous Mode
			2.4.2 Monitor Mode
		2.5 Network Routing
			2.5.1 Network Routing Table
			2.5.2 Network Routing Forwarding
		2.6 Firewall Policy
			2.6.1 firewalld Policy
			2.6.2 iptables Policy
	3. Port Information
		3.1 TCP Open Ports
		3.2 TCP High-Risk Ports
		3.3 UDP Open Ports
		3.4 UDP High-Risk Ports
	4. System Processes
		4.1 System Processes
		4.2 Daemon Processes
	5. Startup Items
		5.1 User Startup Items
		5.2 System Startup Items
		5.3 Dangerous Startup Item Analysis
	6. Scheduled Tasks
		6.1 System Scheduled Task Collection
		6.2 System Scheduled Task Analysis
		6.3 User Scheduled Task Collection
		6.4 User Scheduled Task Analysis
	7. System Services
	8. Critical File Check
		8.1 hosts File
		8.2 Public Key Files
		8.3 Private Key Files
		8.4 authorized_keys File
		8.5 known_hosts File
		8.6 tmp Directory Check
		8.7 Environment Variable Check
		8.8 Hidden Files Under /root
	9. User Login Information
		9.1 Currently Logged-In Users
		9.2 User Information [passwd File]
		9.3 Superuser Information
		9.4 Cloned User Information
		9.5 Loggable User Information
		9.6 Non-System User Information
		9.7 Check shadow File
		9.8 Empty Password Users
		9.9 Empty Password and Loggable Users
		9.10 Unencrypted Password Users
		9.11 User Group Information
			9.11.1 User Group Information
			9.11.2 Privileged User Groups
			9.11.3 Same GID User Groups
			9.11.4 Same User Group Names
		9.12 SSHD Login Configuration
			9.12.1 SSHD Configuration
			9.12.2 Empty Password Login
			9.12.3 Root Remote Login
			9.12.4 SSH Protocol Version
		9.13 File Permissions
			9.13.1 etc File Permissions
			9.13.2 shadow File Permissions
			9.13.3 passwd File Permissions
			9.13.4 group File Permissions
			9.13.5 securetty File Permissions
			9.13.6 services File Permissions
			9.13.7 grub.conf File Permissions
			9.13.8 xinetd.conf File Permissions
			9.13.9 lilo.conf File Permissions
			9.13.10 limits.conf File Permissions
		9.14 File Attributes
			9.14.1 passwd File Attributes
			9.14.2 shadow File Attributes
			9.14.3 gshadow File Attributes
			9.14.4 group File Attributes
		9.15 useradd and userdel Time Attributes
			9.15.1 useradd Time Attributes
			9.15.2 userdel Time Attributes
	10. Configuration Policy Check (Baseline Check)
		10.1 Remote Access Policy
			10.1.1 Remote Allow Policy
			10.1.2 Remote Deny Policy
		10.2 Account and Password Policy
			10.2.1 Password Validity Policy
				10.2.1.1 Password Lifetime
				10.2.1.2 Minimum Password Change Interval
				10.2.1.3 Minimum Password Length
				10.2.1.4 Password Expiration Days
			10.2.2 Password Complexity Policy
			10.2.3 Expired Password Users
			10.2.4 Account Timeout Lock Policy
			10.2.5 Grub Password Policy Check
			10.2.6 Lilo Password Policy Check
		10.3 SELinux Policy
		10.4 SSHD Configuration
			10.4.1 SSHD Configuration
			10.4.2 Empty Password Login
			10.4.3 Root Remote Login
			10.4.4 SSH Protocol Version
			10.4.5 SSH Version
		10.5 NIS Configuration Policy
		10.6 Nginx Configuration Policy
			10.6.1 Original Configuration
			10.6.2 Suspicious Configuration
		10.7 SNMP Configuration Check
	11. History Commands
		11.1 System History Commands
			11.1.1 System Operation History Commands
			11.1.2 Whether Script Files Were Downloaded
			11.1.3 Whether Accounts Were Added
			11.1.4 Whether Accounts Were Deleted
			11.1.5 Suspicious History Commands
			11.1.6 Local Downloaded Files
			11.1.7 Yum Download Records
			11.1.8 Disable History Command Recording
		11.2 Database History Commands
	12. Suspicious File Check
		12.1 Check Script Files
		12.2 Check Webshell Files (Requires Third-Party Tools)
		12.3 Check Recently Modified Sensitive Files
		12.4 Check All Recently Modified Files
		12.5 Hacker Tool Check
	13. System File Integrity Check
	14. System Log Analysis
		14.1 Log Configuration and Packaging
			14.1.1 View Log Configuration
			14.1.2 Log Existence
			14.1.3 Log Audit Enabled
			14.1.4 Automatic Log Packaging
		14.2 Secure Log Analysis
			14.2.1 Successful Logins
			14.2.2 Login Failures
			14.2.3 Window Login Status
			14.2.4 New User and User Group Creation
		14.3 Message Log Analysis
			14.3.1 File Transfers
			14.3.2 Historical DNS Usage
		14.4 Cron Log Analysis
			14.4.1 Scheduled Downloads
			14.4.2 Scheduled Script Execution
		14.5 Yum Log Analysis
			14.5.1 Software Download Status
			14.5.2 Software Uninstallation Status
			14.5.3 Suspicious Software Downloads
		14.6 Dmesg Log Analysis
			14.6.1 Kernel Self-Check Analysis
		14.7 Btmp Log Analysis
			14.7.1 Failed Login Analysis
		14.8 Lastlog Log Analysis
			14.8.1 Last Login Analysis for All Users
		14.9 Wtmp Log Analysis
			14.9.1 Login Analysis for All Users
		14.10 Journalctl Log Output
	15. Kernel Check
		15.1 Kernel Information
		15.2 Abnormal Kernel
	16. Installed Software (RPM)
		16.1 Installed Software
		16.2 Suspicious Software
	17. Environment Variables
	18. Performance Analysis
		18.1 Disk Usage
			18.1.1 Disk Usage Status
			18.1.2 Excessive Disk Usage
		18.2 CPU
			18.2.1 CPU Status
			18.2.2 Top Five CPU-Consuming Processes
			18.2.3 Processes Consuming More CPU Resources
		18.3 Memory
			18.3.1 Memory Status
			18.3.2 Top Five Memory-Consuming Processes
			18.3.3 Processes Consuming More Memory
		18.4 System Uptime and Load
			18.4.1 Uptime and Load Status
	19. Unified Result Packaging
		19.1 Unified Packaging of System Raw Logs
		19.2 Unified Packaging of Check Script Logs

*********************************************************************
EOF

# Ensure the script runs on Linux
# dos2unix linuxcheck.sh
date=$(date +%Y%m%d)
# Extract the first non-loopback IP address from the machine for file differentiation
# ipadd=$(ifconfig -a | grep -w inet | grep -v 127.0.0.1 | awk 'NR==1{print $2}')
ipadd=$(ip addr | grep -w inet | grep -v 127.0.0.1 | awk 'NR==1{print $2}' | sed 's#/\([0-9]\+\)#_\1#') # 192.168.1.1_24

# Create output directory variables, current directory's output directory
current_dir=$(pwd)  
check_file="${current_dir}/output/linuxcheck_${ipadd}_${date}/check_file"
log_file="${check_file}/log"

# Remove existing output directories
rm -rf $check_file
rm -rf $log_file

# Create new output directories: check directory, log directory
mkdir -p $check_file
mkdir -p $log_file
echo "Dangerous items found during the check, please note:" > ${check_file}/dangerlist.txt
echo "" >> $check_file/dangerlist.txt

# Check if directories exist
if [ ! -d "$check_file" ];then
	echo "Check ${check_file} directory does not exist, please verify"
	exit 1
fi

if [ $(whoami) != "root" ];then
	echo "Security checks must be performed using the root account, otherwise some items cannot be checked"
	exit 1
fi

# Append mode opens files under check_file, output results to terminal and save to corresponding files
cd $check_file  
saveCheckResult="tee -a checkresult.txt" 
saveDangerResult="tee -a dangerlist.txt"

################################################################


echo "LinuxGun is checking..."  | $saveCheckResult
echo "==========1. Basic System Information==========" | $saveCheckResult
echo "[1.0] Collecting basic system information:" && "$saveCheckResult"
echo "[1.1] IP Address Information [ip add]:" | $saveCheckResult
# ip=$(ifconfig -a | grep -w inet | awk '{print $2}')
ip=$(ip add | grep -w inet | awk '{print $2}')

# Check if IP is empty
if [ -n "$ip" ];then
	(echo "[+] Local IP Address Information:" && echo "$ip")  | $saveCheckResult
else
	echo "[!] No IP address configured on this machine" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[1.2] System Kernel Version [uname -a]:" | $saveCheckResult
corever=$(uname -a)
if [ -n "$corever" ];then
	(echo "[+] System Kernel Version Information:" && echo "$corever") | $saveCheckResult
else
	echo "[!] No kernel version information found" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[1.3] Operating System Information [/etc/*-release]:" | $saveCheckResult
systemver=$(cat /etc/*-release)
if [ -n "$systemver" ];then
	(echo "[+] System Version Information:" && echo "$systemver") | $saveCheckResult
else
	echo "[!] No system version information found" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "==========2. Network Connection Status==========" | $saveCheckResult
echo "[2.0] Collecting ARP Table Information:" && "$saveCheckResult"
echo "[2.1] ARP Table Entries [arp -a -n]:" | $saveCheckResult
arp=$(arp -a -n)
if [ -n "$arp" ];then
	(echo "[+] ARP Table Entries as Follows:" && echo "$arp") | $saveCheckResult
else
	echo "[!] No ARP table found" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


# Principle: Parse the ARP table and use awk logic to count and identify MAC addresses, then output duplicate MAC addresses and their occurrence counts.
# This command counts the occurrences of MAC addresses in the ARP table and displays duplicate MAC addresses and their frequency.
# Specific explanation:
# - `arp -a -n`: Query the ARP table and display results in IP address and MAC address format.
# - `awk '{++S[$4]} END {for(a in S) {if($2>1) print $2,a,S[a]}}'`: Process using awk command.
#   - `{++S[$4]}`: Increment the array S element with the fourth field (MAC address) as the index.
#   - `END {for(a in S) {if($2>1) print $2,a,S[a]}}`: After processing all lines, iterate through array S.
#     - `for(a in S)`: Iterate through each element in array S.
#     - `if($2>1)`: If the second field (count) is greater than 1, it indicates a duplicate MAC address.
#     - `print $2,a,S[a]`: Print the count, MAC address, and occurrence frequency.

echo "[2.2] Detecting ARP Attacks [arp -a -n]:" | $saveCheckResult
echo "[Principle]: Parse the ARP table and use awk logic to count and identify MAC addresses, then output duplicate MAC addresses and their occurrence counts" | $saveCheckResult
arpattack=$(arp -a -n | awk '{++S[$4]} END {for(a in S) {if($2>1) print $2,a,S[a]}}')
if [ -n "$arpattack" ];then
	(echo "[!] ARP Attack Detected:" && echo "$arpattack") | $saveDangerResult | $saveCheckResult
else
	echo "[+] No ARP Attack Found" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[2.3] Collecting Network Connection Information:" && "$saveCheckResult"
echo "[2.3.1] Checking Network Connection Status [netstat -anlp]:" | $saveCheckResult
netstat=$(netstat -anlp | grep ESTABLISHED)
netstatnum=$(netstat -n | awk '/^tcp/ {++S[$NF]} END {for(a in S) print a, S[a]}')
if [ -n "$netstat" ];then
	(echo "[+] Established Network Connection Status as Follows:" && echo "$netstat") | $saveCheckResult
	if [ -n "$netstatnum" ];then
		(echo "[+] Quantity of Each Status as Follows:" && echo "$netstatnum") | $saveCheckResult
	fi
else
	echo "[+] No Network Connections Found" | $saveCheckResult
fi
printf "\n" | $saveCheckResult

echo "[2.3.2] Checking Network DNS [/etc/resolv.conf]:" | $saveCheckResult
resolv=$(cat /etc/resolv.conf | grep ^nameserver | awk '{print $NF}') 
if [ -n "$resolv" ];then
	(echo "[+] The Server Uses the Following DNS Servers:" && echo "$resolv") | $saveCheckResult
else
	echo "[+] No DNS Servers Found" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[2.4] Checking Network Interface Mode [ip addr]:" | $saveCheckResult
# ifconfigmode=$(ifconfig -a | grep flags | awk -F '[: = < >]' '{print "Network Interface:",$1,"Mode:",$5}')
ifconfigmode=$(ip addr | grep '<' | awk  '{print "Network Interface:",$2,"Mode:",$3}' | sed 's/<//g' | sed 's/>//g')
if [ -n "$ifconfigmode" ];then
	(echo "Network Interface Working Mode as Follows:" && echo "$ifconfigmode") | $saveCheckResult
else
	echo "[+] No Network Interface Mode Information Found, Please Analyze Manually" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[2.4.1] Analyzing Whether Any Network Interface Is in Promiscuous Mode [ifconfig]:" | $saveCheckResult
# Promisc=`ifconfig | grep PROMISC | gawk -F: '{ print $1}'`
Promisc=$(ip addr | grep -i promisc | awk -F: '{print $2}')
if [ -n "$Promisc" ];then
	(echo "[!] Network Interface in Promiscuous Mode:" && echo "$Promisc") | $saveDangerResult | $saveCheckResult
else
	echo "[+] No Network Interface Found in Promiscuous Mode" | $saveCheckResult
fi
printf "\n" | $saveCheckResult

echo "[2.4.2] Analyzing Whether Any Network Interface Is in Monitor Mode [ifconfig]:" | $saveCheckResult
# Monitor=`ifconfig | grep -E "Mode:Monitor" | gawk -F: '{ print $1}'`
Monitor=$(ip addr | grep -i "mode monitor" | awk -F: '{print $2}')
if [ -n "$Monitor" ];then
	(echo "[!] Network Interface in Monitor Mode:" && echo "$Monitor") |  $saveDangerResult | $saveCheckResult
else
	echo "[+] No Network Interface Found in Monitor Mode" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[2.5] Collecting network routing information:" && "$saveCheckResult"
echo "[2.5.1] Checking the routing table [route -n]:" | $saveCheckResult
route=$(route -n)
if [ -n "$route" ];then
	(echo "[+] Routing table as follows:" && echo "$route") | $saveCheckResult
else
	echo "[+] No routing table found" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[2.5.2] Analyzing whether forwarding is enabled [/proc/sys/net/ipv4/ip_forward]:" | $saveCheckResult
# Value analysis
# 1: Forwarding enabled
# 0: Forwarding disabled
ip_forward=$(cat /proc/sys/net/ipv4/ip_forward | gawk -F: '{if ($1==1) print "1"}')
if [ -n "$ip_forward" ];then
	echo "[!] The server has forwarding enabled, please note!" |  $saveDangerResult  | $saveCheckResult
else
	echo "[+] The server does not have forwarding enabled" | $saveCheckResult
fi
printf "\n" | $saveCheckResult



echo "[2.6] Collecting firewall policies:" && "$saveCheckResult"
echo "[2.6.1] Checking firewalld policy [systemctl status firewalld]:" | $saveCheckResult
firewalledstatus=$(systemctl status firewalld | grep "active (running)")
firewalledpolicy=$(firewall-cmd --list-all)
if [ -n "$firewalledstatus" ];then
	echo "[+] The server's firewall is enabled"
	if [ -n "$firewalledpolicy" ];then
		(echo "[+] Firewall policy as follows" && echo "$firewalledpolicy") | $saveCheckResult
	else
		echo "[!] Firewall policy not configured, it is recommended to configure firewall policy!" |  $saveDangerResult | $saveCheckResult
	fi
else
	echo "[!] Firewall is not enabled, it is recommended to enable the firewall" |  $saveDangerResult | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[2.6.2] Checking iptables policy [service iptables status]:" | $saveCheckResult
firewalledstatus=$(service iptables status | grep "Table" | awk '{print $1}')  # "Table:" indicates enabled, otherwise disabled
firewalledpolicy=$(iptables -L)
if [ -n "$firewalledstatus" ];then
	echo "[+] iptables is enabled"
	if [ -n "$firewalledpolicy" ];then
		(echo "[+] iptables policy as follows" && echo "$firewalledpolicy") | $saveCheckResult
	else
		echo "[!] iptables policy not configured, it is recommended to configure iptables policy!" |  $saveDangerResult | $saveCheckResult
	fi
else
	echo "[!] iptables is not enabled, it is recommended to enable the firewall" |  $saveDangerResult | $saveCheckResult
fi
printf "\n" | $saveCheckResult



echo "==========3. Port Information==========" | $saveCheckResult
echo "[3.1] Checking open TCP ports [netstat -antlp]:" | $saveCheckResult
echo "[Note] TCP or UDP ports bound to IPs like 0.0.0.0, 127.0.0.1, 192.168.1.1 only indicate these ports are open" | $saveCheckResult
echo "[Note] Only binding to 0.0.0.0 allows access from the local network" | $saveCheckResult
listenport=$(netstat -anltp | grep LISTEN | awk  '{print $4,$7}' | sed 's/:/ /g' | awk '{print $2,$3}' | sed 's/\// /g' | awk '{printf "%-20s%-10s\n",$1,$NF}' | sort -n | uniq)
if [ -n "$listenport" ];then
	(echo "[+] The server has the following open TCP ports and corresponding services:" && echo "$listenport") | $saveCheckResult
else
	echo "[!] The system does not have any open TCP ports" | $saveCheckResult
fi
printf "\n" | $saveCheckResult

accessport=$(netstat -anltp | grep LISTEN | awk  '{print $4,$7}' | egrep "(0.0.0.0|:::)" | sed 's/:/ /g' | awk '{print $(NF-1),$NF}' | sed 's/\// /g' | awk '{printf "%-20s%-10s\n",$1,$NF}' | sort -n | uniq)
if [ -n "$accessport" ];then
	(echo "[!] The following TCP ports are open to the local network or the Internet, please note!" && echo "$accessport") | $saveCheckResult
else
	echo "[+] Ports are not open to the local network or the Internet" | $saveCheckResult
fi
printf "\n" | $saveCheckResult



echo "[3.2] Checking high-risk TCP ports [netstat -antlp]:" | $saveCheckResult
echo "[Note] Open ports matching those defined in dangerstcpports.txt are considered high-risk" | $saveCheckResult
# tcpport=`netstat -anlpt | awk '{print $4}' | awk -F: '{print $NF}' | sort | uniq | grep '[0-9].*'`
# count=0
# if [ -n "$tcpport" ];then
# 	for port in $tcpport
# 	do
# 		# Enter the checkrules directory
# 		for i in `cat ${current_dir}/checkrules/dangerstcpports.txt`
# 		do
# 			tcpport=`echo $i | awk -F "[:]" '{print $1}'`
# 			desc=`echo $i | awk -F "[:]" '{print $2}'`
# 			process=`echo $i | awk -F "[:]" '{print $3}'`
# 			if [ $tcpport == $port ];then
# 				echo "$tcpport,$desc,$process" | $saveDangerResult | $saveCheckResult
# 				count=count+1
# 			fi
# 		done
# 	done
# fi
# if [ $count = 0 ];then
# 	echo "[+] No high-risk TCP ports found" | $saveCheckResult
# else
# 	echo "[!] Please manually analyze and confirm high-risk TCP ports" | $saveCheckResult
# fi
# printf "\n" | $saveCheckResult

#### 20240731 update
declare -A danger_ports  # Create an associative array to store risky ports and related information
# Read the file and populate the associative array
while IFS=: read -r port description; do
    danger_ports["$port"]="$description"
done < "${current_dir}/checkrules/dangerstcpports.txt"
# Get all listening TCP ports
listening_TCP_ports=$(netstat -anlpt | awk 'NR>1 {print $4}' | cut -d: -f2 | sort -u) # Get all listening TCP ports
tcpCount=0  # Initialize counter
# Iterate through all listening ports
for port in $listening_TCP_ports; do
    # If the port is in the risky ports list
    if [[ -n "${danger_ports[$port]}" ]]; then
        # Output the port and description
        echo "${RED}[!]$port,${danger_ports[$port]}${NC}" | $saveCheckResult | $saveDangerResult
        ((tcpCount++))
    fi
done

if [ $tcpCount -eq 0 ]; then
    echo "[+] No high-risk TCP ports found" | $saveCheckResult
else
    echo "[!] Total high-risk TCP ports found: $tcpCount ${NC}" | $saveCheckResult | $saveDangerResult
    echo "[!] Please manually analyze and confirm high-risk TCP ports" | $saveCheckResult | $saveDangerResult
fi
printf "\n" | $saveCheckResult

echo "[3.3] Checking open UDP ports [netstat -anlup]:" | $saveCheckResult
udpopen=$(netstat -anlup | awk  '{print $4,$NF}' | grep : | sed 's/:/ /g' | awk '{print $2,$3}' | sed 's/\// /g' | awk '{printf "%-20s%-10s\n",$1,$NF}' | sort -n | uniq)
if [ -n "$udpopen" ];then
	(echo "[+] The server has the following open UDP ports and corresponding services:" && echo "$udpopen") | $saveCheckResult
else
	echo "[!] The system does not have any open UDP ports" | $saveCheckResult
fi
printf "\n" | $saveCheckResult

udpports=$(netstat -anlup | awk '{print $4}' | egrep "(0.0.0.0|:::)" | awk -F: '{print $NF}' | sort -n | uniq)
if [ -n "$udpports" ];then
	echo "[+] The following UDP ports are open to the local network or the Internet:" | $saveCheckResult
	for port in $udpports
	do
		# nc -uz 127.0.0.1 $port
        if nc -z -w1 127.0.0.1 $port </dev/null; then
        	echo "$port" | $saveCheckResult
        fi
	done
else 
	echo "[+] No UDP ports open to the local network or the Internet were found." | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[3.4] Checking high-risk UDP ports [netstat -anlup]:"
echo "[Note] Open ports matching those defined in dangersudpports.txt are considered high-risk" | $saveCheckResult
# udpport=`netstat -anlpu | awk '{print $4}' | awk -F: '{print $NF}' | sort | uniq | grep '[0-9].*'`
# count=0
# if [ -n "$udpport" ];then
# 	for port in $udpport
# 	do
# 		for i in `cat ${current_dir}/checkrules/dangersudpports.txt`
# 		do
# 			udpport=`echo $i | awk -F "[:]" '{print $1}'`
# 			desc=`echo $i | awk -F "[:]" '{print $2}'`
# 			process=`echo $i | awk -F "[:]" '{print $3}'`
# 			if [ $udpport == $port ];then
# 				echo "$udpport,$desc,$process" | $saveDangerResult | $saveCheckResult
# 				count=count+1
# 			fi
# 		done
# 	done
# fi
# if [ $count = 0 ];then
# 	echo "[+] No high-risk UDP ports found" | $saveCheckResult
# else
# 	echo "[!] Please manually analyze and confirm high-risk UDP ports"
# fi
# printf "\n" | $saveCheckResult

#### 20240731 update
declare -A danger_udp_ports  # Create an associative array to store risky ports and related information
# Read the file and populate the associative array
while IFS=: read -r port description; do
    danger_udp_ports["$port"]="$description"
done < "${current_dir}/checkrules/dangersudpports.txt"
# Get all listening UDP ports
listening_UDP_ports=$(netstat -anlup | awk 'NR>1 {print $4}' | cut -d: -f2 | sort -u) # Get all listening UDP ports
udpCount=0  # Initialize counter
# Iterate through all listening ports
for port in $listening_UDP_ports; do
    # If the port is in the risky ports list
    if [[ -n "${danger_udp_ports[$port]}" ]]; then
        # Output the port and description
        echo "[!]$port,${danger_udp_ports[$port]}" | $saveCheckResult | $saveDangerResult
        ((udpCount++))
    fi
done

if [ $udpCount -eq 0 ]; then
    echo "[+] No high-risk UDP ports found" | $saveCheckResult
else
    echo "[!] Total high-risk UDP ports found: $udpCount " | $saveCheckResult | $saveDangerResult
    echo "[!] Please manually analyze and confirm high-risk UDP ports" | $saveCheckResult | $saveDangerResult
fi
printf "\n" | $saveCheckResult


echo "==========4. System Processes==========" | $saveCheckResult
echo "[4.1] Checking system processes [ps -aux]:" | $saveCheckResult
ps=$(ps -aux)
if [ -n "$ps" ];then
	(echo "[+] System processes as follows:" && echo "$ps") | $saveCheckResult
else
	echo "[+] No system processes found" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[4.2] Checking daemon processes [/etc/xinetd.d/rsync]:" | $saveCheckResult
if [ -e /etc/xinetd.d/rsync ];then
	(echo "[+] System daemon processes:" && cat /etc/xinetd.d/rsync | grep -v "^#") | $saveCheckResult
else
	echo "[+] No daemon processes found" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[4.3] Matching sensitive processes based on the rules list dangerspslist.txt:" | $saveCheckResult
danger_ps_list=$(cat ${current_dir}/checkrules/dangerspslist.txt) # List of sensitive process names
# Loop to output sensitive process names, PIDs, and users
ps_output=$(ps -auxww)
for psname in $danger_ps_list; do
	filtered_output=$(echo "$ps_output" | awk -v proc="$psname" '
		BEGIN { found = 0 }
		{
			if ($11 ~ proc) {
				print;
				found++;
			}
		}
		END {
			if (found > 0) {
				printf($0)
				printf("\n'${YELLOW}'[!] Sensitive process found: %s, Number of processes: %d'${NC}'\n", proc, found);
			}
		}'
	)
	# Output sensitive processes
	# echo -e "${RED}[!] Sensitive processes as follows:${NC}" && echo "$filtered_output"
	echo -e "${RED}$filtered_output${NC}"
done


echo "==========5. Startup Items==========" | $saveCheckResult
echo "[5.1] Checking user-defined startup items [chkconfig --list]:" | $saveCheckResult
chkconfig=$(chkconfig --list | grep -E ":on|启用" | awk '{print $1}')
if [ -n "$chkconfig" ];then
	(echo "[+] User-defined startup items:" && echo "$chkconfig") | $saveCheckResult
else
	echo "[!] No user-defined startup items found" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[5.2] Checking system startup items [systemctl list-unit-files]:" | $saveCheckResult
systemchkconfig=$(systemctl list-unit-files | grep enabled | awk '{print $1}')
if [ -n "$systemchkconfig" ];then
	(echo "[+] System startup items as follows:" && echo "$systemchkconfig")  | $saveCheckResult
else
	echo "[+] No system startup items found" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[5.3] Analyzing risky startup items [chkconfig --list]:" | $saveCheckResult
dangerstarup=$(chkconfig --list | grep -E ":on|启用" | awk '{print $1}' | grep -E "\.(sh|per|py|exe)$")
if [ -n "$dangerstarup" ];then
	(echo "[!] Risky startup items found:" && echo "$dangerstarup") |  $saveDangerResult | $saveCheckResult
else
	echo "[+] No risky startup items found" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "==========6. Scheduled Tasks==========" | $saveCheckResult
echo "[6.1] Checking system scheduled tasks [/etc/crontab]:" | $saveCheckResult
syscrontab=$(cat /etc/crontab | grep -v "# run-parts" | grep run-parts)
if [ -n "$syscrontab" ];then
	(echo "[!] System scheduled tasks found:" && cat /etc/crontab ) |  $saveDangerResult | $saveCheckResult
else
	echo "[+] No system scheduled tasks found" | $saveCheckResult
fi
printf "\n" | $saveCheckResult

# if [ $? -eq 0 ] indicates the previous command executed successfully; successful execution outputs 0; failed execution outputs non-zero
#ifconfig  echo $? returns 0, indicating successful execution
# if [ $? != 0 ] indicates the previous command failed


echo "[6.2] Analyzing suspicious system tasks [/etc/cron*/* | /var/spool/cron/*]:" | $saveCheckResult
dangersyscron=$(egrep "((chmod|useradd|groupadd|chattr)|((wget|curl)*\(sudo|bash|sh\)))" /etc/cron*/* /var/spool/cron/* 2>/dev/null)
if [ -n "$dangersyscron" ];then
	(echo "[!] Suspicious scheduled tasks found:" && echo "$dangersyscron") | $saveDangerResult | $saveCheckResult
else
	echo "[+] No suspicious scheduled tasks found" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[6.3] Collecting user cron jobs [crontab -l]:" | $saveCheckResult
crontab=$(crontab -l)
if [ $? -eq 0 ];then
	(echo "[!] Found user cron jobs as follows:" && echo "$crontab") | $saveCheckResult
else
	echo "[+] No user cron jobs found"  | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[6.4] Analyzing user cron jobs [crontab -l]:" | $saveCheckResult
danger_crontab=$(crontab -l | egrep "((chmod|useradd|groupadd|chattr)|((wget|curl).*\.(sh|pl|py|exe)))")
if [ $? -eq 0 ];then
	(echo "[!] Suspicious cron jobs found, please pay attention!" && echo "$danger_crontab") |  $saveDangerResult | $saveCheckResult
else
	echo "[+] No suspicious cron jobs found" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "==========7. System Service Information==========" | $saveCheckResult
echo "[7.1] Checking running services [systemctl | grep -E "\.service.*running"]:" | $saveCheckResult
services=$(systemctl | grep -E "\.service.*running" | awk -F. '{print $1}')
if [ -n "$services" ];then
	(echo "[+] The following services are running:" && echo "$services") | $saveCheckResult
else
	echo "[!] No running services found!" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "==========8. Critical File Check==========" | $saveCheckResult
echo "[8.1] Checking hosts file [/etc/hosts] (Not checking .bash_history|.zsh_history files):" | $saveCheckResult
hosts=$(cat /etc/hosts)
if [ -n "$hosts" ];then
	(echo "[+] Hosts file as follows:" && echo "$hosts") | $saveCheckResult
else
	echo "[+] Hosts file not found" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[8.2] Checking public key files [/root/.ssh/*.pub]:" | $saveCheckResult
if [  -e /root/.ssh/*.pub ];then
	echo "[!] Public key files found, please pay attention!"  |  $saveDangerResult | $saveCheckResult
else
	echo "[+] No public key files found" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[8.3] Checking private key files [/root/.ssh/id_rsa]:" | $saveCheckResult
if [ -e /root/.ssh/id_rsa ];then
	echo "[!] Private key file found, please pay attention!" |  $saveDangerResult | $saveCheckResult
else
	echo "[+] No private key files found" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[8.4] Checking authorized_keys file [/root/.ssh/authorized_keys]:" | $saveCheckResult
echo "[Note] The authorized_keys file is used for SSH key authentication and stores public keys allowed for remote login to identify who can log in without a password." | $saveCheckResult
authkey=$(cat /root/.ssh/authorized_keys)
if [ -n "$authkey" ];then
	(echo "[!] Found authorized user public key information as follows:" && echo "$authkey") | $saveCheckResult
else
	echo "[+] No authorized user public key information found" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[8.5] Checking known_hosts file [/root/.ssh/known_hosts]:" | $saveCheckResult
echo "[Note] The known_hosts file stores SSH server public keys and can be used to investigate lateral movement scope and quickly locate potentially infected hosts." | $saveCheckResult
knownhosts=$(cat /root/.ssh/known_hosts | awk '{print $1}')
if [ -n "$knownhosts" ];then
	(echo "[!] Found known remote host public key information as follows:" && echo "$knownhosts") | $saveCheckResult
else
	echo "[+] No known remote host public key information found" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[8.6] Checking tmp directory [/tmp]:" | $saveCheckResult
echo "[Note] The tmp directory is used to store temporary files and may contain malicious files, virus files, or cracking tools." | $saveCheckResult
(ls -alt /tmp) | $saveCheckResult
printf "\n" | $saveCheckResult


echo "[8.7] Checking environment variable files [.bashrc|.bash_profile|.zshrc|.viminfo etc.]:" | $saveCheckResult
echo "[Note] Environment variable files store user environment variables and can be used for backdoor persistence (requires manual inspection for signs of unauthorized modifications)." | $saveCheckResult
# Define list of environment variable file locations
envfile="/root/.bashrc /root/.bash_profile /root/.zshrc /root/.viminfo /etc/profile /etc/bashrc /etc/environment"
for file in $envfile;do
	if [ -e $file ];then
		echo "[+] Environment variable file: $file" | $saveCheckResult
		cat $file | $saveCheckResult
		printf "\n" | $saveCheckResult
		# Check if file content contains keywords like curl http https wget etc.
		if [ -n "$(cat $file | grep -E "curl|wget|http|https|python")" ];then
			echo "[!] Found environment variable file [$file] containing curl|wget|http|https|python keywords!" | $saveDangerResult | $saveCheckResult
		fi 
	else
		echo "[+] Environment variable file: $file" | $saveCheckResult
	fi
done
printf "\n" | $saveCheckResult


echo "[8.8] Checking hidden files in /root [cat -alt /root]" | $saveCheckResult
echo "[Note] Hidden files start with '.' and may contain malicious files, virus files, or cracking tools."  | $saveCheckResult
(ls -alt /root) | $saveCheckResult
printf "\n" | $saveCheckResult


echo "==========9. User Login Information==========" | $saveCheckResult
echo "[9.1] Checking currently logged-in users [who]:" | $saveCheckResult
(echo "[+] System logged-in users:" && who ) | $saveCheckResult
printf "\n" | $saveCheckResult
(echo "[+] System last logged-in users:" && last ) | $saveCheckResult
printf "\n" | $saveCheckResult


echo "[9.2] Viewing user information [/etc/passwd]:" | $saveCheckResult
echo "[Note] Username:Password:User ID:Group ID:Comment:Home Directory:Login Shell [Total 7 fields]" | $saveCheckResult
cat /etc/passwd  | $saveCheckResult
printf "\n" | $saveCheckResult


echo "[9.3] Checking for superusers [/etc/passwd]:" | $saveCheckResult
echo "[+] UID=0 indicates a superuser, default system root UID is 0" | $saveCheckResult
Superuser=$(cat /etc/passwd | egrep -v '^root|^#|^(\+:\*)?:0:0:::' | awk -F: '{if($3==0) print $1}')
if [ -n "$Superuser" ];then
	echo "[!] Superusers other than root found:" |  $saveDangerResult | $saveCheckResult
	for user in $Superuser
	do
		echo $user | $saveCheckResult
		if [ "${user}" = "toor" ];then
			echo "[!] BSD systems install 'toor' user by default, other systems do not. If this is not a BSD system, it is recommended to delete this account." | $saveCheckResult
		fi
	done
else
	echo "[+] No superusers found" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[9.4] Checking for cloned users [/etc/passwd]:" | $saveCheckResult
echo "[+] Same UID indicates cloned users" | $saveCheckResult
uid=$(awk -F: '{a[$3]++}END{for(i in a)if(a[i]>1)print i}' /etc/passwd)
if [ -n "$uid" ];then
	echo "[!] Users with the same UID found:" |  $saveDangerResult | $saveCheckResult
	(cat /etc/passwd | grep $uid | awk -F: '{print $1}') |  $saveDangerResult | $saveCheckResult
else
	echo "[+] No users with the same UID found" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[9.5] Checking for users who can log in [/etc/passwd]:" | $saveCheckResult
loginuser=$(cat /etc/passwd  | grep -E "/bin/bash$" | awk -F: '{print $1}')
if [ -n "$loginuser" ];then
	echo "[!] The following users can log in to the host:" |  $saveDangerResult | $saveCheckResult
	for user in $loginuser
	do
		echo $user |  $saveDangerResult | $saveCheckResult
	done
else
	echo "[+] No users who can log in found" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[9.6] Checking for non-system default users [/etc/login.defs]" | $saveCheckResult
if [ -f /etc/login.defs ];then
	uid=$(grep "^UID_MIN" /etc/login.defs | awk '{print $2}')
	(echo "Minimum system UID is "$uid) | $saveCheckResult
	nosystemuser=$(awk -F: '{if ($3>='$uid' && $3!=65534) {print $1}}' /etc/passwd)
	if [ -n "$nosystemuser" ];then
		(echo "The following users are not part of the default system users:" && echo "$nosystemuser") |  $saveDangerResult | $saveCheckResult
	else
		echo "[+] No users other than the default system users found" | $saveCheckResult
	fi
fi
printf "\n" | $saveCheckResult


echo "[9.7] Checking shadow file [/etc/shadow]:" | $saveCheckResult
echo "[Note] Username:Encrypted Password:Last Password Change:Minimum Password Age:Maximum Password Age:Password Warning Period:Password Inactivity Period:Account Expiration Date:Reserved Field [Total 9 fields]" | $saveCheckResult
(echo "[+] Shadow file as follows:" && cat /etc/shadow ) | $saveCheckResult
printf "\n" | $saveCheckResult


echo "[9.8] Checking for users with empty passwords [/etc/shadow]:" | $saveCheckResult
echo "[Principle] Users with an empty password field (second field) in the shadow file have empty passwords." | $saveCheckResult
nopasswd=$(awk -F: '($2=="") {print $1}' /etc/shadow)
if [ -n "$nopasswd" ];then
	(echo "[!] The following users have empty passwords:" && echo "$nopasswd") | $saveCheckResult
else
	echo "[+] No users with empty passwords found" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


# Principle:
# 1. Extract usernames from `/etc/passwd` using `/bin/bash` as the shell.
# 2. Get usernames with empty password fields from `/etc/shadow`.
# 3. Check if the SSH server configuration in `/etc/ssh/sshd_config` allows empty passwords.
# 4. Iterate through each username obtained in step 1 and check if it matches any username obtained in step 2, and whether empty passwords are allowed based on step 3. If a match is found, notify that there is a user with an empty password who can log in.
# 5. Finally, print a warning message requiring manual analysis of configurations and accounts, or print a message indicating no users with empty passwords and login permissions were found.
echo "[9.9] Checking for users with empty passwords and login permissions [/etc/passwd|/etc/shadow|/etc/ssh/sshd_config]:" | $saveCheckResult
# Methods to allow empty password users to log in:
# 1. passwd -d username
# 2. echo "PermitEmptyPasswords yes" >>/etc/ssh/sshd_config
# 3. service sshd restart
passwdUser=$(cat /etc/passwd  | grep -E "/bin/bash$" | awk -F: '{print $1}')
noSetPwdUser=$(gawk -F: '($2=="") {print $1}' /etc/shadow)
isPermit=$(cat /etc/ssh/sshd_config | grep -w "^PermitEmptyPasswords yes")
flag=""
for a in $passwdUser
do
    for b in $noSetPwdUser
    do
        if [ "$a" = "$b" ] && [ -n "$isPermit" ];then
            echo "[!] Found user with empty password and login permission:"$a  	| $saveDangerResult | $saveCheckResult
            flag=1
        fi
    done
done
if [ -n "$flag" ];then
	echo "Please manually analyze configurations and accounts" | $saveCheckResult
else
	echo "[+] No users with empty passwords and login permissions found" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[9.10] Checking for users with unencrypted passwords [/etc/passwd]:" | $saveCheckResult
noenypasswd=$(awk -F: '{if($2!="x") {print $1}}' /etc/passwd)
if [ -n "$noenypasswd" ];then
	(echo "[!] The following users have unencrypted passwords:" && echo "$noenypasswd") |  $saveDangerResult | $saveCheckResult
else
	echo "[+] No users with unencrypted passwords found"  | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[9.11] Checking group information:" | $saveCheckResult
echo "[9.11.1] Checking group information [/etc/group]:" | $saveCheckResult
echo "[+] Group information as follows:"
(cat /etc/group | grep -v "^#") | $saveCheckResult
printf "\n" | $saveCheckResult


echo "[9.11.2] Checking privileged users [/etc/group]:" | $saveCheckResult
roots=$(cat /etc/group | grep -v '^#' | gawk -F: '{if ($1!="root"&&$3==0) print $1}')
if [ -n "$roots" ];then
	echo "[!] Users other than root in the root group found:" |  $saveDangerResult | $saveCheckResult
	for user in $roots
	do
		echo $user |  $saveDangerResult | $saveCheckResult
	done
else 
	echo "[+] No users other than root found in the root group" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[9.11.3] Checking GID groups [/etc/group]:" | $saveCheckResult
groupuid=$(cat /etc/group | grep -v "^$" | awk -F: '{print $3}' | uniq -d)
if [ -n "$groupuid" ];then
	(echo "[!] Groups with the same GID found:" && echo "$groupuid") |  $saveDangerResult | $saveCheckResult
else
	echo "[+] No groups with the same GID found" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[9.11.4] Checking for duplicate group names [/etc/group]:" | $saveCheckResult
groupname=$(cat /etc/group | grep -v "^$" | awk -F: '{print $1}' | uniq -d)
if [ -n "$groupname" ];then
	(echo "[!] Duplicate group names found:" && echo "$groupname") |  $saveDangerResult | $saveCheckResult
else
	echo "[+] No duplicate group names found" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[9.12] Checking SSHD login configuration:" | $saveCheckResult
echo "[9.12.1] Checking sshd configuration [/etc/ssh/sshd_config]:" | $saveCheckResult
sshdconfig=$(cat /etc/ssh/sshd_config | egrep -v "#|^$")
if [ -n "$sshdconfig" ];then
	(echo "[+] SSHD configuration file as follows:" && echo "$sshdconfig") | $saveCheckResult
else
	echo "[!] SSHD configuration file not found" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[9.12] Checking SSHD login configuration:" | $saveCheckResult
echo "[9.12.1] Checking sshd configuration [/etc/ssh/sshd_config]:" | $saveCheckResult
sshdconfig=$(cat /etc/ssh/sshd_config | egrep -v "#|^$")
if [ -n "$sshdconfig" ];then
	(echo "[+] sshd configuration file as follows:" && echo "$sshdconfig") | $saveCheckResult
else
	echo "[!] sshd configuration file not found" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[9.12.2] Checking if SSH allows empty password login [/etc/ssh/sshd_config]:" | $saveCheckResult
emptypasswd=$(cat /etc/ssh/sshd_config | grep -w "^PermitEmptyPasswords yes")
nopasswd=$(awk -F: '($2=="") {print $1}' /etc/shadow)
if [ -n "$emptypasswd" ];then
	echo "[!] Empty password login is allowed, please note!"
	if [ -n "$nopasswd" ];then
		(echo "[!] The following users have empty passwords:" && echo "$nopasswd") |  $saveDangerResult | $saveCheckResult
	else
		echo "[+] No empty password users found" | $saveCheckResult
	fi
else
	echo "[+] Empty password user login is not allowed" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[9.12.3] Checking if SSH allows remote root login [/etc/ssh/sshd_config]:" | $saveCheckResult
cat /etc/ssh/sshd_config | grep -v ^# |grep "PermitRootLogin no"
if [ $? -eq 0 ];then
	echo "[+] Root login is not allowed, meets the requirements" | $saveCheckResult
else
	echo "[!] Remote root login is allowed, does not meet the requirements, suggest adding PermitRootLogin no to /etc/ssh/sshd_config" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[9.12.4] Checking SSH protocol version [/etc/ssh/sshd_config]:" | $saveCheckResult
echo "[Note] Detailed SSH version information needs to be checked separately to prevent outdated SSH versions with vulnerabilities" | $saveCheckResult
protocolver=$(cat /etc/ssh/sshd_config | grep -v ^$ | grep Protocol | awk '{print $2}')
if [ "$protocolver" = "2" ];then
	echo "[+] OpenSSH uses SSH2 protocol, meets the requirements" 
else
	echo "[!] OpenSSH does not use SSH2 protocol, does not meet the requirements"
fi


echo "[9.13] Checking login-related file permissions:" | $saveCheckResult
echo "[9.13.1] Checking etc file permissions [etc]:" | $saveCheckResult
etc=$(ls -l / | grep etc | awk '{print $1}')
if [ "${etc:1:9}" = "rwxr-x---" ]; then
    echo "[+]/etc/ permission is 750, normal permissions" | $saveCheckResult
else
    echo "[!]/etc/ file permissions are:""${etc:1:9}","permissions do not meet requirements, should be changed to 750" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[9.13.2] Checking shadow file permissions [/etc/shadow ]:" | $saveCheckResult
shadow=$(ls -l /etc/shadow | awk '{print $1}')
if [ "${shadow:1:9}" = "rw-------" ]; then
    echo "[+]/etc/shadow file permission is 600, meets the requirements" | $saveCheckResult
else
    echo "[!]/etc/shadow file permission is:""${shadow:1:9}"", does not meet the requirements, should be changed to 600" |  $saveDangerResult | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[9.13.3] Checking passwd file permissions [/etc/passwd]:" | $saveCheckResult
passwd=$(ls -l /etc/passwd | awk '{print $1}')
if [ "${passwd:1:9}" = "rw-r--r--" ]; then
    echo "[+]/etc/passwd file permission is 644, meets the requirements" | $saveCheckResult
else
    echo "[!]/etc/passwd file permission is:""${passwd:1:9}"", does not meet the requirements, suggest changing to 644" |  $saveDangerResult | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[9.13.4] Checking group file permissions [/etc/group ]:" | $saveCheckResult
group=$(ls -l /etc/group | awk '{print $1}')
if [ "${group:1:9}" = "rw-r--r--" ]; then
    echo "[+]/etc/group file permission is 644, meets the requirements" | $saveCheckResult
else
    echo "[!]/etc/goup file permission is""${group:1:9}","does not meet the requirements, should be changed to 644" |  $saveDangerResult | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[9.13.5] Checking securetty file permissions [/etc/securetty]:" | $saveCheckResult
securetty=$(ls -l /etc/securetty | awk '{print $1}')
if [ "${securetty:1:9}" = "-rw-------" ]; then
    echo "[+]/etc/securetty file permission is 600, meets the requirements" | $saveCheckResult
else
    echo "[!]/etc/securetty file permission is""${securetty:1:9}","does not meet the requirements, should be changed to 600" |  $saveDangerResult | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[9.13.6] Checking services file permissions [/etc/services]:" | $saveCheckResult
services=$(ls -l /etc/services | awk '{print $1}')
if [ "${services:1:9}" = "-rw-r--r--" ]; then
    echo "[+]/etc/services file permission is 644, meets the requirements" | $saveCheckResult
else
    echo "[!]/etc/services file permission is""$services:1:9}","does not meet the requirements, should be changed to 644" |  $saveDangerResult | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[9.13.7] Checking grub.conf file permissions [/etc/grub.conf]:" | $saveCheckResult
grubconf=$(ls -l /etc/grub.conf | awk '{print $1}')
if [ "${grubconf:1:9}" = "-rw-------" ]; then
    echo "[+]/etc/grub.conf file permission is 600, meets the requirements" | $saveCheckResult
else
    echo "[!]/etc/grub.conf file permission is""${grubconf:1:9}","does not meet the requirements, should be changed to 600" |  $saveDangerResult | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[9.13.8] Checking xinetd.conf file permissions [/etc/xinetd.conf]:" | $saveCheckResult
xinetdconf=$(ls -l /etc/xinetd.conf | awk '{print $1}')
if [ "${xinetdconf:1:9}" = "-rw-------" ]; then
    echo "[+]/etc/xinetd.conf file permission is 600, meets the requirements" | $saveCheckResult
else
    echo "[!]/etc/xinetd.conf file permission is""${xinetdconf:1:9}","does not meet the requirements, should be changed to 600" |  $saveDangerResult | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[9.13.9] Checking lilo.conf file permissions [/etc/lilo.conf ]:" | $saveCheckResult
if [ -f /etc/lilo.conf ];then
liloconf=$(ls -l /etc/lilo.conf | awk '{print $1}')
	if [ "${liloconf:1:9}" = "-rw-------" ];then
		echo "/etc/lilo.conf file permission is 600, meets the requirements" | $saveCheckResult
	else
		echo "/etc/lilo.conf file permission is not 600, does not meet the requirements, suggest setting permissions to 600" | $saveCheckResult
	fi
else
	echo "/etc/lilo.conf folder does not exist, no check required, meets the requirements"
fi
printf "\n" | $saveCheckResult


echo "[9.13.10] Checking limits.conf file permissions [/etc/security/limits.conf]:" | $saveCheckResult
cat /etc/security/limits.conf | grep -v ^# | grep core
if [ $? -eq 0 ];then
	soft=$(cat /etc/security/limits.conf | grep -v ^# | grep core | awk -F ' ' '{print $2}')
	for i in $soft
	do
		if [ $i = "soft" ];then
			echo "* soft core 0 has been set, meets the requirements" | $saveCheckResult
		fi
		if [ $i = "hard" ];then
			echo "* hard core 0 has been set, meets the requirements" | $saveCheckResult
		fi
	done
else 
	echo "core has not been set, suggest adding * soft core 0 and * hard core 0 in /etc/security/limits.conf"  | $saveCheckResult
fi


echo "[9.14] Checking login-related file attributes:" | $saveCheckResult
echo "[9.14.1] Checking passwd file attributes:" | $saveCheckResult
flag=0
for ((x=1;x<=15;x++))
do
	apend=$(lsattr /etc/passwd | cut -c $x)
	if [ $apend = "i" ];then
		echo "/etc/passwd file has i security attribute, meets the requirements" | $saveCheckResult
		flag=1
	fi
	if [ $apend = "a" ];then
		echo "/etc/passwd file has a security attribute" | $saveCheckResult
		flag=1
	fi
done

if [ $flag = 0 ];then
	echo "/etc/passwd file does not have related security attributes, suggest using chattr +i or chattr +a to prevent /etc/passwd from being deleted or modified" |  $saveDangerResult | $saveCheckResult
fi
printf "\n" | $saveCheckResult


# When a file or directory has the "a" attribute, only specific users or users with superuser privileges can modify, rename, or delete the file.
# Other regular users can only append data when writing to the file and cannot modify or delete existing data.
# The "i" attribute indicates that the file is set to immutable. This means the file cannot be changed, renamed, deleted, or linked.
# A file with the "i" attribute is read-only for any user or process and cannot be written to.

echo "[9.14.2] Checking shadow file attributes:" | $saveCheckResult
flag=0
for ((x=1;x<=15;x++))
do
	apend=$(lsattr /etc/shadow | cut -c $x)
	if [ $apend = "i" ];then
		echo "/etc/shadow file has i security attribute, meets the requirements" | $saveCheckResult
		flag=1
	fi
	if [ $apend = "a" ];then
		echo "/etc/shadow file has a security attribute" | $saveCheckResult
		flag=1
	fi
done
if [ $flag = 0 ];then
	echo "/etc/shadow file does not have related security attributes, suggest using chattr +i or chattr +a to prevent /etc/shadow from being deleted or modified" |  $saveDangerResult | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[9.14.3] Checking gshadow file attributes:" | $saveCheckResult
flag=0
for ((x=1;x<=15;x++))
do
	apend=$(lsattr /etc/gshadow | cut -c $x)
	if [ $apend = "i" ];then
		echo "/etc/gshadow file has i security attribute, meets the requirements" | $saveCheckResult
		flag=1
	fi
	if [ $apend = "a" ];then
		echo "/etc/gshadow file has a security attribute" | $saveCheckResult
		flag=1
	fi
done
if [ $flag = 0 ];then
	echo "/etc/gshadow file does not have related security attributes, suggest using chattr +i or chattr +a to prevent /etc/gshadow from being deleted or modified" |  $saveDangerResult | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[9.14.4] Checking group file attributes:" | $saveCheckResult
flag=0
for ((x=1;x<=15;x++))
do
	apend=$(lsattr /etc/group | cut -c $x)
	if [ $apend = "i" ];then
		echo "/etc/group file has i security attribute, meets the requirements" | $saveCheckResult
		flag=1
	fi
	if [ $apend = "a" ];then
		echo "/etc/group file has a security attribute" | $saveCheckResult
		flag=1
	fi
done
if [ $flag = 0 ];then
	echo "/etc/group file does not have related security attributes, suggest using chattr +i or chattr +a to prevent /etc/group from being deleted or modified" |  $saveDangerResult | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[9.15] Detecting useradd and userdel time attributes:" | $saveCheckResult
echo "Access: Access time, updated every time the file is accessed, such as using more, cat" | $saveCheckResult
echo "Modify: Modification time, updated when the file content changes" | $saveCheckResult
echo "Change: Change time, updated when the file attributes change; it is also updated when the file is modified, but only the change time is updated when file attributes like read/write permissions are altered, not the modification time" | $saveCheckResult
echo "[9.15.1] Checking useradd time attributes [/usr/sbin/useradd ]:" | $saveCheckResult
echo "[+] useradd time attributes:" | $saveCheckResult
stat /usr/sbin/useradd | egrep "Access|Modify|Change" | grep -v '(' | $saveCheckResult
printf "\n" | $saveCheckResult

echo "[9.15.2] Checking userdel time attributes [/usr/sbin/userdel]:" | $saveCheckResult
echo "[+] userdel time attributes:" | $saveCheckResult
stat /usr/sbin/userdel | egrep "Access|Modify|Change" | grep -v '(' | $saveCheckResult
printf "\n" | $saveCheckResult


echo "|----------------------------------------------------------------|" | $saveCheckResult
echo "==========10. Policy Configuration Check (Baseline Check)==========" | $saveCheckResult
echo "[10.1] Checking remote access policy:" | $saveCheckResult
echo "[10.1.1] Checking remote access policy [/etc/hosts.allow]:" | $saveCheckResult
hostsallow=$(cat /etc/hosts.allow | grep -v '#')
if [ -n "$hostsallow" ];then
	(echo "[!] The following IPs are allowed for remote access:" && echo "$hostsallow") |  $saveDangerResult | $saveCheckResult
else
	echo "[+] No remote access IPs found in hosts.allow file" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[10.1.2] Checking remote denial policy [/etc/hosts.deny]:" | $saveCheckResult
hostsdeny=$(cat /etc/hosts.deny | grep -v '#')
if [ -n "$hostsdeny" ];then
	(echo "[!] The following IPs are denied for remote access:" && echo "$hostsdeny") | $saveCheckResult
else
	echo "[+] No remote access IPs found in hosts.deny file" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[10.2] Checking password expiration policy:" | $saveCheckResult
echo "[10.2.1] Checking password expiration policy [/etc/login.defs ]:" | $saveCheckResult
(echo "[+] Password expiration policy as follows:" && cat /etc/login.defs | grep -v "#" | grep PASS ) | $saveCheckResult
printf "\n" | $saveCheckResult

echo "[10.2.1.1] Checking password lifetime:" | $saveCheckResult
passmax=$(cat /etc/login.defs | grep PASS_MAX_DAYS | grep -v ^# | awk '{print $2}')
if [ $passmax -le 90 -a $passmax -gt 0 ];then
	echo "[+] Password lifetime is ${passmax} days, meets the requirements" | $saveCheckResult
else
	echo "[!] Password lifetime is ${passmax} days, does not meet the requirements, suggest setting it between 0-90 days" | $saveCheckResult
fi


echo "[10.2.1.2]Minimum password change interval check in progress:" | $saveCheckResult
passmin=$(cat /etc/login.defs | grep PASS_MIN_DAYS | grep -v ^# | awk '{print $2}')
if [ $passmin -ge 6 ];then
	echo "[+]The minimum password change interval is ${passmin} days, which meets the requirements" | $saveCheckResult
else
	echo "[!]The minimum password change interval is ${passmin} days, which does not meet the requirements. It is recommended to set it to no less than 6 days" | $saveCheckResult
fi

echo "[10.2.1.3]Password minimum length check in progress:" | $saveCheckResult
passlen=$(cat /etc/login.defs | grep PASS_MIN_LEN | grep -v ^# | awk '{print $2}')
if [ $passlen -ge 8 ];then
	echo "[+]The minimum password length is ${passlen}, which meets the requirements" | $saveCheckResult
else
	echo "[!]The minimum password length is ${passlen}, which does not meet the requirements. It is recommended to set the minimum length to greater than or equal to 8" | $saveCheckResult
fi

echo "[10.2.1.4]Password expiration warning days check in progress:" | $saveCheckResult
passage=$(cat /etc/login.defs | grep PASS_WARN_AGE | grep -v ^# | awk '{print $2}')
if [ $passage -ge 30 -a $passage -lt $passmax ];then
	echo "[+]The password expiration warning days is ${passage}, which meets the requirements" | $saveCheckResult
else
	echo "[!]The password expiration warning days is ${passage}, which does not meet the requirements. It is recommended to set it to greater than or equal to 30 and less than the password lifetime" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[10.2.2]Checking password complexity policy[/etc/pam.d/system-auth]:" | $saveCheckResult
(echo "[+]Password complexity policy as follows:" && cat /etc/pam.d/system-auth | grep -v "#") | $saveCheckResult
printf "\n" | $saveCheckResult


echo "[10.2.3]Checking users with expired passwords[/etc/shadow]:" | $saveCheckResult
NOW=$(date "+%s")
day=$((${NOW}/86400))
passwdexpired=$(grep -v ":[\!\*x]([\*\!])?:" /etc/shadow | awk -v today=${day} -F: '{ if (($5!="") && (today>$3+$5)) { print $1 }}')
if [ -n "$passwdexpired" ];then
	(echo "[+]The following users have expired passwords:" && echo "$passwdexpired")  | $saveCheckResult
else
	echo "[+]No users with expired passwords found" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[10.2.4]Checking account timeout lock policy[/etc/profile]:" | $saveCheckResult
account_timeout=$(cat /etc/profile | grep TMOUT | awk -F[=] '{print $2}')
if [ "$account_timeout" != ""  ];then
	TMOUT=$(cat /etc/profile | grep TMOUT | awk -F[=] '{print $2}')
	if [ $TMOUT -le 600 -a $TMOUT -ge 10 ];then
		echo "[+]Account timeout is ${TMOUT} seconds, which meets the requirements" | $saveCheckResult
	else
		echo "[!]Account timeout is ${TMOUT} seconds, which does not meet the requirements. It is recommended to set it to less than 600 seconds" | $saveCheckResult
fi
else
	echo "[!]Account timeout is not locked, which does not meet the requirements. It is recommended to set it to less than 600 seconds" | $saveCheckResult 
fi
printf "\n" | $saveCheckResult


echo "[10.2.5]Checking grub password policy[/etc/grub.conf]:" | $saveCheckResult
grubpass=$(cat /etc/grub.conf | grep password)
if [ $? -eq 0 ];then
	echo "[+]Grub password is set, which meets the requirements" | $saveCheckResult 
else
	echo "[!]Grub password is not set, which does not meet the requirements. It is recommended to set a grub password" | $saveCheckResult 
fi
printf "\n" | $saveCheckResult


echo "[10.2.6]Checking lilo password policy[/etc/lilo.conf]:" | $saveCheckResult
if [ -f  /etc/lilo.conf ];then
	lilopass=$(cat /etc/lilo.conf | grep password 2> /dev/null)
	if [ $? -eq 0 ];then
		echo "[+]Lilo password is set, which meets the requirements" | $saveCheckResult
	else
		echo "[!]Lilo password is not set, which does not meet the requirements. It is recommended to set a lilo password" | $saveCheckResult
	fi
else
	echo "[+]File /etc/lilo.conf not found" | $saveCheckResult
fi


echo "[10.3]Checking selinux policy:" | $saveCheckResult
echo "[10.3.1]Checking selinux policy:" | $saveCheckResult
(echo "Selinux policy as follows:" && egrep -v '#|^$' /etc/sysconfig/selinux ) | $saveCheckResult
printf "\n" | $saveCheckResult


echo "[10.4]Checking SSHD configuration policy:" | $saveCheckResult
echo "[10.4.1]Checking sshd configuration[/etc/ssh/sshd_config]:" | $saveCheckResult
sshdconfig=$(cat /etc/ssh/sshd_config | egrep -v "#|^$")
if [ -n "$sshdconfig" ];then
	(echo "[+]Sshd configuration file as follows:" && echo "$sshdconfig") | $saveCheckResult
else
	echo "[!]Sshd configuration file not found" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[10.4.2]Checking whether SSH allows empty password login[/etc/ssh/sshd_config]:" | $saveCheckResult
emptypasswd=$(cat /etc/ssh/sshd_config | grep -w "^PermitEmptyPasswords yes")
nopasswd=$(awk -F: '($2=="") {print $1}' /etc/shadow)
if [ -n "$emptypasswd" ];then
	echo "[!]Empty password login is allowed, please be aware!"
	if [ -n "$nopasswd" ];then
		(echo "[!]The following users have empty passwords:" && echo "$nopasswd") |  $saveDangerResult | $saveCheckResult
	else
		echo "[+]No users with empty passwords found" | $saveCheckResult
	fi
else
	echo "[+]Empty password user login is not allowed" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[10.4.3]Checking whether SSH allows remote root login[/etc/ssh/sshd_config]:" | $saveCheckResult
cat /etc/ssh/sshd_config | grep -v ^# |grep "PermitRootLogin no"
if [ $? -eq 0 ];then
	echo "[+]Root login is not allowed, which meets the requirements" | $saveCheckResult
else
	echo "[!]Remote root login is allowed, which does not meet the requirements. It is recommended to add PermitRootLogin no to /etc/ssh/sshd_config" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[10.4.4]Checking SSH protocol version[/etc/ssh/sshd_config]:" | $saveCheckResult
echo "[Note]Detailed SSH version information needs to be checked separately to prevent low SSH versions with vulnerabilities" | $saveCheckResult
protocolver=$(cat /etc/ssh/sshd_config | grep -v ^$ | grep Protocol | awk '{print $2}')
if [ "$protocolver" = "2" ];then
	echo "[+]OpenSSH uses SSH2 protocol, which meets the requirements" 
else
	echo "[!]OpenSSH does not use SSH2 protocol, which does not meet the requirements"
fi

echo "[10.4.5]Checking SSH version[ssh -V]:" | $saveCheckResult
sshver=$(ssh -V)
if [ -n "$sshver" ];then
	(echo "[+]SSH version information as follows:" && echo "$sshver") | $saveCheckResult
else
	(echo "[!]No SSH version information found, please note this is an abnormal situation!") | $saveCheckResult
fi
printf "\n" | $saveCheckResult

echo "[10.5]Checking SNMP configuration policy:" | $saveCheckResult
echo "[10.5.1]Checking nis configuration[/etc/nsswitch.conf]:" | $saveCheckResult
nisconfig=$(cat /etc/nsswitch.conf | egrep -v '#|^$')
if [ -n "$nisconfig" ];then
	(echo "[+]NIS service configuration as follows:" && echo "$nisconfig") | $saveCheckResult
else
	echo "[+]NIS service configuration not found" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[10.6]Checking nginx configuration policy:" | $saveCheckResult
echo "[10.6.1]Checking Nginx configuration file[nginx/conf/nginx.conf]:" | $saveCheckResult
# nginx=$(whereis nginx | awk -F: '{print $2}')
nginx_bin=$(which nginx) 
if [ -n "$nginx_bin" ];then
	echo "[+]Nginx service found on the host" | $saveCheckResult
	echo "[+]Nginx service binary file path is:$nginx_bin" | $saveCheckResult
	# Get nginx config file location, if nginx -V cannot retrieve it, default to /etc/nginx/nginx.conf
	config_output="$($nginx_bin -V 2>&1)"
	config_path=$(echo "$config_output" | awk '/configure arguments:/ {split($0,a,"--conf-path="); if (length(a[2])>0) print a[2]}')  # Get nginx config file path

	# If awk command successfully returns the config file path, use it; otherwise, use the default path
	if [ -n "$config_path" ] && [ -f "$config_path" ]; then
		ngin_conf="$config_path"
	else
		ngin_conf="/etc/nginx/nginx.conf"
	fi

	if [ -f "$ngin_conf" ];then
		(echo "[+]Possible path for Nginx config file:$ngin_conf") | $saveCheckResult  # Output variable value
		echo "[Note]Only the main nginx.conf configuration file is checked here. Other imported configuration files are in the same directory as the main file. Please check manually" | $saveCheckResult
		(echo "[+]Nginx configuration file content is:" && cat $ngin_conf | grep -v "^$") | $saveCheckResult   # View file content
		echo "[10.6.2]Checking Nginx port forwarding configuration[$ngin_conf]:" | $saveCheckResult
		nginxportconf=$(cat $ngin_conf | grep -E "listen|server|server_name|upstream|proxy_pass|location"| grep -v "^$")
		if [ -n "$nginxportconf" ];then
			(echo "[+]Port forwarding may exist, please analyze manually:" && echo "$nginxportconf") | $saveCheckResult | $saveDangerResult
		else
			echo "[+]No port forwarding configuration found" | $saveCheckResult
		fi
	else
		echo "[!]Nginx configuration file not found" | $saveCheckResult
	fi
else
	echo "[+]Nginx service not found" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[10.7]Checking SNMP configuration policy:" | $saveCheckResult
echo "[10.7.1]Checking SNMP configuration[/etc/snmp/snmpd.conf]:." | $saveCheckResult
if [ -f /etc/snmp/snmpd.conf ];then
	public=$(cat /etc/snmp/snmpd.conf | grep public | grep -v ^# | awk '{print $4}')
	private=$(cat /etc/snmp/snmpd.conf | grep private | grep -v ^# | awk '{print $4}')
	if [ "$public" = "public" ];then
		echo "Default community name public found in SNMP service, which does not meet the requirements" | $saveCheckResult
	fi
	if [ "$private" = "private" ];then
		echo "Default community name private found in SNMP service, which does not meet the requirements" | $saveCheckResult
	fi
else
	echo "SNMP service configuration file not found, SNMP service may not be running" | $saveCheckResult
fi
printf "\n" | $saveCheckResult

echo "Firewall policy baseline is in section [2.6], no further elaboration!" | $saveCheckResult
echo "Configuration policy check (baseline check) completed!" | $saveCheckResult
echo "|^----------------------------------------------------------------^|" | $saveCheckResult



echo "==========11.History commands==========" | $saveCheckResult
echo "[11.1]Checking history commands[/root/.bash_history]:" | $saveCheckResult
echo "[Note]If the history commands have been cleared, please manually check using the history command (check if the history number is missing)" | $saveCheckResult
history=$(cat /root/.bash_history)
if [ -n "$history" ];then
	(echo "[+]Operating system history commands as follows:" && echo "$history") | $saveCheckResult
else
	echo "[!]No history commands found, please check if they were recorded and cleared" | $saveDangerResult | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[11.1.2]Checking if script files have been downloaded via history[/root/.bash_history]:" | $saveCheckResult
scripts=$(cat /root/.bash_history | grep -E "((wget|curl).*\.(sh|pl|py|exe)$)" | grep -v grep)
if [ -n "$scripts" ];then
	(echo "[!]Scripts have been downloaded on the server:" && echo "$scripts") |  $saveDangerResult | $saveCheckResult
else
	echo "[+]No script files have been downloaded on the server" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[11.1.3]Checking if accounts have been added via history[history]:" | $saveCheckResult
addusers=$(history | egrep "(useradd|groupadd)" | grep -v grep)
if [ -n "$addusers" ];then
	(echo "[!]Accounts have been added on the server:" && echo "$addusers") |  $saveDangerResult | $saveCheckResult
else
	echo "[+]No accounts have been added on the server" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[11.1.4]Checking if accounts have been deleted via history[history]:" | $saveCheckResult
delusers=$(history | egrep "(userdel|groupdel)" | grep -v grep)
if [ -n "$delusers" ];then
	(echo "[!]Accounts have been deleted on the server:" && echo "$delusers") |  $saveDangerResult | $saveCheckResult
else
	echo "[+]No accounts have been deleted on the server" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[11.1.5]Checking suspicious hacker commands in history:" | $saveCheckResult
echo "[Note]Matching rules can be maintained by yourself. The list is as follows:id|whoami|whois|sqlmap|nmap|beef|nikto|john|ettercap|backdoor|*proxy|msfconsole|msf|frp*|xray|*scan|mv|wget|python*|yum|apt-get" | $saveCheckResult
danger_histroy=$(history | grep -E "(id|whoami|whois|sqlmap|nmap|beef|nikto|john|ettercap|backdoor|*proxy|msfconsole|msf|frp*|xray|*scan|mv|wget|python*|yum|apt-get)" | grep -v grep)
if [ -n "$danger_histroy" ];then
	(echo "[!]Suspicious history commands found" && echo "$danger_histroy") |  $saveDangerResult | $saveCheckResult
else
	echo "[+]No suspicious history commands found" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[11.1.6]Checking CRT download records in history[history | grep sz]:" | $saveCheckResult
uploadfiles=$(history | grep sz | grep -v grep | awk '{print $3}')
if [ -n "$uploadfiles" ];then
	(echo "[!]The following files have been downloaded from the local host according to the history log:" && echo "$uploadfiles") | $saveCheckResult
else
	echo "[+]No files have been downloaded from the local host according to the history log" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[11.1.7] Checking host download records in history commands [history | grep yum]:" | $saveCheckResult
yum_history=$(history | grep -E "(wget|curl|python*|yum|apt-get|apt)" | grep -v grep )
if [ -n "$yum_history" ];then
	(echo "[!] Host download commands found in history logs as follows:" && echo "$yum_history") | $saveDangerResult | $saveCheckResult
else
	echo "[+] No host download files found in history logs" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[11.1.8] Checking if the history command has disabled the history recording function [set +o history]:" | $saveCheckResult
echo "[Note] set +o history disables the command history recording function, which can be checked via the history command. set -o history re-enables it." | $saveCheckResult
clearhistory=$(history | grep "set +o history" | grep -v grep)
if [ -n "$clearhistory" ];then
	(echo "[!] Commands to disable history recording found in history logs as follows:" && echo "$clearhistory") | $saveDangerResult | $saveCheckResult
else
	echo "[+] No commands to disable history recording found in history logs" | $saveCheckResult
fi



echo "[11.2] Checking database operation history commands [/root/.mysql_history]:" | $saveCheckResult
mysql_history=$(cat /root/.mysql_history)
if [ -n "$mysql_history" ];then
	(echo "[+] Database operation history commands as follows:" && echo "$mysql_history") | $saveCheckResult
else
	echo "[+] No database operation history commands found" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "==========12.Suspicious File Check==========" | $saveCheckResult
echo "[12.1] Checking script files [py|sh|per|pl|exe]:" | $saveCheckResult
echo "[Note] Does not check /usr, /etc, /var directories. Modify the script manually if needed. This requires manual judgment of whether it is harmful." | $saveCheckResult
scripts=$(find / *.* | egrep "\.(py|sh|per|pl|exe)$" | egrep -v "/usr|/etc|/var")
if [ -n "scripts" ];then
	(echo "[!] The following script files were found, please note!" && echo "$scripts") |  $saveDangerResult | $saveCheckResult
else
	echo "[+] No script files found" | $saveCheckResult
fi
printf "\n" | $saveCheckResult

# You can place an rkhunter tar package, extract it, and run directly
echo "[12.2] Checking webshell files:" | $saveCheckResult
echo "Webshell detection is technically challenging, and there are already professional tools available. It is recommended to use dedicated security tools for this purpose." | $saveCheckResult
echo "Please use the rkhunter tool to check for malicious files at the system level. Download link: http://rkhunter.sourceforge.net" | $saveCheckResult
printf "\n" | $saveCheckResult

echo "[12.3] Checking sensitive files modified in the last 24 hours [py|sh|per|pl|php|asp|jsp|exe]:" | $saveCheckResult
echo "[Note] find / -mtime -1 -type f " | $saveCheckResult
(find / -mtime -1 -type f | grep -E "\.(py|sh|per|pl|php|asp|jsp|exe)$") |  $saveDangerResult | $saveCheckResult
printf "\n" | $saveCheckResult

echo "[12.4] Checking all files modified in the last 24 hours:" | $saveCheckResult
# View files modified in the last 24 hours, excluding /proc, /dev, /sys  
echo "[Note] Does not check /proc, /dev, /sys, /run directories. Modify the script manually if needed. This requires manual judgment of whether it is harmful." | $saveCheckResult
(find / ! \( -path "/proc/*" -o -path "/dev/*" -o -path "/sys/*" -o -path "/run/*" \) -type f -mtime -1) | $saveDangerResult | $saveCheckResult
printf "\n" | $saveCheckResult


echo "[12.5] Checking if hacker tools exist on the entire disk [./checkrules/hackertoolslist.txt]:" | $saveCheckResult
# hacker_tools_list="nc sqlmap nmap xray beef nikto john ettercap backdoor *proxy msfconsole msf *scan nuclei *brute* gtfo Titan zgrab frp* lcx *reGeorg nps spp suo5 sshuttle v2ray"
# Take a tool name from the hacker_tools_list and search the entire disk
# hacker_tools_list=$(cat ./checkrules/hackertoolslist.txt)
echo "[Note] Define a hacker tools list file hackertoolslist.txt, search the entire disk for tool names in this list, and alert if found (the tool file can be maintained manually)." | $saveCheckResult
hacker_tools_list=$(cat ${current_dir}/checkrules/hackertoolslist.txt)
# for hacker_tool in `cat ${current_dir}/checkrules/hackertoolslist.txt`
for hacker_tool in $hacker_tools_list
do
	findhackertool=$(find / -name $hacker_tool 2>/dev/null)
	if [ -n "$findhackertool" ];then
		(echo "[!] Suspicious hacker tool found on the entire disk: $hacker_tool" && echo "$findhackertool") |  $saveDangerResult | $saveCheckResult
	else
		echo "[+] No suspicious hacker tools found on the entire disk: $hacker_tool" | $saveCheckResult
	fi
	printf "\n" | $saveCheckResult
done


echo "==========13.System File Integrity Verification==========" | $saveCheckResult
# Extract MD5 values of system critical files. On one hand, these MD5 values can be queried through threat intelligence platforms.
# On the other hand, when using this software for multiple checks, the corresponding MD5 values will be compared. If different from the previous check, an alert will be triggered.
# Used to verify if files have been tampered with.
echo "[13.1] Collecting MD5 values of system critical files:" | $saveCheckResult
echo "[Note] MD5 values for querying threat intelligence or preventing binary file tampering (requires manual comparison of MD5 values)" | $saveCheckResult
echo "[Note] MD5 value export location: ${check_file}/sysfile_md5.txt" | $saveCheckResult
file="${check_file}/sysfile_md5.txt"
if [ -e "$file" ]; then 
	md5sum -c "$file" 2>&1; 
else
	md5sum /usr/bin/awk >> $file
	md5sum /usr/bin/basename >> $file
	md5sum /usr/bin/bash >> $file
	md5sum /usr/bin/cat >> $file
	md5sum /usr/bin/chattr >> $file
	md5sum /usr/bin/chmod >> $file
	md5sum /usr/bin/chown >> $file
	md5sum /usr/bin/cp >> $file
	md5sum /usr/bin/csh >> $file
	md5sum /usr/bin/curl >> $file
	md5sum /usr/bin/cut >> $file
	md5sum /usr/bin/date >> $file
	md5sum /usr/bin/df >> $file
	md5sum /usr/bin/diff >> $file
	md5sum /usr/bin/dirname >> $file
	md5sum /usr/bin/dmesg >> $file
	md5sum /usr/bin/du >> $file
	md5sum /usr/bin/echo >> $file
	md5sum /usr/bin/ed >> $file
	md5sum /usr/bin/egrep >> $file
	md5sum /usr/bin/env >> $file
	md5sum /usr/bin/fgrep >> $file
	md5sum /usr/bin/file >> $file
	md5sum /usr/bin/find >> $file
	md5sum /usr/bin/gawk >> $file
	md5sum /usr/bin/GET >> $file
	md5sum /usr/bin/grep >> $file
	md5sum /usr/bin/groups >> $file
	md5sum /usr/bin/head >> $file
	md5sum /usr/bin/id >> $file
	md5sum /usr/bin/ipcs >> $file
	md5sum /usr/bin/kill >> $file
	md5sum /usr/bin/killall >> $file
	md5sum /usr/bin/kmod >> $file
	md5sum /usr/bin/last >> $file
	md5sum /usr/bin/lastlog >> $file
	md5sum /usr/bin/ldd >> $file
	md5sum /usr/bin/less >> $file
	md5sum /usr/bin/locate >> $file
	md5sum /usr/bin/logger >> $file
	md5sum /usr/bin/login >> $file
	md5sum /usr/bin/ls >> $file
	md5sum /usr/bin/lsattr >> $file
	md5sum /usr/bin/lynx >> $file
	md5sum /usr/bin/mail >> $file
	md5sum /usr/bin/mailx >> $file
	md5sum /usr/bin/md5sum >> $file
	md5sum /usr/bin/mktemp >> $file
	md5sum /usr/bin/more >> $file
	md5sum /usr/bin/mount >> $file
	md5sum /usr/bin/mv >> $file
	md5sum /usr/bin/netstat >> $file
	md5sum /usr/bin/newgrp >> $file
	md5sum /usr/bin/numfmt >> $file
	md5sum /usr/bin/passwd >> $file
	md5sum /usr/bin/perl >> $file
	md5sum /usr/bin/pgrep >> $file
	md5sum /usr/bin/ping >> $file
	md5sum /usr/bin/pkill >> $file
	md5sum /usr/bin/ps >> $file
	md5sum /usr/bin/pstree >> $file
	md5sum /usr/bin/pwd >> $file
	md5sum /usr/bin/readlink >> $file
	md5sum /usr/bin/rpm >> $file
	md5sum /usr/bin/runcon >> $file
	md5sum /usr/bin/sed >> $file
	md5sum /usr/bin/sh >> $file
	md5sum /usr/bin/sha1sum >> $file
	md5sum /usr/bin/sha224sum >> $file
	md5sum /usr/bin/sha256sum >> $file
	md5sum /usr/bin/sha384sum >> $file
	md5sum /usr/bin/sha512sum >> $file
	md5sum /usr/bin/size >> $file
	md5sum /usr/bin/sort >> $file
	md5sum /usr/bin/ssh >> $file
	md5sum /usr/bin/stat >> $file
	md5sum /usr/bin/strace >> $file
	md5sum /usr/bin/strings >> $file
	md5sum /usr/bin/su >> $file
	md5sum /usr/bin/sudo >> $file
	md5sum /usr/bin/systemctl >> $file
	md5sum /usr/bin/tail >> $file
	md5sum /usr/bin/tcsh >> $file
	md5sum /usr/bin/telnet >> $file
	md5sum /usr/bin/test >> $file
	md5sum /usr/bin/top >> $file
	md5sum /usr/bin/touch >> $file
	md5sum /usr/bin/tr >> $file
	md5sum /usr/bin/uname >> $file
	md5sum /usr/bin/uniq >> $file
	md5sum /usr/bin/users >> $file
	md5sum /usr/bin/vmstat >> $file
	md5sum /usr/bin/w >> $file
	md5sum /usr/bin/watch >> $file
	md5sum /usr/bin/wc >> $file
	md5sum /usr/bin/wget >> $file
	md5sum /usr/bin/whatis >> $file
	md5sum /usr/bin/whereis >> $file
	md5sum /usr/bin/which >> $file
	md5sum /usr/bin/who >> $file
	md5sum /usr/bin/whoami >> $file
	md5sum /usr/lib/systemd/s >> $file
	md5sum /usr/local/bin/rkh >> $file
	md5sum /usr/sbin/adduser >> $file
	md5sum /usr/sbin/chkconfi >> $file
	md5sum /usr/sbin/chroot >> $file
	md5sum /usr/sbin/depmod >> $file
	md5sum /usr/sbin/fsck >> $file
	md5sum /usr/sbin/fuser >> $file
	md5sum /usr/sbin/groupadd >> $file
	md5sum /usr/sbin/groupdel >> $file
	md5sum /usr/sbin/groupmod >> $file
	md5sum /usr/sbin/grpck >> $file
	md5sum /usr/sbin/ifconfig >> $file
	md5sum /usr/sbin/ifdown >> $file
	md5sum /usr/sbin/ifup >> $file
	md5sum /usr/sbin/init >> $file
	md5sum /usr/sbin/insmod >> $file
	md5sum /usr/sbin/ip >> $file
	md5sum /usr/sbin/lsmod >> $file
	md5sum /usr/sbin/lsof >> $file
	md5sum /usr/sbin/modinfo >> $file
	md5sum /usr/sbin/modprobe >> $file
	md5sum /usr/sbin/nologin >> $file
	md5sum /usr/sbin/pwck >> $file
	md5sum /usr/sbin/rmmod >> $file
	md5sum /usr/sbin/route >> $file
	md5sum /usr/sbin/rsyslogd >> $file
	md5sum /usr/sbin/runlevel >> $file
	md5sum /usr/sbin/sestatus >> $file
	md5sum /usr/sbin/sshd >> $file
	md5sum /usr/sbin/sulogin >> $file
	md5sum /usr/sbin/sysctl >> $file
	md5sum /usr/sbin/tcpd >> $file
	md5sum /usr/sbin/useradd >> $file
	md5sum /usr/sbin/userdel >> $file
	md5sum /usr/sbin/usermod >> $file
	md5sum /usr/sbin/vipw >> $file
fi
printf "\n" | $saveCheckResult


echo "==========14.System Log Analysis==========" | $saveCheckResult
echo "[14.1] Log Configuration and Packaging:" | $saveCheckResult
echo "[14.1.1] Checking rsyslog log configuration [/etc/rsyslog.conf]:" | $saveCheckResult
logconf=$(cat /etc/rsyslog.conf | egrep -v "#|^$")
if [ -n "$logconf" ];then
	(echo "[+] Log configuration as follows:" && echo "$logconf") | $saveCheckResult
else
	echo "[!] Log configuration file not found" |  $saveDangerResult | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[14.1.2] Analyzing if log files exist: [/var/log/]" | $saveCheckResult
logs=$(ls -l /var/log/)
if [ -n "$logs" ];then
	echo "[+] Log files exist" | $saveCheckResult
else
	echo "[!] Log files do not exist, analyze if they were cleared!" |  $saveDangerResult | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[14.1.3] Analyzing if log auditing is enabled [service auditd status]:" | $saveCheckResult
service auditd status | grep running
if [ $? -eq 0 ];then
	echo "[+] System log auditing is enabled, meets requirements" | $saveCheckResult
else
	echo "[!] System log auditing is disabled, does not meet requirements. It is recommended to enable log auditing. Use the following command to enable: service auditd start" |  $saveDangerResult | $saveCheckResult
fi
printf "\n" | $saveCheckResult

echo "[14.1.4] Packaging /var/log logs [script will package them at the end]" | $saveCheckResult


echo "[14.2] Analyzing secure log:" | $saveCheckResult
echo "[14.2.1] Checking login success records in logs [/var/log/secure*]:" | $saveCheckResult
loginsuccess=$(cat /var/log/secure* | grep "Accepted password" | awk '{print $1,$2,$3,$9,$11}')
if [ -n "$loginsuccess" ];then
	(echo "[+] The following user login success records were analyzed in the log:" && echo "$loginsuccess")  | $saveCheckResult
	(echo "[+] IPs and times of successful logins are as follows:" && grep "Accepted " /var/log/secure* | awk '{print $11}' | sort -nr | uniq -c )  | $saveCheckResult
	(echo "[+] Users and times of successful logins are as follows:" && grep "Accepted" /var/log/secure* | awk '{print $9}' | sort -nr | uniq -c )  | $saveCheckResult
else
	echo "[+] No successful login was found in the log" | $saveCheckResult
fi
printf "\n" | $saveCheckResult

echo "[14.2.2] Checking login failure records in logs (SSH brute force attack) [/var/log/secure*]:" | $saveCheckResult
loginfailed=$(cat /var/log/secure* | grep "Failed password" | awk '{print $1,$2,$3,$9,$11}')
if [ -n "$loginfailed" ];then
	(echo "[!] The following login failure records were found in the log:" && echo "$loginfailed") | $saveDangerResult  | $saveCheckResult
	(echo "[!] IPs and times of failed logins (suspected SSH brute force attack) are as follows:" && grep "Failed password" /var/log/secure* | awk '{print $11}' | sort -nr | uniq -c) | $saveDangerResult  | $saveCheckResult
	(echo "[!] Users and times of failed logins (suspected SSH brute force attack) are as follows:" && grep "Failed password" /var/log/secure* | awk '{print $9}' | sort -nr | uniq -c) | $saveDangerResult  | $saveCheckResult
	(echo "[!] Username dictionary information for SSH brute force attacks is as follows:" && grep "Failed password" /var/log/secure* | perl -e 'while($_=<>){ /for(.*?) from/; print "$1\n";}'|uniq -c|sort -nr) | $saveDangerResult  | $saveCheckResult
else
	echo "[+] No login failure was found in the log" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[14.2.3] Checking local window login status [/var/log/secure*]:" | $saveCheckResult
systemlogin=$(cat /var/log/secure* | grep -E "sshd:session.*session opened" | awk '{print $1,$2,$3,$11}')
if [ -n "$systemlogin" ];then
	(echo "[+] Local login status:" && echo "$systemlogin") | $saveCheckResult
	(echo "[+] Local login accounts and counts are as follows:" && cat /var/log/secure* | grep -E "sshd:session.*session opened" | awk '{print $11}' | sort -nr | uniq -c) | $saveCheckResult
else
	echo "[!] No local login/logout activity found, please pay attention!" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[14.2.4] Checking for newly added users [/var/log/secure*]:" | $saveCheckResult
newusers=$(cat /var/log/secure* | grep "new user"  | awk -F '[=,]' '{print $1,$2}' | awk '{print $1,$2,$3,$9}')
if [ -n "$newusers" ];then
	(echo "[!] New users found in logs:" && echo "$newusers") |  $saveDangerResult | $saveCheckResult
	(echo "[+] Newly added user accounts and counts are as follows:" && cat /var/log/secure* | grep "new user" | awk '{print $8}' | awk -F '[=,]' '{print $2}' | sort | uniq -c) | $saveCheckResult
else
	echo "[+] No newly added users found in logs" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[14.2.5] Checking for newly added user groups [/var/log/secure*]:" | $saveCheckResult
newgoup=$(cat /var/log/secure* | grep "new group"  | awk -F '[=,]' '{print $1,$2}' | awk '{print $1,$2,$3,$9}')
if [ -n "$newgoup" ];then
	(echo "[!] New user groups found in logs:" && echo "$newgoup") |  $saveDangerResult | $saveCheckResult
	(echo "[+] Newly added user groups and counts are as follows:" && cat /var/log/secure* | grep "new group" | awk '{print $8}' | awk -F '[=,]' '{print $2}' | sort | uniq -c) | $saveCheckResult
else
	echo "[+] No newly added user groups found in logs" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[14.3] Analyzing message logs:" | $saveCheckResult
# The command below only displays the filenames of transferred files and removes duplicates with the same filename
#cat /var/log/message* | grep "ZMODEM:.*BPS" | awk -F '[]/]' '{print $0}' | sort | uniq
echo "[14.3.1] Checking transferred files [/var/log/message*]:" | $saveCheckResult
zmodem=$(cat /var/log/message* | grep "ZMODEM:.*BPS")
if [ -n "$zmodem" ];then
	(echo "[!] File transfer status:" && echo "$zmodem") |  $saveDangerResult | $saveCheckResult
else
	echo "[+] No file transfers found in logs" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[14.3.2] Checking DNS server usage in logs [/var/log/message*]:" | $saveCheckResult
dns_history=$(cat /var/log/messages* | grep "using nameserver" | awk '{print $NF}' | awk -F# '{print $1}' | sort | uniq)
if [ -n "$dns_history" ];then
	(echo "[!] This server has used the following DNS servers:" && echo "$dns_history") |  $saveDangerResult | $saveCheckResult
else
	echo "[+] No DNS server usage found" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[14.4] Analyzing cron logs:" | $saveCheckResult
echo "[14.4.1] Analyzing scheduled downloads [/var/log/cron*]:" | $saveCheckResult
cron_download=$(cat /var/log/cron* | grep "wget|curl")
if [ -n "$cron_download" ];then
	(echo "[!] Scheduled download status:" && echo "$cron_download") |  $saveDangerResult | $saveCheckResult
else
	echo "[+] No scheduled downloads found" | $saveCheckResult
fi
printf "\n" | $saveCheckResult

echo "[14.4.2] Analyzing scheduled script execution [/var/log/cron*]:" | $saveCheckResult
cron_shell=$(cat /var/log/cron* | grep -E "\.py$|\.sh$|\.pl$|\.exe$") 
if [ -n "$cron_shell" ];then
	(echo "[!] Scheduled script execution found:" && echo "$cron_download") |  $saveDangerResult | $saveCheckResult
else
	echo "[+] No scheduled scripts found" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


# For Ubuntu, use cat /var/log/apt/* 【to be supplemented later】
echo "[14.5] Analyzing yum logs:" | $saveCheckResult
echo "[14.5.1] Analyzing software installations via yum [/var/log/yum*]:" | $saveCheckResult
yum_install=$(cat /var/log/yum* | grep Installed | awk '{print $NF}' | sort | uniq)
if [ -n "$yum_install" ];then
	(echo "[+] The following software was installed using yum:"  && echo "$yum_install") | $saveCheckResult
else
	echo "[+] No software installed via yum" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[14.5.2] Analyzing script file installations via yum [/var/log/yum*]:" | $saveCheckResult
yum_installscripts=$(cat /var/log/yum* | grep Installed | grep -E "(\.sh$\.py$|\.pl$|\.exe$)" | awk '{print $NF}' | sort | uniq)
if [ -n "$yum_installscripts" ];then
	(echo "[!] The following script files were installed using yum:"  && echo "$yum_installscripts") | $saveDangerResult | $saveCheckResult
else
	echo "[+] No script files installed via yum" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[14.5.3] Checking software uninstallations via yum [/var/log/yum*]:" | $saveCheckResult
yum_erased=$(cat /var/log/yum* | grep Erased)
if [ -n "$yum_erased" ];then
	(echo "[+] The following software was uninstalled using yum:" && echo "$yum_erased")  | $saveCheckResult
else
	echo "[+] No software uninstalled via yum" | $saveCheckResult
fi
printf "\n" | $saveCheckResult

echo "[14.5.4] Checking for suspicious tools installed via yum [./checkrules/hackertoolslist.txt]:" | $saveCheckResult
# Extract a tool name from the file and match it
hacker_tools_list=$(cat ./checkrules/hackertoolslist.txt)
for hacker_tools in $hacker_tools_list;do
	hacker_tools=$(cat /var/log/yum* | awk -F: '{print $NF}' | awk -F '[-]' '{print }' | sort | uniq | grep -E "$hacker_tools")
	if [ -n "$hacker_tools" ];then
		(echo "[!] Suspicious software installed via yum detected:"&& echo "$hacker_tools") |  $saveDangerResult | $saveCheckResult
	else
		echo "[+] No suspicious software installed via yum" | $saveCheckResult
	fi
done
printf "\n" | $saveCheckResult


echo "[14.6] Analyzing dmesg logs [dmesg]:" | $saveCheckResult
echo "[14.6.1] Viewing kernel self-check logs:" | $saveCheckResult
dmesg=$(dmesg)
if [ $? -eq 0 ];then
	(echo "[+] Kernel self-check logs are as follows：" && "$dmesg" ) | $saveCheckResult
else
	echo "[+] No kernel self-check logs found" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[14.7] Analyzing btmp logs [lastb]:" | $saveCheckResult
echo "[16.7.1] Analyzing failed login logs:" | $saveCheckResult
lastb=$(lastb)
if [ -n "$lastb" ];then
	(echo "[+] Failed login logs are as follows:" && echo "$lastb") | $saveCheckResult
else
	echo "[+] No failed login logs found" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[14.8] Analyzing lastlog logs [lastlog]:" | $saveCheckResult
echo "[14.8.1] Analyzing last login logs for all users:" | $saveCheckResult
lastlog=$(lastlog)
if [ -n "$lastlog" ];then
	(echo "[+] Last login logs for all users are as follows:" && echo "$lastlog") | $saveCheckResult
else
	echo "[+] No last login logs for all users found" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[14.9] Analyzing wtmp logs [last]:" | $saveCheckResult
echo "[14.9.1] Checking historical logins to this machine:" | $saveCheckResult
lasts=$(last | grep pts | grep -vw :0)
if [ -n "$lasts" ];then
	(echo "[+] Historical logins to this machine are as follows:" && echo "$lasts") | $saveCheckResult
else
	echo "[+] No historical login information found for this machine" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[14.10] Analyzing journalctl logs:" | $saveCheckResult
# Check journalctl logs from the past 24 hours
echo "[14.10.1] Checking logs from the past 24 hours [journalctl --since \"24 hours ago\"]:" | $saveCheckResult
journalctl=$(journalctl --since "24 hours ago")
if [ -n "$journalctl" ];then
	echo "[+] journalctl logs from the past 24 hours are output to [$log_file/journalctl.txt]:" | $saveCheckResult
	echo "$journalctl" >> $log_file/journalctl.txt
else
	echo "[+] No journalctl logs found from the past 24 hours" | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "==========15. Kernel Analysis==========" | $saveCheckResult
echo "[15.1] Checking kernel information:." | $saveCheckResult
lsmod=$(lsmod)
if [ -n "$lsmod" ];then
	(echo "[+] Kernel information is as follows:" && echo "$lsmod") | $saveCheckResult
else
	echo "[+] No kernel information found" | $saveCheckResult
fi
printf "\n" | $saveCheckResult

echo "[15.2] Checking for abnormal kernel modules [lsmod]:" | $saveCheckResult
danger_lsmod=$(lsmod | grep -Ev "ablk_helper|ac97_bus|acpi_power_meter|aesni_intel|ahci|ata_generic|ata_piix|auth_rpcgss|binfmt_misc|bluetooth|bnep|bnx2|bridge|cdrom|cirrus|coretemp|crc_t10dif|crc32_pclmul|crc32c_intel|crct10dif_common|crct10dif_generic|crct10dif_pclmul|cryptd|dca|dcdbas|dm_log|dm_mirror|dm_mod|dm_region_hash|drm|drm_kms_helper|drm_panel_orientation_quirks|e1000|ebtable_broute|ebtable_filter|ebtable_nat|ebtables|edac_core|ext4|fb_sys_fops|floppy|fuse|gf128mul|ghash_clmulni_intel|glue_helper|grace|i2c_algo_bit|i2c_core|i2c_piix4|i7core_edac|intel_powerclamp|ioatdma|ip_set|ip_tables|ip6_tables|ip6t_REJECT|ip6t_rpfilter|ip6table_filter|ip6table_mangle|ip6table_nat|ip6table_raw|ip6table_security|ipmi_devintf|ipmi_msghandler|ipmi_si|ipmi_ssif|ipt_MASQUERADE|ipt_REJECT|iptable_filter|iptable_mangle|iptable_nat|iptable_raw|iptable_security|iTCO_vendor_support|iTCO_wdt|jbd2|joydev|kvm|kvm_intel|libahci|libata|libcrc32c|llc|lockd|lpc_ich|lrw|mbcache|megaraid_sas|mfd_core|mgag200|Module|mptbase|mptscsih|mptspi|nf_conntrack|nf_conntrack_ipv4|nf_conntrack_ipv6|nf_defrag_ipv4|nf_defrag_ipv6|nf_nat|nf_nat_ipv4|nf_nat_ipv6|nf_nat_masquerade_ipv4|nfnetlink|nfnetlink_log|nfnetlink_queue|nfs_acl|nfsd|parport|parport_pc|pata_acpi|pcspkr|ppdev|rfkill|sch_fq_codel|scsi_transport_spi|sd_mod|serio_raw|sg|shpchp|snd|snd_ac97_codec|snd_ens1371|snd_page_alloc|snd_pcm|snd_rawmidi|snd_seq|snd_seq_device|snd_seq_midi|snd_seq_midi_event|snd_timer|soundcore|sr_mod|stp|sunrpc|syscopyarea|sysfillrect|sysimgblt|tcp_lp|ttm|tun|uvcvideo|videobuf2_core|videobuf2_memops|videobuf2_vmalloc|videodev|virtio|virtio_balloon|virtio_console|virtio_net|virtio_pci|virtio_ring|virtio_scsi|vmhgfs|vmw_balloon|vmw_vmci|vmw_vsock_vmci_transport|vmware_balloon|vmwgfx|vsock|xfs|xt_CHECKSUM|xt_conntrack|xt_state")
if [ -n "$danger_lsmod" ];then
	(echo "[!] Suspicious kernel modules detected:" && echo "$danger_lsmod") |  $saveDangerResult | $saveCheckResult
else
	echo "[+] No suspicious kernel modules found" | $saveCheckResult
fi
printf "\n" | $saveCheckResult

echo "==========16. Installed Software (rpm)==========" | $saveCheckResult
echo "[16.1] Checking installed software and versions via rpm [rpm -qa]:" | $saveCheckResult
software=$(rpm -qa | awk -F- '{print $1,$2}' | sort -nr -k2 | uniq)
if [ -n "$software" ];then
	(echo "[+] Installed software and versions are as follows:" && echo "$software") | $saveCheckResult
else
	echo "[+] No software installed on the system" | $saveCheckResult
fi
printf "\n" | $saveCheckResult

echo "[16.2] Checking for suspicious software installed via rpm:" | $saveCheckResult
# Extract a tool name from the file and match it
hacker_tools_list=$(cat ./checkrules/hackertoolslist.txt)
for hacker_tools in $hacker_tools_list;do
	danger_soft=$(rpm -qa | awk -F- '{print $1}' | sort | uniq | grep -E "$hacker_tools")
	if [ -n "$danger_soft" ];then
		(echo "[!] Suspicious software installed detected:" && echo "$danger_soft") |  $saveDangerResult | $saveCheckResult
	else
		echo "[+] No suspicious software installed" | $saveCheckResult
	fi
done
printf "\n" | $saveCheckResult


echo "==========17. Environment Variables==========" | $saveCheckResult
echo "[17.1] Checking environment variables [env]:" | $saveCheckResult
env=$(env)
if [ -n "$env" ];then
	(echo "[+] Environment variables:" && echo "$env") | $saveCheckResult
else
	echo "[+] No environment variables found" | $saveCheckResult
fi
printf "\n" | $saveCheckResult

echo "==========18. Performance Analysis==========" | $saveCheckResult
echo "[18.1] Checking disk usage:" | $saveCheckResult
echo "[18.1.1] Checking disk usage:" | $saveCheckResult
echo "[+] Disk usage is as follows:" && df -h  | $saveCheckResult
printf "\n" | $saveCheckResult


echo "[18.1.2] Checking if disk usage is too high [df -h]:" | $saveCheckResult
echo "[Note] Usage over 70% triggers an alert" | $saveCheckResult
df=$(df -h | awk 'NR!=1{print $1,$5}' | awk -F% '{print $1}' | awk '{if ($2>70) print $1,$2}')
if [ -n "$df" ];then
	(echo "[!] Disk space usage is too high, please pay attention!" && echo "$df" ) |  $saveDangerResult | $saveCheckResult
else
	echo "[+] Sufficient disk space" | $saveCheckResult
fi
printf "\n" | $saveCheckResult

echo "[18.2] Checking CPU usage [cat /proc/cpuinfo]:" | $saveCheckResult
echo "[18.2.1] Checking CPU-related information:" | $saveCheckResult
(echo "CPU hardware information is as follows:" && cat /proc/cpuinfo ) | $saveCheckResult
(echo "CPU usage is as follows:" && ps -aux | sort -nr -k 3 | awk  '{print $1,$2,$3,$NF}') | $saveCheckResult
printf "\n" | $saveCheckResult

echo "[18.2.2] Checking the top 5 processes consuming CPU resources [ps -aux | sort -nr -k 3 | head -5]:" | $saveCheckResult
(echo "Top 5 processes consuming CPU resources [ps -aux | sort -nr -k 3 | head -5]:" && ps -aux | sort -nr -k 3 | head -5)  | $saveCheckResult
printf "\n" | $saveCheckResult

echo "[18.2.3] Checking processes consuming a large amount of CPU [ps -aux | sort -nr -k 3 | head -5 | awk '{if($3>=20) print $0}']:" | $saveCheckResult
pscpu=$(ps -aux | sort -nr -k 3 | head -5 | awk '{if($3>=20) print $0}')
if [ -n "$pscpu" ];then
	echo "[!] The following processes consume more than 20% of CPU:" && echo "UID         PID   PPID  C STIME TTY          TIME CMD" 
	echo "$pscpu" | tee -a 20.2.3_pscpu.txt | $saveDangerResult | $saveCheckResult
else
	echo "[+] No processes found consuming more than 20% of resources" | $saveCheckResult
fi
printf "\n" | $saveCheckResult

echo "[18.3] Analyzing memory usage:" | $saveCheckResult
echo "[18.3.1] Checking memory-related information:" | $saveCheckResult
(echo "[+] Memory information is as follows [cat /proc/meminfo]:" && cat /proc/meminfo) | $saveCheckResult
(echo "[+] Memory usage is as follows [free -m]:" && free -m) | $saveCheckResult
printf "\n" | $saveCheckResult

echo "[18.3.2] Checking the top 5 processes consuming memory resources:" | $saveCheckResult
(echo "[+] Top 5 processes consuming memory resources [ps -aux | sort -nr -k 4 | head -5]:" && ps -aux | sort -nr -k 4 | head -5) | $saveCheckResult
printf "\n" | $saveCheckResult

echo "[18.3.3] Checking processes consuming a significant amount of memory:" | $saveCheckResult
psmem=$(ps -aux | sort -nr -k 4 | awk '{if($4>=20) print $0}' | head -5)
if [ -n "$psmem" ];then
	echo "[!] The following processes consume more than 20% of memory:" && echo "UID         PID   PPID  C STIME TTY          TIME CMD"
	echo "$psmem" |  $saveDangerResult | $saveCheckResult
else
	echo "[+] No processes found consuming more than 20% of memory resources" | $saveCheckResult
fi
printf "\n" | $saveCheckResult

echo "[18.4] System runtime and load status:" | $saveCheckResult
echo "[18.4.1] Checking system uptime and load status:." | $saveCheckResult
(echo "[+] System uptime is as follows [uptime]:" && uptime) | $saveCheckResult
printf "\n" | $saveCheckResult


echo "==========19. Consolidating logs into a single package==========" | $saveCheckResult
echo "[19.1] Packing raw system logs [/var/log]:" | $saveCheckResult
tar -czvf ${log_file}/system_log.tar.gz /var/log/ -P
if [ $? -eq 0 ];then
	echo "[+] Log packing successful" | $saveCheckResult
else
	echo "[!] Log packing failed, please manually export the logs" |  $saveDangerResult | $saveCheckResult
fi
printf "\n" | $saveCheckResult


echo "[19.2] Packing script check logs to the /output/ directory:" | $saveCheckResult
# zip -r /tmp/linuxcheck_${ipadd}_${date}.zip /tmp/linuxcheck_${ipadd}_${date}/*
tar -zcvf ${current_dir}/output/linuxcheck_${ipadd}_${date}.tar.gz  ${current_dir}/output/linuxcheck_${ipadd}_${date}/* -P
if [ $? -eq 0 ];then
	echo "[+] Check file packing successful" | $saveCheckResult
else
	echo "[!] Check file packing failed, please manually export the logs" |  $saveDangerResult | $saveCheckResult
fi


echo "Check completed!" | $saveCheckResult
echo "Version:4.3" | $saveCheckResult
echo "Author:sun977" | $saveCheckResult
echo "Mail:jiuwei977@foxmail.com" |	$saveCheckResult
echo "Date:2024.08.07" | $saveCheckResult
