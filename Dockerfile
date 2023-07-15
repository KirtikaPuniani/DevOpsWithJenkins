#This is a container made by user-defined docker image that contains 
#VS code, PuTTy, Git, sonarqube, and tomcat.

# Start with a base image
FROM ubuntu:20.04

# Install dependancies
RUN apt-get update && apt-get install -y \
        curl \
        wget \
        unzip

# Install PuTTY
RUN apt-get update && apt-get install -y putty

# Install Git
RUN apt-get update && apt-get install -y git

RUN apt-get update && apt-get install -y gnupg wget unzip openjdk-11-jdk
RUN wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-8.9.2.46101.zip && \
    unzip sonarqube-8.9.2.46101.zip && \
    mv sonarqube-8.9.2.46101 /opt/sonarqube
EXPOSE 9090


# Install Tomcat
RUN apt-get -y update
RUN apt-get -y install openjdk-8-jdk wget
RUN apt-get -y install curl
RUN mkdir /usr/local/tomcat
RUN wget https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.52/bin/apache-tomcat-9.0.52.tar.gz
RUN tar xvfz apache-tomcat-9.0.52.tar.gz
RUN mv apache-tomcat-9.0.52/* /usr/local/tomcat
EXPOSE 8080

#VSCODE
RUN apt-get update \
    && apt-get install -y curl \
    && curl -fsSL https://code-server.dev/install.sh | sh

EXPOSE 10000

# Set the command to run when the container starts
# CMD ["/usr/local/tomcat/bin/catalina.sh", "run"]
# CMD /opt/sonarqube/bin/linux-x86-64/sonar.sh start && code-server --bind-addr 0.0.0.0:10000 . && /usr/local/tomcat/bin/catalina.sh run
# CMD ["/bin/bash", "-c", "code-server --bind-addr 0.0.0.0:10000 . & /usr/local/tomcat/bin/catalina.sh run"]
# CMD ["/bin/bash", "-c", "/opt/sonarqube/bin/linux-x86-64/sonar.sh start && code-server --bind-addr 0.0.0.0:10000 . && /usr/local/tomcat/bin/catalina.sh run"]
# Copy shell script
COPY start_services.sh /start_services.sh

# Make shell script executable
RUN chmod +x /start_services.sh
# Run shell script as CMD
CMD ["/bin/bash", "-c", "/start_services.sh"]





## in different file
#!/bin/bash

/opt/sonarqube/bin/linux-x86-64/sonar.sh start &
code-server --bind-addr 0.0.0.0:10000 . &
/usr/local/tomcat/bin/catalina.sh run
