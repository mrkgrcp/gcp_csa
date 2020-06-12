# Dockerfile for testing the cloud security assessment too
ARG base_image="debian:buster"

FROM ${base_image}

RUN apt update && apt install -y openssh-server gnupg 
RUN test -e /usr/bin/python || (apt -y update && apt -y install python-minimal)
RUN test -e /usr/bin/python3 || (apt -y update && apt -y install python3-minimal)
RUN echo "deb http://ppa.launchpad.net/ansible/ansible/ubuntu trusty main" >> /etc/apt/sources.list.d/ansible.list && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 93C4A3FD7BB9C367 && apt -y update && apt -y install ansible

##################################################
# Expose SSH Service
# Just for testing

# Missing privilege separation directory: /var/run/sshd workaround
RUN mkdir /var/run/sshd

# TODO
# Use with docker secrets 
RUN echo 'root:T3mp0r4ry' | chpasswd

RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i 's/#PermitRootLogin yes/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

##################################################
# Copy the ansible dir and apply corresponding roles
ARG gcp_scout_workdir="/opt"
ENV GCP_SCOUT_WORKDIR=$gcp_scout_workdir
ADD ./ansible ${gcp_scout_workdir}/ansible
WORKDIR ${gcp_scout_workdir}

# Install latest ansible version
RUN ansible-playbook ./ansible/playbooks/hello_world.yml

##################################################
# Follow up

# Once ansible is installed, install the baseline and then run the asigned service

RUN ansible-playbook ./ansible/playbooks/gcp_scout.yml

##################################################
# Expose necessary ports

EXPOSE 22

##################################################
# TODO
# Check running and entrypoint (run vsftpd and ssh)

CMD ["/usr/sbin/sshd", "-D"]

