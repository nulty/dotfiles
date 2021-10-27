FROM ubuntu:20.04

RUN apt-get update && apt-get install sudo
RUN useradd -p password -ms /bin/bash dotty
RUN chown -R dotty:dotty /home/dotty/
RUN echo 'dotty  ALL=NOPASSWD: ALL' >>  /etc/sudoers

USER dotty
WORKDIR /home/dotty

RUN mkdir contents
COPY --chown=dotty:dotty . dotfiles/
RUN sudo apt-get install -y tz-data
RUN sudo apt-get install -y software-properties-common less
