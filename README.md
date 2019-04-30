# Intro to Docker

An opinionated introduction to using [Docker](https://www.docker.com/) as a software development tool

> Disclaimer: This is a collection of examples of how you _can_ use Docker as a supporting tool for software development. I make no claim as to if this follows best practices of software engineering. Exploration of uses on your own should be considered mandatory follow-up to reading.

[![License](https://img.shields.io/badge/License-BSD%203--Clause-blue.svg)](https://opensource.org/licenses/BSD-3-Clause)
[![Docker Automated build](https://img.shields.io/docker/automated/matthewfeickert/intro-to-docker.svg)](https://hub.docker.com/r/matthewfeickert/intro-to-docker/)
[![Docker Build Status](https://img.shields.io/docker/build/matthewfeickert/intro-to-docker.svg)](https://hub.docker.com/r/matthewfeickert/intro-to-docker/builds/)

## Table of Contents
<!-- TOC depthFrom:1 depthTo:6 withLinks:1 updateOnSave:0 orderedList:0 -->

- [Requirements](#requirements)
	- [Installation](#installation)
- [Documentation](#documentation)
- [Tutorial](#tutorial)
	- [Docker Images and Containers](#docker-images-and-containers)
	- [Docker Hub](#docker-hub)
	- [Pulling Images](#pulling-images)
	- [Running Containers](#running-containers)
	- [Monitoring Containers](#monitoring-containers)
	- [Exiting and restarting containers](#exiting-and-restarting-containers)
	- [File I/O with Containers](#file-io-with-containers)
		- [Copying](#copying)
		- [Volume mounting](#volume-mounting)
	- [Running Jupyter from a Docker Container](#running-jupyter-from-a-docker-container)
	- [Docker as Containers as a Service (CaaS)](#docker-as-containers-as-a-service-caas)
	- [Continuous Integration (CI) and Continuous Deployment (CD)](#continuous-integration-ci-and-continuous-deployment-cd)
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

[![Docker logo](https://www.docker.com/sites/default/files/social/docker_twitter_share_new.png)](https://www.docker.com/)

### Docker Images and Containers

It is still important to know what Docker _is_ and what the components of it _are_. Docker images are executables that bundle together all necessary components for an application or an environment. [Docker containers](https://www.docker.com/resources/what-container) are the runtime instances of images &mdash; they are images with a state.

Importantly, containers share the host machine's OS system kernel and so don't require an OS per application. As discrete processes containers take up only as much memory as necessary, making them very lightweight and fast to spin up to run.

[![Docker structure](https://www.docker.com/sites/default/files/styles/large/public/container-what-is-container.png)](https://www.docker.com/resources/what-container)

### Docker Hub

Much like GitHub allows for web hosting and searching for code, [Docker Hub](https://hub.docker.com/) allows the same for Docker images. Hosting and building of images is [free for public repositories](https://hub.docker.com/billing-plans/) and allows for downloading images as they are needed. Additionally, through integrations with GitHub and Bitbucket, Docker Hub repositories can be linked against Git repositories so that [automated builds of Dockerfiles on Docker Hub](https://docs.docker.com/docker-hub/builds/) will be triggered by pushes to repositories.

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

revealing that you are in `/home/docker/data` and check the host to see that you are not in your local host system

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

<details>
 <summary>Starting and attaching by name</summary>

You can also start and attach containers by their name

```
docker start <NAME>
docker attach <NAME>
```

</details>


Notice that your entry point is still `/home/docker/data` and then check that your `test.txt` still exists

```
cd
ls
```

So this shows us that we can exit Docker containers for arbitrary lengths of time and then return to our working environment inside of them as desired.

<details>
 <summary>Clean up a container</summary>

If you want a container to be [cleaned up](https://docs.docker.com/engine/reference/run/#clean-up---rm) &mdash; that is deleted &mdash; after you exit it then run with the `--rm` option flag

```
docker run --rm -it <IMAGE> /bin/bash
```

</details>

### File I/O with Containers

#### Copying

[Copying](https://docs.docker.com/engine/reference/commandline/cp/) files between the local host and Docker containers is possible. On your local host find a file that you want to transfer to the container and then

```
docker cp <file path> <CONTAINER ID>:/
```

and then from the container check and modify it in some way

```
echo "This was written inside Docker" >> example_file.txt
```

and then on the local host copy the file out of the container

```
docker cp <CONTAINER ID>:/example_file.txt .
```

and verify if you want that the file has been modified as you wanted

```
tail example_file.txt
```

#### Volume mounting

What is more common and arguably more useful is to [mount volumes](https://docs.docker.com/storage/volumes/) to containers with the `-v` flag. This allows for direct access to the host file system inside of the container and for container processes to write directly to the host file system.

```
docker run -v <path on host>:<path in container> <image>
```

For example, to mount your current working directory on your local machine to the `data` directory in the example container

```
docker run --rm -it -v $PWD:/home/docker/data matthewfeickert/intro-to-docker
```

From inside the container you can `ls` to see the contents of your directory on your local machine

```
ls
```

and yet you are still inside the container

```
pwd
```

You can also see that any files created in this path in the container persist upon exit

```
touch created_inside.txt
exit
ls *.txt
```

This I/O allows for Docker images to be used for specific tasks that may be difficult to do with the tools or software installed on only the local host machine. For example, debugging problems with software that arise on cross-platform software, or even just having a specific version of software perform a task (e.g., using Python 2 when you don't want it on your machine, or using a specific release of [TeX Live](https://hub.docker.com/r/matthewfeickert/latex-docker/) when you aren't ready to update your system release).

### Running Jupyter from a Docker Container

You can run a Jupyter server from inside of your Docker container. First run a container while [exposing](https://docs.docker.com/engine/reference/run/#expose-incoming-ports) the container's internal port `8888` with the `-p` flag

```
docker run --rm -it -p 8888:8888 matthewfeickert/intro-to-docker /bin/bash
```

Then [start a Jupyter server](https://jupyter.readthedocs.io/en/latest/running.html#starting-the-notebook-server) with the server listening on all IPs

```
jupyter notebook --allow-root --no-browser --ip 0.0.0.0
```

though for your convince the example container has been configured with these default settings so you can just run

```
jupyter notebook
```

Finally, copy and paste the following with the generated token from the server as `<token>` into your web browser on your local host machine

```
http://localhost:8888/?token=<token>
```

You now have access to Jupyter running on your Docker container.

### Docker as Containers as a Service (CaaS)

If Docker is run in a [detached](https://docs.docker.com/engine/reference/run/#detached--d) state then the container will exit as soon as it has executed the commands given to it. If the [clean up](https://docs.docker.com/engine/reference/run/#clean-up---rm) option is given as well, then the container will be removed once it exits.

```
docker run --rm matthewfeickert/intro-to-docker:latest /bin/bash -c 'cat /etc/os-release && echo "hello" && python --version'
```

This allows for containers to serve as either full pieces of infrastructure (e.g., [reana](http://reanahub.io/)) or as individual instances that are spun up, used, and spun down (think something somewhat along the lines of AWS Lambda).

### Continuous Integration (CI) and Continuous Deployment (CD)

To be added for a future extension

## Contributing

If you would like to contribute please read the [CONTRIBUTING.md](https://github.com/matthewfeickert/Intro-to-Docker/blob/master/CONTRIBUTING.md) and then open up an Issue or a PR based on its recommendations. Contributions are welcome and encouraged!

## Authors

- [Matthew Feickert](http://www.matthewfeickert.com/)
