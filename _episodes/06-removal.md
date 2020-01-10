---
title: "Removal of Containers and Images"
teaching: 5
exercises: 5
questions:
- "How do you cleanup old containers?"
- "How do you delete images?"
objectives:
- "Learn how to cleanup after Docker"
keypoints:
- "Remove containers with `docker rm`"
- "Remove images with `docker rmi`"
- "Perform faster cleanup with `docker container prune`, `docker image prune`, and `docker system prune`"
---

You can cleanup/remove a container [`docker rm`][docker-docs-rm]
~~~
docker rm <CONTAINER ID>
~~~
{: .source}

> ## Remove old containers
>
> Start an instance of the tutorial container, exit it, and then remove it with
> `docker rm`
>
> > ## Solution
> >
> > ~~~
> > docker run matthewfeickert/intro-to-docker:latest
> > docker ps -a
> > docker rm <CONTAINER ID>
> > docker ps -a
> > ~~~
> > {: .source}
> >
> > ~~~
> >CONTAINER ID        IMAGE         COMMAND             CREATED            STATUS                     PORTS               NAMES
> ><generated id>      <image:tag>   "/bin/bash"         n seconds ago      Exited (0) t seconds ago                       <name>
> >
> ><generated id>
> >
> >CONTAINER ID        IMAGE         COMMAND             CREATED            STATUS                     PORTS               NAMES
> > ~~~
> > {: .output}
> {: .solution}
{: .challenge}

You can remove an image from your computer entirely with [`docker rmi`][docker-docs-rmi]
~~~
docker rmi <IMAGE ID>
~~~
{: .source}

> ## Remove an image
>
> Pull down the Python 2.7 image from Docker Hub and then delete it.
>
> > ## Solution
> >
> > ~~~
> > docker pull python:2.7
> > docker images python
> > docker rmi <IMAGE ID>
> > docker images python
> > ~~~
> > {: .source}
> >
> > ~~~
> >2.7: Pulling from library/python
> ><some numbers>: Pull complete
> ><some numbers>: Pull complete
> ><some numbers>: Pull complete
> ><some numbers>: Pull complete
> ><some numbers>: Pull complete
> ><some numbers>: Pull complete
> ><some numbers>: Pull complete
> ><some numbers>: Pull complete
> >Digest: sha256:<the relevant SHA hash>
> >Status: Downloaded newer image for python:2.7
> >docker.io/library/python:2.7
> >
> >REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
> >python              2.7                 d75b4eed9ada        14 hours ago        886MB
> >python              3.7                 e440e2151380        23 hours ago        918MB
> >
> >Untagged: python@sha256:<the relevant SHA hash>
> >Deleted: sha256:<layer SHA hash>
> >Deleted: sha256:<layer SHA hash>
> >Deleted: sha256:<layer SHA hash>
> >Deleted: sha256:<layer SHA hash>
> >Deleted: sha256:<layer SHA hash>
> >Deleted: sha256:<layer SHA hash>
> >Deleted: sha256:<layer SHA hash>
> >Deleted: sha256:<layer SHA hash>
> >Deleted: sha256:<layer SHA hash>
> >Deleted: sha256:<layer SHA hash>
> >
> >REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
> >python              3.7                 e440e2151380        23 hours ago        918MB
> > ~~~
> > {: .output}
> {: .solution}
{: .challenge}

> ## Helpful cleanup commands
> What is helpful is to have Docker detect and remove unwanted images and containers for you.
> This can be done with `prune`, which depending on the context will remove different things.
> - [`docker container prune`](https://docs.docker.com/engine/reference/commandline/container_prune/) removes all stopped containers, which is helpful to clean up forgotten stopped containers.
> - [`docker image prune`](https://docs.docker.com/engine/reference/commandline/image_prune/) removes all unused or dangling images (images that do not have a tag). This is helpful for cleaning up after builds.
> - [`docker system prune`](https://docs.docker.com/engine/reference/commandline/system_prune/) removes all stopped containers, dangling images, and dangling build caches. This is very helpful for cleaning up everything all at once.
{: .callout}

[docker-docs-rm]: https://docs.docker.com/engine/reference/commandline/rm/
[docker-docs-rmi]: https://docs.docker.com/engine/reference/commandline/rmi/

{% include links.md %}
