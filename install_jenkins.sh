
:'Checking if user is running command as in superuser mode i.e. sudo
EUID is the effective user id root is 0 we are checking to see if we are root or no
The difference between UID and EUID is that UID almost never changes but EUID is the id
when executing a certain process and we end the if statement with fi'

if [[ $EUID -ne 0 ]];
then
	echo "This script must be run as root" 
	exit 1
else
	echo "Running as root condition passed"
	
fi

:'
We use here yum as a package management utility for linux operating systems
'
yum update
yum install docker

#installing git can be helpful for when using version control this is optional
yum install git

service docker start

#Appending docker to user group ec2-user
usermod -aG docker ec2-user

#Creating this directory for jenkins requirement this will be attached using volumes in docker
mkdir -p /var/jenkins_home
#Changing ownership of this folder to 1000 which is jenkins
chown -R 1000:1000 /var/jenkins_home/
docker run -p 8080:8080 -p 50000:50000 -v /var/jenkins_home:/var/jenkins_home -d --name jenkins jenkins/jenkins:lts
echo 'Jenkins installed'
echo 'You should now be able to access jenkins at: http://'$(curl -s ifconfig.co)':8080'
