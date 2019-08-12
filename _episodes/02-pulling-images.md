---
title: "Pulling Images"
teaching: 10
exercises: 5
questions:
- "How are images downloaded?"
objectives:
- "First learning objective. (FIXME)"
keypoints:
- "First key point. Brief Answer to questions. (FIXME)"
---

# Docker Hub

Much like GitHub allows for web hosting and searching for code, [Docker Hub](https://hub.docker.com/) allows the same for Docker images. Hosting and building of images is [free for public repositories](https://hub.docker.com/billing-plans/) and allows for downloading images as they are needed. Additionally, through integrations with GitHub and Bitbucket, Docker Hub repositories can be linked against Git repositories so that [automated builds of Dockerfiles on Docker Hub](https://docs.docker.com/docker-hub/builds/) will be triggered by pushes to repositories.

# Pulling Images

To begin with we're going to [pull](https://docs.docker.com/engine/reference/commandline/pull/) down the Docker image we're going to be working in for the tutorial

~~~
docker pull matthewfeickert/intro-to-docker
~~~
{: .source}

and then [list the images](https://docs.docker.com/engine/reference/commandline/images/) that we have available to us locally

~~~
docker images
~~~
{: .source}

If you have many images and want to get information on a particular one you can apply a filter, such as the repository name

~~~
docker images matthewfeickert/intro-to-docker
~~~
{: .source}
