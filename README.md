# Intro to Docker

An opinionated introduction to using [Docker](https://www.docker.com/) as a software development tool

> Disclaimer: This is a collection of examples of how you _can_ use Docker as a supporting tool for software development. I make no claim as to if this follows best practices of software engineering. Exploration of uses on your own should be considered mandatory follow-up to reading.

[![License](https://img.shields.io/badge/License-BSD%203--Clause-blue.svg)](https://opensource.org/licenses/BSD-3-Clause)

## Table of Contents<!-- TOC depthFrom:1 depthTo:6 withLinks:1 updateOnSave:0 orderedList:0 -->

- [Requirements](#requirements)
	- [Installation](#installation)
- [Documentation](#documentation)
- [Tutorial](#tutorial)
	- [What is a Docker image?](#what-is-a-docker-image)
	- [Pulling Images](#pulling-images)
- [Contributing](#contributing)
- [Authors](#authors)

<!-- /TOC -->

## Requirements

- A computer with Docker installed on it

### Installation

To install Docker Community Edition on your Linux, Mac, or Windows machine follow the [instructions in the Docker docs](https://docs.docker.com/install/).

## Documentation

The [official Docker documentation and tutorial](https://docs.docker.com/get-started/) can be found on the Docker website. It is quite thorough and useful. It is an excellent guide that should be routinely visited, but the emphasis of this introduction is on using Docker, not how Docker itself works.

## Tutorial

A note up front, Docker has very similar syntax to Git and Linux, so if you are familiar with the command line tools for them then most of Docker should seem somewhat natural (though you should still read the docs!).

### What is a Docker image?

It is still important to know what Docker _is_ and what the components of it _are_.

### Pulling Images

To begin with we're going to [pull](https://docs.docker.com/engine/reference/commandline/pull/) down the Docker image we're going to be working in for the tutorial

```
docker pull matthewfeickert/intro-to-docker
```

and then [list the images](https://docs.docker.com/engine/reference/commandline/images/) that we have available to us locally

```
docker images
```

If you have many images and want to get information on a particular one you can apply a filter, such as the repository name

```
docker images matthewfeickert/intro-to-docker
```

### Running Containers

To use a Docker image as a particular instance on a host machine you [run](https://docs.docker.com/engine/reference/run/) it as a container. You can run in either a [detached or foreground](https://docs.docker.com/engine/reference/run/#detached-vs-foreground) (interactive) mode.

Run the image we pulled as an interactive container

```
docker run -it matthewfeickert/intro-to-docker:latest /bin/bash
```

You are now inside the container in an interactive bash session. Check the file directory

```
pwd
```

revealing that you are in `/root` and check the host to see that you are not in your local host system

```
hostname
```

Further, check the `os-release` to see that you are actually inside a release of Debian (given the [Docker Library's Python image](https://github.com/docker-library/python) Dockerfile choices)

```
cat /etc/os-release
```

### Monitoring Containers

Open up a new terminal tab on the host machine and [list the containers that are currently running](https://docs.docker.com/engine/reference/commandline/ps/)

```
docker ps
```

Notice that the name of your container is some randomly generated name. To make the name more helpful, [rename](https://docs.docker.com/engine/reference/commandline/rename/) the running container

```
docker rename <CONTAINER ID> my-example
```

and then verify it has been renamed

```
docker ps
```

### Exiting and restarting containers

As a test, create a file in your container

```
touch test.txt
```

In the container exit at the command line

```
exit
```

You are returned to your shell. If you list the containers you will notice that none are running

```
docker ps
```

but you can see all containers that have been run and not removed with

```
docker ps -a
```

To restart your exited Docker container [start](https://docs.docker.com/engine/reference/commandline/start/) it again and then [attach](https://docs.docker.com/engine/reference/commandline/attach/) it to your shell

```
docker start <CONTAINER ID>
docker attach <CONTAINER ID>
```

you also have to rename it again (the handle is removed upon exit). Notice that your entry point this time was at `/` not `/root`, so navigate to `/root` (which is `$HOME`) and then check that your `test.txt` still exists

```
cd
ls
```

So this shows us that we can exit Docker containers for arbitrary lengths of time and then return to our working environment inside of them as desired.


## Contributing

If you would like to contribute please read the [CONTRIBUTING.md](https://github.com/matthewfeickert/Intro-to-Docker/blob/master/CONTRIBUTING.md) and then open up an Issue or a PR based on its recommendations. Contributions are welcome and encouraged!

## Authors

- [Matthew Feickert](http://www.matthewfeickert.com/)
