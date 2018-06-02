FROM ubuntu:trusty
MAINTAINER Eric Wang<eric.z.wang@ericsson.com>

# Prevent dpkg errors
ENV TERM=xterm-256color

#ENV http_proxy=http://10.175.250.81:8080
#ENV https_proxy=http://10.175.250.81:8080
#ENV ftp_proxy=http://10.175.250.81:8080
#ENV proxy=http://10.175.250.81:8080
#ENV RSYNC_PROXY=10.175.250.81:8080
#ENV no_proxy=ericsson.se,127.0.0.1,10.175.172.111,10.175.172.67,10.175.172.68,10.175.172.108,yum.linux.ericsson.se

# Set mirrors to NZ
RUN sed -i "s/http:\/\/archive./http:\/\/nz.archive./g" /etc/apt/sources.list
#RUN  sed  -i  "s/\w+\.archive\.ubuntu\.com/archive.ubuntu.com/g"  /etc/apt/sources.list


# Install Ansible
RUN apt-get update -qy && \
    apt-get install -qy software-properties-common && \
#    apt-get install --reinstall ca-certificates && \
#    apt-add-repository -y ppa:ansible/ansible && \
    apt-get update -qy && \
    apt-get install -qy ansible

# Copy baked in playbooks
COPY ansible /ansible

# Add volume for Ansible playbooks
VOLUME /ansible
WORKDIR /ansible

#COPY site.yml /ansible/


# change hostfile
RUN sed -i '1i\localhost' /etc/ansible/hosts

# Entrypoint
ENTRYPOINT ["ansible-playbook"]
CMD ["site.yml"]


