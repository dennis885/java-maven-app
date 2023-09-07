# Full CI/CD Pipline of a Java Maven App
- The following project is built upon a cloned Git repository from a DevOps course I've been working on my free time.
- The purpose of the project is to show the workflow process on how to build a full CI/CI Pipeline of an application from scratch
## java-maven-app

Make sure to follow the steps below in order to run the app:

- Build the jar file with the command ```mvn install```
- Create a new droplet on Digital Ocean and install java on it with the commands further down below.
  - Enable port 22 and 8080 in the firewall settings of Digital Ocean.
  - Connect to the droplet with the ssh command and install java
    - ```sudo apt update```
    - ```sudo apt upgrade -y```
    - ```sudo apt install openjdk-8-jre-headless htop nodejs docker net-tools -y```
  - Create a new user and add to sudo group
    - ```adduser dennis```
    - ```usermod -aG sudo dennis```
- Add your ssh keys for login.
- Upload and run the jar file with the following commands
  - ```scp target/java-maven-app-1.1.0-SNAPSHOT.jar dennis@{SERVER}:/root```
  - ```java -jar java-maven-app-1.1.0-SNAPSHOT.jar```
- Verify the app was running I used curl to check the app
  - ```netstat -lpnt```
- Check the 8080 port of the application ip to see if the app is running.

### Install Jenkins on Digital Ocean
- Create another droplet with at least 4GB RAM in order to make sure the app runs without issues, as well as for the long-term CI/CD setup
- Enable port 22 and 8080 in the firewall settings of Digital Ocean.
- Install Jenkins as a Docker container then run it, by running the following commands
  - ```apt update```
    ```apt install docker.io```
    ```docker run -p 8080:8080 -p 50000:50000 -d -v jenkins_home:/var/jenkins_home jenkins/jenkins:lts```
    ```docker ps```
- Access Jenkins in your web browser by copying the IP address of your server, add port 8080 and paste in your web browser.
- Initialize Jenkins by running
  - ```docker exec -it [your container name] bash```
- Then get access to your password with command
  - ```cat /var/jenkins_home/secrets/initialAdminPassword```
- After all plugins are downloaded and initialized, create your first admin user

### Create a CI Pipeline with Jenkinsfile (Freestyle, Pipeline, Multibranch
- With Jenkins, the goal is to automate your apps workflow. In this case by creating a job on Jenkins that runs tests on the Java app and builds a Jar file by running the following Maven commands:
  - ```mvn test```
    ```mvn package```
- Follow the procedure below in order to make Maven available on Jenkins:
- Select Create a new job > enter an item name > Choose Freestyle Project
- Scroll down to Build Steps > Select Invoke top-level Maven targets > Choose your Maven Version input in Goals —version
- In your job, select Build Now in order to build the project.

#### Configure Git Repository
- Go back to Configure > Source Code Management > Select Git and enter this project repository link > Add credential with username, password and ID
- Under Branches to build, select */jenkins-jobs in Branch Specifier > Build Steps, in Execute Shell run the following:
  - ```chmod +x freestyle-build.sh```
    ```./freestyle-build.sh```

#### Make Docker available in Jenkins
- When installation is complete, set the correct permissions on the docker.sock file, so that we can run commands from inside the container using the Jenkins user
  - ```chmod 666 /var/run/docker.sock```
- Login as a Jenkins user and pull the image
  - ```docker pull redis```

#### Build Docker Image & Push Image to Docker Hub
- Add a docker command in your job configuration. Save and build.
- Create a repository on Docker Hub.
- Go to Manage Jenkins and add your Docker Hub username and password under Global credentials
- Update the execute shell in Jenkins with your name that you need to use when creating your image, then use docker push command
  - ```docker build -t nanatwn/demo-app:jma-1.0```
  - ```echo $PASSWORD | docker login -u $USERNAME --password-stdin```
  - ```docker push nanatwn/demo-app:jma-1.0```
- Go to Build Environment > Select Use secret text(s) or file(s), define username and password variables and your Docker Hub credentials. Build and run.

#### Push Docker Image to Nexus Repository
- Due to Nexus running on a http port, make sure to configure this insecure registry setting for Jenkins as well!
- In your droplet server, do the following configuration with the contents below:
  - ```vim /etc/docker/daemon.json```
  - ```{```
  - ```"isecure-registries":["your.IP.Address:8083"]```
  - ```}```
- Restart Docker to make sure the changes are applied.
  - ```systemctl restart docker```
  - ```docker ps -a```
  - ```docker start your container ID```
  - ```docker exec -u 0 -it your container ID bash```
  - ```chmod 666 /var/run/docker.sock```
  - ```ls -l /var/run/docker.sock```
