FROM jenkins/jenkins:2.73.1

USER root

RUN apt-get -qq update \
    && apt-get -qq -y install \
    curl

RUN curl -sSL https://get.docker.com/ | sh