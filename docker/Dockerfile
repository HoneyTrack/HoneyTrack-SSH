# HoneyTrack Linux Image
FROM ubuntu:20.04

LABEL maintainer="@aatharvauti @HoneyTrack"

# Set environment variables to prevent interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Set DNS environment variable
ARG DNS_SERVER=8.8.8.8
ENV DNS_SERVER=$DNS_SERVER

# Adding sources.list, updating and upgrading
# Update and upgrade packages, install tzdata
RUN sed -i 's/^# deb-src/deb-src/' /etc/apt/sources.list && \
    sed -i 's/^# deb/deb/' /etc/apt/sources.list && \
    cat /etc/apt/sources.list && \
    apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends tzdata

# Installing  packages required
RUN apt-get build-dep -y openssh-server
RUN apt-get install --no-install-recommends -y net-tools build-essential python3 python3-pip fakeroot devscripts locales git wget rsyslog sudo cron nano putty-tools python3-twisted curl geoip-bin

# Makes a Directory in /opt and gets the source code for openssh-server
RUN mkdir /opt/tmp && cd /opt/tmp

# COPY chsrc.sh from current directory (Local) to Docker
COPY ./docker/chsrc.sh /opt/tmp/

# Changes the source code to log passwords in auth.log
RUN chmod +x /opt/tmp/chsrc.sh && bash /opt/tmp/chsrc.sh

# CLEAN
RUN cd / && rm -rf /opt/tmp

# Changing Root Login Permit to 'yes'
RUN service ssh start
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

# Python Modules
RUN pip install python-dotenv

# SETUP Logging Scripts
RUN mkdir /var/log/dnsrout
COPY ./scripts/alerts/ /var/log/dnsrout
COPY ./scripts/logs/ /var/log/dnsrout
COPY ./scripts/elk/ /var/log/dnsrout

# Use only if you have setup an Elastic Server and you need live logs
# It will directly transfer the logs to the server and constantly update on the dashboard
# No Key Auth enables logging in without requiring Passwords and logs can be sent using RSA keys

# SSH No-Auth Keyed Setup
RUN mkdir /root/.ssh

# Makes everything executable
RUN chmod +x ./var/log/dnsrout/*.sh

# COPY start.sh
COPY ./docker/start.sh /root
COPY ./docker/passwd.sh /root
RUN chmod +x /root/*.sh

# EXPOSE 22 SSH
EXPOSE 22

CMD ["/sbin/sshd", "-D", "-e"]

WORKDIR /root
USER root

ENTRYPOINT /bin/bash
