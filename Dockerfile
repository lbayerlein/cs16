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
    yum install glibc.i686 libstdc++ libstdc++.i686 wget libcurl.x86_64 -y

RUN useradd -m -d /opt/css csserver 

USER csserver

RUN cd /opt/css && \
    wget http://media.steampowered.com/installer/steamcmd_linux.tar.gz && \
    tar -xvzf steamcmd_linux.tar.gz

RUN mkdir /opt/css/csserver

RUN /opt/css/steamcmd.sh +login anonymous \
                          +force_install_dir /opt/css/csserver \
                          +app_set_config 90 mod cstrike \
                          +app_update 90 validate \
                          +quit && \
			  /opt/css/steamcmd.sh +login anonymous \
                          +force_install_dir /opt/css/csserver \
                          +app_set_config 90 mod cstrike \
                          +app_update 90 validate \
                          +quit

RUN mkdir -p /opt/css/.steam && ln -s /opt/css/linux32 /opt/css/.steam/sdk32
             

#TODO server configs esl
 

# Start the server
WORKDIR /opt/css/csserver
ENTRYPOINT ./hlds_run -game cstrike -strictportbind -ip 0.0.0.0 -port $PORT +clientport $CLIENTPORT  +map $DEFAULTMAP -maxplayers $MAXPLAYERS
#ENTRYPOINT ["./hlds_run"]
#CMD ["+sv_lan 1", "+map de_dust"] 
