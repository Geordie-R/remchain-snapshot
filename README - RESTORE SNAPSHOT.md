# REMChain Snapshots

#IMPORTANT PLEASE READ


# Restoring a snapshot
## restoresnapshot.sh - Without autorun

This will download the restoresnapshot.sh to your snapshot folder WITHOUT running restoresnapshot.sh.  For automatically running the script immediately after download, see the next section below called with autorun.

```
mkdir -p /root/data/snapshots/
cd /root/data/snapshots/
sudo rm -rf restoresnapshot.sh
sudo wget https://raw.githubusercontent.com/Geordie-R/remchain-snapshot/Geordie-R-v2/restoresnapshot.sh && sudo chmod +x restoresnapshot.sh
sudo wget https://raw.githubusercontent.com/Geordie-R/remchain-snapshot/Geordie-R-v2/exitoncesync.sh && sudo chmod +x exitoncesync.sh
```
## restoresnapshot.sh - With autorun
The code below is identical to the code above but it actually runs it immediately afterwards.

```
mkdir -p /root/data/snapshots/
cd /root/data/snapshots/
sudo rm -rf restoresnapshot.sh
sudo wget https://raw.githubusercontent.com/Geordie-R/remchain-snapshot/Geordie-R-v2/restoresnapshot.sh && sudo chmod +x restoresnapshot.sh
sudo wget https://raw.githubusercontent.com/Geordie-R/remchain-snapshot/Geordie-R-v2/exitoncesync.sh && sudo chmod +x exitoncesync.sh
./restoresnapshot.sh
```
