#!/bin/bash
###############################################################################################
#                                                                                            #
# ███████████   ██████████ ██████   ██████   █████████  █████                 ███            #
#░░███░░░░░███ ░░███░░░░░█░░██████ ██████   ███░░░░░███░░███                 ░░░             #
# ░███    ░███  ░███  █ ░  ░███░█████░███  ███     ░░░  ░███████    ██████   ████  ████████  #
# ░██████████   ░██████    ░███░░███ ░███ ░███          ░███░░███  ░░░░░███ ░░███ ░░███░░███ #
# ░███░░░░░███  ░███░░█    ░███ ░░░  ░███ ░███          ░███ ░███   ███████  ░███  ░███ ░███ #
# ░███    ░███  ░███ ░   █ ░███      ░███ ░░███     ███ ░███ ░███  ███░░███  ░███  ░███ ░███ #
# █████   █████ ██████████ █████     █████ ░░█████████  ████ █████░░████████ █████ ████ █████#
#░░░░░   ░░░░░ ░░░░░░░░░░ ░░░░░     ░░░░░   ░░░░░░░░░  ░░░░ ░░░░░  ░░░░░░░░ ░░░░░ ░░░░ ░░░░░ #
#                                                                                            #
#                                                                                            #
#                                                                                            #
#  █████████                                         █████                █████              #
# ███░░░░░███                                       ░░███                ░░███               #
#░███    ░░░  ████████    ██████   ████████   █████  ░███████    ██████  ███████             #
#░░█████████ ░░███░░███  ░░░░░███ ░░███░░███ ███░░   ░███░░███  ███░░███░░░███░              #
# ░░░░░░░░███ ░███ ░███   ███████  ░███ ░███░░█████  ░███ ░███ ░███ ░███  ░███               #
# ███    ░███ ░███ ░███  ███░░███  ░███ ░███ ░░░░███ ░███ ░███ ░███ ░███  ░███ ███           #
#░░█████████  ████ █████░░████████ ░███████  ██████  ████ █████░░██████   ░░█████            #
# ░░░░░░░░░  ░░░░ ░░░░░  ░░░░░░░░  ░███░░░  ░░░░░░  ░░░░ ░░░░░  ░░░░░░     ░░░░░             #
#                                  ░███                                                      #
#                                  █████                                                     #
#                                 ░░░░░                                                      #
# ███████████                     █████                                                      #
#░░███░░░░░███                   ░░███                                                       #
# ░███    ░███   ██████   █████  ███████    ██████  ████████   ██████  ████████              #
# ░██████████   ███░░███ ███░░  ░░░███░    ███░░███░░███░░███ ███░░███░░███░░███             #
# ░███░░░░░███ ░███████ ░░█████   ░███    ░███ ░███ ░███ ░░░ ░███████  ░███ ░░░              #
# ░███    ░███ ░███░░░   ░░░░███  ░███ ███░███ ░███ ░███     ░███░░░   ░███                  #
# █████   █████░░██████  ██████   ░░█████ ░░██████  █████    ░░██████  █████                 #
#░░░░░   ░░░░░  ░░░░░░  ░░░░░░     ░░░░░   ░░░░░░  ░░░░░      ░░░░░░  ░░░░░                  #


#From the manual
#Get the following:

#A portable snapshot (data/snapshots/snapshot-xxxxxxx.bin)
#The contents of data/state-history
#Optional: a block log which includes the block the snapshot was taken at. Do not include data/blocks/reversible.
#Make sure data/state does not exist
#Start nodeos with the --snapshot option, and the options listed in the state_history_plugin.
#Do not stop nodeos until it has received at least 1 block from the network, or it won't be able to restart.

# path definitions
logfile=/root/remnode.log
configfolder=/root/config
datafolder=/root/data
blocksfolder=$datafolder/blocks
statefolder=$datafolder/state
statehistoryfolder=$datafolder/state-history
snapshotsfolder=$datafolder/snapshots
lastdownloadfolder=$snapshotsfolder/lastdownload

# create download folder in snapshots
mkdir -p $lastdownloadfolder
cd $lastdownloadfolder
echo "clearing lastdownload folder"
rm -f *.bin



