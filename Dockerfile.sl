FROM jenkins/jnlp-slave

USER 0

RUN apt-get update && \
    apt-get install sudo

CMD DOCKER_GID=$(stat -c '%g' /var/run/docker.sock) && \
    groupadd -for -g ${DOCKER_GID} docker && \
    usermod -aG docker jenkins && \
    sudo -E -H -u jenkins bash -c /usr/local/bin/jenkins.sh