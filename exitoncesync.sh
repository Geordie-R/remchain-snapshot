#!/bin/bash

function writePercentage() {


##
##  \r = carriage return
##  \c = suppress linefeed
##


diff=$(($2-$1))
sumit=$(awk "BEGIN {print ($diff/$2)*100}")
percentage=$(awk "BEGIN {print (100 - $sumit) }")
#roundme=$(echo $percentage | awk '{print int($1+0.5)}')
echo -en "\r$percentage% Chain Sync Completed\c\b"
}



synclog=/root/data/snapshots/sync.log
touch $synclog
echo -999999999999 > $synclog



their_head_block_num=$(remcli -u https://rem.eon.llc/ get info| jq '.head_block_num')
our_head_block_num=$(remcli get info | jq '.head_block_num')
sleep 1



echo "THEIRS: $their_head_block_num and OURS: $our_head_block_num"
# Now we wait for last irreversible block to pass our snapshot taken

if [[ $our_head_block_num -eq $their_head_block_num ]]; then
        echo 0 > $synclog
        echo "chain synced (a)"
else



        while [[ 1 -eq 1 ]]
                do


                        their_head_block_num=$(remcli -u https://rem.eon.llc/ get info| jq '.head_block_num')
                        our_head_block_num=$(remcli get info | jq '.head_block_num')

                        ans=$(($their_head_block_num-$our_head_block_num))
                        #echo "Blocks Left: $ans"
                        echo $ans > $synclog
                        if [[ $their_head_block_num -le $our_head_block_num ]] ; then

                                echo "SYNCED as ans is $ans (b)"
                                break
                        else
                                writePercentage $our_head_block_num $their_head_block_num


                        fi
sleep 2
                done

fi


echo "Issuing stop chain command..."
./stop.sh
