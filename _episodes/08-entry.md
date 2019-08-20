---
title: "Using CMD and ENTRYPOINT in Dockerfiles"
teaching: 20
exercises: 10
questions:
- "How are default commands set in Dockerfiles?"
objectives:
- "Learn how and when to use `CMD`"
- "Learn how and when to use `ENTRYPOINT`"
keypoints:
- "`CMD` provide defaults for an executing container"
- "`CMD` can provide options for `ENTRYPOINT`"
- "`ENTRYPOINT` allows you to configure commands that will always run for an executing container"
---

So far everytime we've run the Docker containers we've typed

~~~
docker run --rm -it <IMAGE>:<TAG> <command>
~~~
{: .source}

like

~~~
docker run --rm -it python:3.7 /bin/bash
~~~
{: .source}

Running this dumps us into a Bash session

~~~
printenv | grep SHELL
~~~
{: .source}

~~~
SHELL=/bin/bash
~~~
{: .output}

However, if no `/bin/bash` is given then you are placed inside the Python 3.7 REPL.

~~~
docker run --rm -it python:3.7
~~~
{: .source}

~~~
Python 3.7.4 (default, Jul 13 2019, 14:04:11)
[GCC 8.3.0] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>>
~~~
{: .output}

These are very different behaviors, so let's understand what is happening.

The Python 3.7 Docker image has a default command that runs when the container is executed,
which is specified in the Dockerfile with [`CMD`][docker-docs-CMD].

~~~
# Dockerfile.defaults
# Make the base image configurable
ARG BASE_IMAGE=python:3.7
FROM ${BASE_IMAGE}
USER root
RUN apt-get -qq -y update && \
    apt-get -qq -y upgrade && \
    apt-get -y autoclean && \
    apt-get -y autoremove && \
    rm -rf /var/lib/apt-get/lists/*
# Create user "docker"
RUN useradd -m docker && \
    cp /root/.bashrc /home/docker/ && \
    mkdir /home/docker/data && \
    chown -R --from=root docker /home/docker
ENV HOME /home/docker
WORKDIR ${HOME}/data
USER docker

CMD ["/bin/bash"]
~~~
{: .source}

~~~
docker build -f Dockerfile.defaults -t defaults-example:latest --compress .
~~~
{: .source}

Now running

~~~
docker run --rm -it defaults-example:latest
~~~
{: .source}

again drops you into a Bash shell as specified by `CMD`.
As has already been seen, `CMD` can be overridden by giving a command after the image

~~~
docker run --rm -it defaults-example:latest python3
~~~
{: .source}

The [`ENTRYPOINT`][docker-docs-ENTRYPOINT] builder command allows to define a command or
commands that are **always** run at the "entry" to the Docker container.
If an `ENTRYPOINT` has been defined then `CMD` provides optional inputs to the `ENTRYPOINT`.

~~~bash
# entrypoint.sh
#!/usr/bin/env bash

set -e

function main() {
    if [[ $# -eq 0 ]]; then
        printf "\nHello, World!\n"
    else
        printf "\nHello, %s!\n" "${1}"
    fi
}

main "$@"

/bin/bash
~~~
{: .bash}

~~~
# Dockerfile.defaults
# Make the base image configurable
ARG BASE_IMAGE=python:3.7
FROM ${BASE_IMAGE}
USER root
RUN apt-get -qq -y update && \
    apt-get -qq -y upgrade && \
    apt-get -y autoclean && \
    apt-get -y autoremove && \
    rm -rf /var/lib/apt-get/lists/*
# Create user "docker"
RUN useradd -m docker && \
    cp /root/.bashrc /home/docker/ && \
    mkdir /home/docker/data && \
    chown -R --from=root docker /home/docker
ENV HOME /home/docker
WORKDIR ${HOME}/data
USER docker

COPY entrypoint.sh $HOME/entrypoint.sh
ENTRYPOINT ["/bin/bash", "/home/docker/entrypoint.sh"]
CMD ["Docker"]
~~~
{: .source}

~~~
docker build -f Dockerfile.defaults -t defaults-example:latest --compress .
~~~
{: .source}

So now

~~~
docker run --rm -it defaults-example:latest
~~~
{: .source}

~~~

Hello, Docker!
docker@2a99ffabb512:~/data$
~~~
{: .output}

> ## Applied `ENTRYPOINT` and `CMD`
>
> What will be the output of
>~~~
>docker run --rm -it defaults-example:latest $USER
>~~~
>{: .source}
> and why?
>
> > ## Solution
> >
> >~~~
> >
> >Hello, <your user name>!
> >docker@2a99ffabb512:~/data$
> >~~~
> >{: .output}
> `$USER` is evaluated and then overrides the default `CMD` to be passed to `entrypoint.sh`
> {: .solution}
{: .challenge}

[docker-docs-CMD]: https://docs.docker.com/engine/reference/builder/#cmd
[docker-docs-ENTRYPOINT]: https://docs.docker.com/engine/reference/builder/#entrypoint

{% include links.md %}
