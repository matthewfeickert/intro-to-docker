---
title: "Challenge Examples"
teaching: 0
exercises: 20
questions:
- "How to do a few more things?"
objectives:
- "How to run with SSH and not use `cp`"
keypoints:
- "Containers are extensive"
---

> ## Get SSH credentials in a container without `cp`
>
> Get SSH credentials inside a container without using `cp`
>
> > ## Solution
> >
> > Mount multiple volumes
> >~~~
> >docker run --rm -it \
> >  -w /home/atlas/Bootcamp \
> >  -v $PWD:/home/atlas/Bootcamp \
> >  -v $HOME/.ssh:/home/atlas/.ssh \
> >  -v $HOME/.gitconfig:/home/atlas/.gitconfig \
> >  atlas/analysisbase:21.2.85-centos7
> >~~~
> >{: .source}
> {: .solution}
{: .challenge}

{% include links.md %}
