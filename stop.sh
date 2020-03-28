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
echo "REMChain stopped"
