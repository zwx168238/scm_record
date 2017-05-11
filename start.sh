#!/bin/bash
# ADD new user
# explicitly set user/group IDs
USER_NAME=${USER_NAME:-test}
GROUP_NAME=${GROUP_NAME:-test}
GROUP_GID=${USER_GID:-1000}
USER_UID=${USER_UID:-1000}
USER_PWD=${USER_PWD:-123456}

groupadd -r ${USER_NAME} --gid=${GROUP_GID} && useradd -r -g ${GROUP_NAME} --uid=${USER_UID} -m -s /bin/bash -d /home/test ${USER_NAME}
chown -R ${USER_NAME}:${GROUP_NAME} /home/test
echo "${USER_NAME}:${USER_PWD}" | chpasswd

/usr/sbin/sshd -D
