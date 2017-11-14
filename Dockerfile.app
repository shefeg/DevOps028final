FROM maven:3.5-jdk-8-onbuild

RUN mvn package

FROM openjdk:8

RUN mkdir -p /samsara/liquibase

WORKDIR /samsara

COPY run_app.sh .
COPY --from=0 /usr/src/app/target/Samsara-1.3.5.RELEASE.jar .
COPY liquibase ./liquibase

ENV DB_HOST=postgresdb
ENV DB_NAME=auradb
ENV DB_USER=aura
ENV DB_PASS=mysecretpassword

ENTRYPOINT ["bash", "/samsara/run_app.sh"]

EXPOSE 9000