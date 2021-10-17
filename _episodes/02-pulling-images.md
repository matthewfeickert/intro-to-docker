---
title: "Pulling Images"
teaching: 10
exercises: 5
questions:
- "How are images downloaded?"
- "How are images distinguished?"
objectives:
- "Pull images from Docker Hub image registry"
- "List local images"
- "Introduce image tags"
keypoints:
- "Pull images with `docker pull`"
- "List images with `docker images`"
- "Image tags distinguish releases or version and are appended to the image name with a colon"
---

# Docker Hub

Much like GitHub allows for web hosting and searching for code, the [Docker Hub][docker-hub]
image registry allows the same for Docker images.
Hosting and building of images is [free for public repositories][docker-hub-billing] and
allows for downloading images as they are needed.
Additionally, through integrations with GitHub and Bitbucket, Docker Hub repositories can
be linked against Git repositories so that
[automated builds of Dockerfiles on Docker Hub][docker-hub-builds] will be triggered by
pushes to repositories.

# Pulling Images

To begin with we're going to [pull][docker-docs-pull] down the Docker image we're going
to be working in for the tutorial

~~~
docker pull matthewfeickert/intro-to-docker
~~~
{: .source}

and then [list the images][docker-docs-images] that we have available to us locally

~~~
docker images
~~~
{: .source}

If you have many images and want to get information on a particular one you can apply a
filter, such as the repository name

~~~
docker images matthewfeickert/intro-to-docker
~~~
{: .source}

~~~
REPOSITORY                        TAG                 IMAGE ID            CREATED             SIZE
matthewfeickert/intro-to-docker   latest              f4279e4a8ab0        26 hours ago        1.45GB
~~~
{: .output}

or more explicitly

~~~
docker images --filter=reference="matthewfeickert/intro-to-docker"
~~~
{: .source}

~~~
REPOSITORY                        TAG                 IMAGE ID            CREATED             SIZE
matthewfeickert/intro-to-docker   latest              f4279e4a8ab0        26 hours ago        1.45GB
~~~
{: .output}

You can see here that there is the `TAG` field associated with the
`matthewfeickert/intro-to-docker` image.
Tags are way of further specifying different versions of the same image.
As an example, let's pull the buster release tag of the
[Debian image](https://hub.docker.com/_/debian).

~~~
docker pull debian:buster
docker images debian
~~~
{: .source}

~~~
buster: Pulling from library/debian
<some numbers>: Pull complete
Digest: sha256:<the relevant SHA hash>
Status: Downloaded newer image for debian:buster
docker.io/library/debian:buster

REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
debian              buster              ee11c54e6bb7        3 weeks ago         114MB
~~~
{: .output}

Additionally, there might be times where the _same_ image has different tags.
For example, we can pull the `bootcamp-2020` tag of the `matthewfeickert/intro-to-docker`
image, but when we inspect it we wee that it is the **same** image as the one we already pulled.

~~~
docker pull matthewfeickert/intro-to-docker:bootcamp-2020
docker images matthewfeickert/intro-to-docker
~~~
{: .source}

~~~
REPOSITORY                        TAG                 IMAGE ID            CREATED             SIZE
matthewfeickert/intro-to-docker   bootcamp-2020       f4279e4a8ab0        26 hours ago        1.45GB
matthewfeickert/intro-to-docker   latest              f4279e4a8ab0        26 hours ago        1.45GB
~~~
{: .output}

> ## Pulling Python
>
> Pull the image for Python 3.8 and then list all `python` images along with
> the `matthewfeickert/intro-to-docker` image
>
> > ## Solution
> >
> > ~~~
> > docker pull python:3.8
> > docker images --filter=reference="matthewfeickert/intro-to-docker" --filter=reference="python"
> > ~~~
> > {: .source}
> >
> > ~~~
> > REPOSITORY                        TAG                 IMAGE ID            CREATED             SIZE
> > python                            3.8                 79cc46abd78d        2 weeks ago         882MB
> > matthewfeickert/intro-to-docker   bootcamp-2020       f4279e4a8ab0        26 hours ago        1.45GB
> > matthewfeickert/intro-to-docker   latest              f4279e4a8ab0        26 hours ago        1.45GB
> > ~~~
> > {: .output}
> {: .solution}
{: .challenge}

[docker-hub]: https://hub.docker.com/
[docker-hub-billing]: https://hub.docker.com/billing-plans/
[docker-hub-builds]: https://docs.docker.com/docker-hub/builds/
[docker-docs-pull]: https://docs.docker.com/engine/reference/commandline/pull/
[docker-docs-images]: https://docs.docker.com/engine/reference/commandline/images/

{% include links.md %}
