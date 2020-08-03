# Restoring a snapshot

Prior to restoring from snapshot, make sure that `remnode` has been stopped and the `/data` directory is empty.

A `bad_database_version_exception` error after snapshot recovery is a sign that `/data/blocks` or another subfolder was not removed prior to start.

## restoresnapshot.sh - Without autorun

Demo of the beta sent to beta tester friends - https://youtu.be/wjrETCqnztQ

This will download the restoresnapshot.sh to your snapshot folder WITHOUT running restoresnapshot.sh.  For automatically running the script immediately after download, see the next section below called with autorun.

```
mkdir -p /root/data/snapshots/
cd /root/data/snapshots/
sudo rm -rf restoresnapshot.sh
sudo rm -rf exitoncesync.sh 
sudo wget https://raw.githubusercontent.com/Geordie-R/remchain-snapshot/master/restoresnapshot.sh && sudo chmod +x restoresnapshot.sh
sudo wget https://raw.githubusercontent.com/Geordie-R/remchain-snapshot/master/exitoncesync.sh && sudo chmod +x exitoncesync.sh
```
## restoresnapshot.sh - With autorun
The code below is identical to the code above but it actually runs it immediately afterwards.

```
mkdir -p /root/data/snapshots/
cd /root/data/snapshots/
sudo rm -rf restoresnapshot.sh
sudo rm -rf exitoncesync.sh
sudo wget https://raw.githubusercontent.com/Geordie-R/remchain-snapshot/master/restoresnapshot.sh && sudo chmod +x restoresnapshot.sh
sudo wget https://raw.githubusercontent.com/Geordie-R/remchain-snapshot/master/exitoncesync.sh && sudo chmod +x exitoncesync.sh
./restoresnapshot.sh

```
