FROM jenkins/jnlp-slave

USER root

RUN apt-get -qq update \
    && apt-get -qq -y install \
    curl

RUN curl -sSL https://get.docker.com/ | sh