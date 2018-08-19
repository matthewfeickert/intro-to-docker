FROM python:3.6.6

MAINTAINER Matthew Feickert <matthewfeickert@users.noreply.github.com>

ENV HOME /root
WORKDIR /root

ENV DEBIAN_FRONTEND noninteractive

# Install general dependencies
RUN apt -qq -y update
RUN apt -qq -y upgrade
RUN apt -qq -y install curl wget vim emacs

RUN pip install --upgrade pip
RUN pip install --upgrade -q jupyter
RUN pip install --upgrade -q pipenv

RUN rm -rf /root/*

WORKDIR /root
VOLUME ["/root"]
