---
maintainer: alexsedova
---

# How to build Android aosp in Docker container
 this image was create for android 7.1.1 codebase.
## Known problems

#### Parallel jobs execution on Ububtu 14.04

For reasons we are still investigating, 'make' build in docker container can not support more then 3 parallel jobs. It leads to defunct java processes those can not be killed any other way then reboot the host. There are a few reference on the problems with java in docker could be connected with this particular problem. This problem obversved only on Ubuntu 14.04, 16.04 worked just fine. It is working fine for RedHat RHEL 7.2 also.


## How to run this image
 sudo ./create_docker_user_account.sh -n test -i 1009 -w 123@123 -d /home2/docker_workspace/test0427 -p 10427 -h 192.168.67.123
 then you can use ssh to access this docker container as usual.
 such as :
    sh test@192.168.67.123 -p 10427 
