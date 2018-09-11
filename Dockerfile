FROM python:3.6.6

MAINTAINER Matthew Feickert <matthewfeickert@users.noreply.github.com>

ENV HOME /root
WORKDIR /root

ENV DEBIAN_FRONTEND noninteractive

# Install general dependencies
RUN apt-get -qq -y update && \
    apt-get -qq -y install apt-utils && \
    apt-get -qq -y update && \
    apt-get -qq -y upgrade && \
    apt-get -qq -y install \
     curl \
     wget \
     vim \
     emacs

RUN pip install --upgrade pip setuptools wheel && \
    pip install --upgrade -q \
     jupyter \
     pipenv

RUN rm -rf /root/*

WORKDIR /root
VOLUME ["/root"]
