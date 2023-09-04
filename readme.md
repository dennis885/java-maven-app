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