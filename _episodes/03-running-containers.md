---
title: "Running Containers"
teaching: 15
exercises: 5
questions:
- "How are containers run?"
objectives:
- "First learning objective. (FIXME)"
keypoints:
- "First key point. Brief Answer to questions. (FIXME)"
---

To use a Docker image as a particular instance on a host machine you [run](https://docs.docker.com/engine/reference/run/) it as a container. You can run in either a [detached or foreground](https://docs.docker.com/engine/reference/run/#detached-vs-foreground) (interactive) mode.

Run the image we pulled as an interactive container

~~~
docker run -it matthewfeickert/intro-to-docker:latest /bin/bash
~~~
{: .source}

You are now inside the container in an interactive bash session. Check the file directory

~~~
pwd
~~~
{: .source}

revealing that you are in `/home/docker/data` and check the host to see that you are not in your local host system

~~~
hostname
~~~
{: .source}

Further, check the `os-release` to see that you are actually inside a release of Debian (given the [Docker Library's Python image](https://github.com/docker-library/python) Dockerfile choices)

~~~
cat /etc/os-release
~~~
{: .source}

## Monitoring Containers

Open up a new terminal tab on the host machine and [list the containers that are currently running](https://docs.docker.com/engine/reference/commandline/ps/)

~~~
docker ps
~~~
{: .source}

Notice that the name of your container is some randomly generated name. To make the name more helpful, [rename](https://docs.docker.com/engine/reference/commandline/rename/) the running container

~~~
docker rename <CONTAINER ID> my-example
~~~
{: .source}

and then verify it has been renamed

~~~
docker ps
~~~
{: .source}

# Exiting and restarting containers

As a test, create a file in your container

~~~
touch test.txt
~~~
{: .source}

In the container exit at the command line

~~~
exit
~~~
{: .source}

You are returned to your shell. If you list the containers you will notice that none are running

~~~
docker ps
~~~
{: .source}

but you can see all containers that have been run and not removed with

~~~
docker ps -a
~~~
{: .source}

To restart your exited Docker container [start](https://docs.docker.com/engine/reference/commandline/start/) it again and then [attach](https://docs.docker.com/engine/reference/commandline/attach/) it to your shell

~~~
docker start <CONTAINER ID>
docker attach <CONTAINER ID>
~~~
{: .source}

<details>
 <summary>Starting and attaching by name</summary>

You can also start and attach containers by their name

~~~
docker start <NAME>
docker attach <NAME>
~~~
{: .source}

</details>


Notice that your entry point is still `/home/docker/data` and then check that your `test.txt` still exists

~~~
cd
ls
~~~
{: .source}

So this shows us that we can exit Docker containers for arbitrary lengths of time and then return to our working environment inside of them as desired.

<details>
 <summary>Clean up a container</summary>

If you want a container to be [cleaned up](https://docs.docker.com/engine/reference/run/#clean-up---rm) &mdash; that is deleted &mdash; after you exit it then run with the `--rm` option flag

~~~
docker run --rm -it <IMAGE> /bin/bash
~~~
{: .source}

</details>
