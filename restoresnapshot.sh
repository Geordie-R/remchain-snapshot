##############################################################################################
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

lastdownloadfolder=./data/snapshots/lastdownload/
mkdir -p $lastdownloadfolder
cd /root/data/snapshots
mkdir -p lastdownload
cd lastdownload

latestsnapshot=$(curl -s https://geordier.co.uk/snapshots/latestsnapshot.php)
wget -c https://www.geordier.co.uk/snapshots/$latestsnapshot -O - | sudo tar -xz --strip=4
killall -q remnode
sleep 2
binfile=$lastdownloadfolder*.bin
cd ../../
rm -rf ./blocks*/
rm -rf ./state
cd ~
remnode --config-dir ./config/ --snapshot $(ls -t $binfile | head -n1) --data-dir ./data/ >> remnode.log 2>&1 &
tail -f remnode.log
