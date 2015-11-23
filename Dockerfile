# CS 1.6 Server
#
# Version 0.1

FROM centos
MAINTAINER Ludwig Bayerlein
 
ENV DEFAULTMAP de_dust2
ENV MAXPLAYERS 16
ENV PORT 27015
ENV CLIENTPORT 27005
ENV SERVERNAME servername
ENV RCONPASS rconpass
 
EXPOSE $PORT/udp
EXPOSE $CLIENTPORT/udp
EXPOSE $PORT
EXPOSE $CLIENTPORT
EXPOSE 1200/udp

LABEL DESCRIPTION="This images creates a Counter Strike 1.6 Server"
 
RUN yum update -y && \
    yum install glibc.i686 libstdc++ libstdc++.i686 wget -y

RUN mkdir /opt/css && \
    cd /opt/css && \
    wget http://media.steampowered.com/installer/steamcmd_linux.tar.gz && \
    tar -xvzf steamcmd_linux.tar.gz

RUN /opt/csgo/steamcmd.sh +login anonymous \
                          +force_install_dir /opt/csgo/csgoserver \
                          +app_update 90 validate \
                          +quit

#TODO server configs esl
 
# script refuses to run in root, create user
RUN useradd -m csserver

RUN adduser csserver 

USER csserver

WORKDIR /home/csserver
 
 
# Start the server
WORKDIR /home/csserver/serverfiles
#ENTRYPOINT ./hlds_run -game cstrike -strictportbind -ip 0.0.0.0 -port $PORT +clientport $CLIENTPORT  +map $DEFAULTMAP -maxplayers $MAXPLAYERS
ENTRYPOINT ["./hlds_run"]