#Choose what type of snapshot you require, which in turn goes to my website to retrieve the files that line up together.
PS3='Please enter the menu number below: '
options=("Snapshot Only" "Snapshot and Blocks Log" "Snapshot and Blocks Log and State History" "Quit")
snaptypephp=""
select opt in "${options[@]}"
do
    case $opt in
        "Snapshot Only")
        snaptypephp="snap"
            echo "you chose snapshot only"
        break
            ;;
        "Snapshot and Blocks Log")
            echo "you chose blocks log and snapshot"
        snaptypephp="blocks"
        break
            ;;
       "Snapshot and Blocks Log and State History")
            echo "you chose state history and blocks log and snapshot"
        snaptypephp="state-history"
break
            ;;
        "Quit")
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done

####Potential options end up as the following.  Run them manually if you're interested to see what it returns.

#https://www.geordier.co.uk/snapshots/latestSnapshotType.php?type=snap
#https://www.geordier.co.uk/snapshots/latestSnapshotType.php?type=blocks
#https://www.geordier.co.uk/snapshots/latestSnapshotType.php?type=state-history

# a typical response to running one of the URL above might look like this if you choose snap: NULL NULL 2020-04-12_21-01-snaponly.tar.gz

latestsnapshot=$(curl -s https://www.geordier.co.uk/snapshots/latestSnapshotType.php?type=$snaptypephp)
read -a arr <<< $latestsnapshot
state=${arr[0]};
blocks=${arr[1]};
snap=${arr[2]};


function downloadType (){
local result=0
  if [[ $1 == "NULL" ]]
  then
    result=0;
  else
    result=1;
  fi

echo $result
}

#Check  if we are running each option
stateresult=$(downloadType "$state")
blocksresult=$(downloadType "$blocks")
snapresult=$(downloadType "$snap")
echo "stateresult is $stateresult"
echo "blocksresult is $blocksresult"
echo "snapresult is $snapresult"

#Clear blocks folder
rm -rf $blocksfolder*/
#Clear state folder
rm -rf $statefolder*/
#Remove all bin files from snapshots folder
rm -rf $snapshotsfolder/*.bin


#Check if we are running the snapshot restore
if [[ $snapresult -eq 1 ]]
then

#Create snapshots folder inside the lastdownload folder
mkdir -p $lastdownloadfolder/snapshot
cd $lastdownloadfolder/snapshot


#Download snapshot
echo "Downloading snapshot now..."
  wget -Nc https://www.geordier.co.uk/snapshots/$snap -q --show-progress  -O - | sudo tar -Sxz --strip=4
  echo "Downloaded Snapshot $snap"
#Select the only bin file in the downloaded snapshot folder (due to previous clear)
binfile=$(ls *.bin | head -1)
#Copy snapshot from lastdownload folder to the actual snapshots folder
cp -a $lastdownloadfolder/snapshot/. $snapshotsfolder/

fi

#Check if we are doing a blockslog restore
if [[ $blocksresult -eq 1 ]]
then

mkdir -p $lastdownloadfolder/blocks
cd $lastdownloadfolder/blocks


echo "Downloading blocks log now from https://www.geordier.co.uk/snapshots/blocks/$blocks"

  wget  -Nc https://www.geordier.co.uk/snapshots/blocks/$blocks -q --show-progress -O - | sudo tar -Sxz --strip=3
  echo "Blocks log downloaded:  $blocks"
cp -a $lastdownloadfolder/blocks/. $blocksfolder/
fi


#Check if we are doing a state history restore.
#Note if you plan to restore state history you will need the required options and plugins in your config file.
#If this does not make sense to you, choose a blocks restore option 2 when you re-run this.
if [[ $stateresult -eq 1 ]]
then
echo "Downloading state history now from https://www.geordier.co.uk/snapshots/state-history/$state"

mkdir -p $lastdownloadfolder/state-history
cd $lastdownloadfolder/state-history

wget  -Nc https://www.geordier.co.uk/snapshots/state-history/$state -q --show-progress -O - | sudo tar -Sxz --strip=3
echo "State history downloaded:  $state"
cp -a $lastdownloadfolder/state-history/. $statehistoryfolder/
fi


echo "copied files from lastdownload folder"

rm -R $lastdownloadfolder/*

echo "BIN IS $binfile"

function stopNode() {
echo "stopping node..."
# gracefully stop remnode
remnode_pid=$(pgrep remnode)

if [ ! -z "$remnode_pid" ]; then
    if ps -p $remnode_pid > /dev/null; then
        kill -SIGINT $remnode_pid
    fi
    while ps -p $remnode_pid > /dev/null; do
        sleep 1
    done
fi
echo "Node stopped"
}


function startNode() {
    echo "Starting REMChain - CONFIG: $configfolder BINFILE: $snapshotsfolder/$binfile DATAFOLDER: $datafolder"
  remnode --config-dir $configfolder/ --disable-replay-opts --data-dir $datafolder/ >> $logfile 2>&1 &
}

function startNodeSnapshot() {
    echo "Starting REMChain - CONFIG: $configfolder BINFILE: $snapshotsfolder/$binfile DATAFOLDER: $datafolder"
 remnode --config-dir $configfolder/ --disable-replay-opts --snapshot $snapshotsfolder/$binfile --data-dir $datafolder/ >> $logfile 2>&1 &
}


function writePercentage() {


##
##  \r = carriage return
##  \c = suppress linefeed
##


diff=$(($2-$1))
sumit=$(awk "BEGIN {print ($diff/$2)*100}")
percentage=$(awk "BEGIN {print (100 - $sumit) }")
roundme=$(echo $percentage | awk '{print int($1+0.5)}')
echo -en "\r$roundme% Chain Sync Completed\c\b"
}


stopNode
sleep 1
cd ~
sleep 1
echo "starting now..."
startNodeSnapshot


sleep 5
echo "Delegating to exitoncesync.sh please wait..."
$snapshotsfolder/exitoncesync.sh &
sleep 3



#Bit lazy but its late and 1=1 works right :D
while [[ "1" == "1" ]]
do
val=$(<$snapshotsfolder/sync.log)

if [[ $val -le 0 ]]; then
echo "val is 0...breaking"
        break;
fi
        sleep 2
#echo "$val blocks to go to catch up and sync"
done

echo "Synced in main!!!"
#echo "final difference is blocks was $(<$snapshotsfolder/sync.log)"
rm $snapshotsfolder/sync.log
cd ~
echo "starting chain..."
startNode
#remnode --config-dir $configfolder/ --disable-replay-opts --data-dir $datafolder/ >> $logfile 2>&1 &
cat << "EOF"
.----------------.  .----------------.  .----------------.  .----------------.  .-----------------.
| .--------------. || .--------------. || .--------------. || .--------------. || .--------------. |
| |     ______   | || |  ____  ____  | || |      __      | || |     _____    | || | ____  _____  | |
| |   .' ___  |  | || | |_   ||   _| | || |     /  \     | || |    |_   _|   | || ||_   \|_   _| | |
| |  / .'   \_|  | || |   | |__| |   | || |    / /\ \    | || |      | |     | || |  |   \ | |   | |
| |  | |         | || |   |  __  |   | || |   / ____ \   | || |      | |     | || |  | |\ \| |   | |
| |  \ `.___.'\  | || |  _| |  | |_  | || | _/ /    \ \_ | || |     _| |_    | || | _| |_\   |_  | |
| |   `._____.'  | || | |____||____| | || ||____|  |____|| || |    |_____|   | || ||_____|\____| | |
| |              | || |              | || |              | || |              | || |              | |
| '--------------' || '--------------' || '--------------' || '--------------' || '--------------' |
 '----------------'  '----------------'  '----------------'  '----------------'  '----------------'
.----------------.  .----------------.  .-----------------. .----------------.
| .--------------. || .--------------. || .--------------. || .--------------. |
| |    _______   | || |  ____  ____  | || | ____  _____  | || |     ______   | |
| |   /  ___  |  | || | |_  _||_  _| | || ||_   \|_   _| | || |   .' ___  |  | |
| |  |  (__ \_|  | || |   \ \  / /   | || |  |   \ | |   | || |  / .'   \_|  | |
| |   '.___`-.   | || |    \ \/ /    | || |  | |\ \| |   | || |  | |         | |
| |  |`\____) |  | || |    _|  |_    | || | _| |_\   |_  | || |  \ `.___.'\  | |
| |  |_______.'  | || |   |______|   | || ||_____|\____| | || |   `._____.'  | |
| |              | || |              | || |              | || |              | |
| '--------------' || '--------------' || '--------------' || '--------------' |
 '----------------'  '----------------'  '----------------'  '----------------'

  ______   ______   .___  ___. .______    __       _______ .___________. _______
 /      | /  __  \  |   \/   | |   _  \  |  |     |   ____||           ||   ____|
|  ,----'|  |  |  | |  \  /  | |  |_)  | |  |     |  |__   `---|  |----`|  |__
|  |     |  |  |  | |  |\/|  | |   ___/  |  |     |   __|      |  |     |   __|
|  `----.|  `--'  | |  |  |  | |  |      |  `----.|  |____     |  |     |  |____
 \______| \______/  |__|  |__| | _|      |_______||_______|    |__|     |_______|
EOF

