FROM ubuntu:20.04

RUN apt-get update && apt-get install -y sudo software-properties-common less
RUN useradd -p password -ms /bin/bash dotty
RUN useradd -p password -ms /bin/bash other
RUN chown -R dotty:dotty /home/dotty/
RUN groupadd devs && addgroup dotty devs && addgroup other devs
RUN echo 'dotty  ALL=NOPASSWD: ALL' >>  /etc/sudoers
RUN echo 'other  ALL=NOPASSWD: ALL' >>  /etc/sudoers

USER dotty
WORKDIR /home/dotty

COPY --chown=dotty:dotty . contents/
RUN chmod u+x contents/setup.sh
#--no-install-recommends
