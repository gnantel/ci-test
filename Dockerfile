# Common Dockerfile for all Java NLU services and jobs
#
# Use the APPLICATION_NAME argument to specify name of the application/service/job.
# This will also be used as the directory where the application files will be stored in the image (under /usr/local).
#
# Note that currently, the application being run must be packaged in a single executable jar file, named app.jar.
# This is because, at least from the documentation, the Docker ENTRYPOINT command does not support variable substitution.
# This limitation will change in the future as are likely to move away from large executable jar file which don't lend
# themselves well to layering.

FROM ncr.nuance.com/docker.io/ubuntu:20.04
ARG APPLICATION_NAME

RUN apt update \
   && apt install -y wget libgomp1 \
   && rm -rf /var/lib/apt/lists/*

# # Install JDK 17
RUN wget -q https://download.java.net/java/GA/jdk17/0d483333a00540d886896bac774ff48b/35/GPL/openjdk-17_linux-x64_bin.tar.gz -O openjdk.tar.gz \
 && tar --extract --file openjdk.tar.gz --directory /usr/local --no-same-owner \
 && rm openjdk.tar.gz \
 && groupadd nuance -g 6826 \
 && useradd nuance -u 6826 -g 6826 -d / -s /sbin/nologin \
    -c "Created by Nuance Communications, Inc. to run Nuance processes"

USER nuance

COPY --chown=nuance:nuance . /usr/local/pets

ENV PET_HOME /usr/local/pets
ENV JAVA_HOME /usr/local/jdk-17
ENV PATH $JAVA_HOME/bin:$PATH
ENV LD_LIBRARY_PATH $JAVA_HOME/lib
ENV LANG C.UTF-8

WORKDIR $PET_HOME
ENTRYPOINT ["java", "-jar", "app.jar"]

LABEL name="$APPLICATION_NAME" vendor="Nuance Communications Inc."