- Now Docker is reconfigured to allow accessing Nexus, explicitly allowing our Docker repository on Nexus as an insecure registry
- Go back to Jenkins and reconfigure the build to push our Docker repository to Nexus instead of Docker Hub
- Manage Jenkins > Credentials > Create new credentials for Nexus Docker Repository
- Update the Execute Shell commands with your  Nexus Docker Repository IP address. Build and run.
  - ```docker build -t your.IP.Adress/java-maven-app:1.1```
  - ```echo $PASSWORD | docker login -u $USERNAME --password-stdin your.IP.Adress:8083```
  - ```docker push your.IP.Adress/java-maven-app:1.1```
- This is the last instance Nexus repository will be used, as Docker Hub or AWS ECR will be used from this point. You may delete your Digital Ocean droplet server.

#### Create a complete Pipeline
- Use the Jenkinsfile template given in the project
- Add the necessary credentials under build image stage and implement the docker build, docker login and docker push commands.

### Webhooks - Trigger Pipeline Jobs Automatically
- Install the GitLab plugin to Jenkins
- Add a personal access token on GitLab
- Configure in Manage Jenkins > System GitLab credentials, so the GitLab project is connected to Jenkins
- Configure the build triggers so that Push Events and opened merge request events are enabled on Jenkins, when a change is pushed to GitLab

### Dynamically Increment App Version in Jenkins Pipeline
- In the Jenkinsfile, add the necessary credentials for the stage("increment version") function, so that instead of having to update the version manually in the pom.xml file, the build automation tool is configured to increment the version automatically.
- In the Dockerfile, make sure that the file is dynamic and does not contain hard coded values. Otherwise, the app version won’t be dynamically incremented.
- Make sure to clean the target folder with the old jar-file, by utilizing the mvn clean package command. Otherwise Java will not know which Jar file it needs to execute.

## AWS

### Deploy Web Application on EC2 Instance (manually)
- On the IAM dashboard, make sure to create an admin user with less privileges than the root user
- Select Attach existing policies directly > Select AdministratorAccess > Create user > Save the user information and secure the keys safely (IMPORTANT!!!)
- In order to deploy web application on EC2 instance, the following objectives must be fulfilled:
  - Create an EC2 instance on AWS
  - Connect to EC2 instance with ssh
  - Install Docker on remote EC2 instance
  - Run Docker Container (docker login, pull, run) from private Repo
  - Configure EC2 Firewall to access App externally from browser
- Go to the Launch an instance view. Select Linux OS and the t2.micro instance. Create and safely secure an ssh-key pair (if you’re on Windows, choose .ppk. Otherwise choose .pem.
- Choose the default VPC, default subnet and enable auto-assign public IP in order to ssh into our instance later on.
- Create a new security group and configure ssh access into port 22 and add your IP as source type. Edit inbound rules for access to port 3000. Use the default storage and launch your instance.Make sure to change permission of the ssh-key to read only for your user
- ssh into your instance as a user (not as a root), then install and start Docker on the server. Confirm docker is running and configure so your user can run docker commands, without having to use the sudo command
  - ```sudo yum update```
  - ```sudo yum install docker```
  - ```sudo service docker start```
  - ```ps aux | grep docker```
  - ```sudo usermod -aG docker $USER```
- Login to your private docker hub and run the image from your docker repo.
  - ```docker login```
  - ```ls .docker/config.json```
  - ```docker pull dennis141/demo-app:1.0```
  - ```docker run -d -p 3000:3080 dennis141/demo-app:1.0```


### CD - Deploy Application from Jenkins Pipeline to EC2 Instance (automatically with docker)
- The next steps are to connect to EC2 server instance from Jenkins servier via ssh. Then execute docker run on EC2 instance.
- Go to Jenkins > Plugin Manager > install SSH Agent plugin
- Create the credentials for EC2 by going to Credentials > Java-maven-app > Global credentials. Select SSH Username with private key, fill in ID, username and enter your .pem or .ppk-key content.
- Go to Pipeline Syntax > select SSH Agent > Generate Pipeline Script. Implement the necessary logic and execute docker run command on EC2
- Configure the firewall on EC2 so that Jenkins can access the server, by adding the IP address of Jenkins as a source

### CD - Deploy Application from Jenkins Pipeline on EC2 Instance (automatically with docker-compose)
- The following objectives is to install docker-compose on EC2 instance, create docker-compose.yaml file and adjust Jenkinsfile to execute docker-compose command on EC2 instance
- In order to install docker compose, follow the official instructions on the docker documentation:
  - ```sudo curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose```
  - ```sudo chmod +x /usr/local/bin/docker-compose```
- Create a docker-compose.yaml file that contains our Java Maven Docker image and third-party Postgres Docker Image
- Create the docker-compose.yaml file on EC2 instance
- In order to execute multiple commands when connecting to the EC2 server, add a shell-script file server.sh
- Expand on the Jenkinsfile and continue to optimize the code by updating the docker-compose, Jenkins and server files