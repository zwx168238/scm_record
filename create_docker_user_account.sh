#!/bin/bash -e

usage() {
  echo $"Usage: $0 -u username -i user_id -w passwd -d mount_workspace -p port -h dock_host_ip";
  exit 0
}

if [ "$#" -lt 6 ]; then
  usage
fi

while getopts "u:i:w:d:p:h:" arg
do
  case $arg in
    u)
      USER_NAME=$OPTARG
      GROUP_NAME=$OPTARG
      ;;
    i)
      USER_UID=$OPTARG
      GROUP_GID=$OPTARG
      ;;
    w)
      USER_PWD=$OPTARG
      ;;
    d)
      USER_DIR=$OPTARG
      ;;
    p)
      USER_PORT=$OPTARG
      ;;
    h)
      DOCKER_HOST=$OPTARG
    *)
      echo "-u username -i user_id -w passwd -d mount_workspace -p port -h dock_host_ip"
      echo "%prg -u ts -i 1000 -w 123456 -d /home/test -p 10086 -h 192.168.65.151"
      exit 0
      ;;
  esac
done


docker run -d -p ${USER_PORT}:22 \
       --memory="16g" --cpus="8" \
       --name ${USER_NAME}-hp-docker \
       -e USER_NAME=${USER_NAME} \
       -e GROUP_NAME=${GROUP_NAME} \
	   -e GROUP_GID=${GROUP_GID} \
	   -e USER_UID=${USER_UID} \
	   -e USER_PWD=${USER_PWD} \
       -v ${USER_DIR}:/home/ts \
       192.168.67.156:6000/ubuntu-16.04-aosp-n:v1

echo "Please login by this command:"
echo "ssh ${USER_NAME}@${DOCKER_HOST} -p ${USER_PORT}"
