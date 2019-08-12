---
title: "Writing Dockerfiles"
teaching: 15
exercises: 5
questions:
- "How are Docker images built?"
objectives:
- "First learning objective."
keypoints:
- "First key point. Brief Answer to questions."
---

Docker images are built through the Docker engine by reading the instructions from a
[`Dockerfile`][docker-docs-builder].
These text based documents provide the instructions though an API similar to the Linux
operating system commands to execute commands during the build.
The [`Dockerfile` for the example image][example-Dockerfile] being used is an example of
some simple extensions of the [official Python 3.6.8 Docker image][python-docker-image].

As a very simple of extending the example image into a new image create a `Dockerfile`

~~~
touch Dockerfile
~~~
{: .source}

and then write in it the Docker engine instructions to add [`cowsay`][cowsay] and
[`scikit-learn`][scikit-learn] to the environment

~~~
# Dockerfile
FROM matthewfeickert/intro-to-docker:latest
USER root
RUN apt-get -qq -y update && \
    apt-get -qq -y upgrade && \
    apt-get -qq -y install cowsay && \
    apt-get -y autoclean && \
    apt-get -y autoremove && \
    rm -rf /var/lib/apt-get/lists/* && \
    ln -s /usr/games/cowsay /usr/bin/cowsay
RUN pip install --no-cache-dir -q scikit-learn
USER docker
~~~
{: .source}

Then [`build`][docker-docs-build] an image from the `Dockerfile` and tag it with a human
readable name

~~~
docker build -f Dockerfile -t extend-example:latest --compress .
~~~
{: .source}

You can now run the image as a container and verify for yourself that your additions exist

[docker-docs-builder]: https://docs.docker.com/engine/reference/builder/
[example-Dockerfile]: https://github.com/matthewfeickert/Intro-to-Docker/blob/master/Dockerfile
[python-docker-image]: https://hub.docker.com/_/python
[cowsay]: https://packages.debian.org/jessie/cowsay
[scikit-learn]: https://scikit-learn.org
[docker-docs-build]: https://docs.docker.com/engine/reference/commandline/build/

{% include links.md %}
