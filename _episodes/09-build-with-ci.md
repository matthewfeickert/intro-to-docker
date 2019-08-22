---
title: "Build Docker Images with GitLab CI"
teaching: 20
exercises: 10
questions:
- "How can CI be used to build Docker images?"
objectives:
- "Build Docker images using GitLab CI"
- "Deploy Docker images to GitLab Registry"
- "Pull Docker images from GitLab Registry"
keypoints:
- "CI can be used to build images automatically"
---

We know how to build Docker images, but it would be better to be able to build many images
quickly and not on our own computer.
CI can help here.

First, create a new repository in GitLab.
You can call it whatever you like, but as an example we'll used "build-with-ci-example".

> ## Clone the repo
>
> Clone the repo down to your local machine and navigate into it.
>
> > ## Solution
> >
> > Get the repo URL from the project GitLab webpage
> >~~~
> >git clone <repo URL>
> >cd build-with-ci-example
> >~~~
> >{: .source}
> {: .solution}
{: .challenge}

> ## Add a feature branch
>
> Add a new feature branch to the repo for adding CI
>
> > ## Solution
> >
> >~~~
> >git checkout -b feature/add-CI
> >~~~
> >{: .source}
> {: .solution}
{: .challenge}

> ## Add a Dockerfile
>
> Add an example Dockerfile that uses `ENTRYPOINT`
>
> > ## Solution
> >
> > Write and commit a `Dockerfile` like
> >
> >~~~
> ># Make the base image configurable
> >ARG BASE_IMAGE=python:3.7
> >FROM ${BASE_IMAGE}
> >USER root
> >RUN apt-get -qq -y update && \
> >    apt-get -qq -y upgrade && \
> >    apt-get -y autoclean && \
> >    apt-get -y autoremove && \
> >    rm -rf /var/lib/apt-get/lists/*
> ># Create user "docker"
> >RUN useradd -m docker && \
> >    cp /root/.bashrc /home/docker/ && \
> >    mkdir /home/docker/data && \
> >    chown -R --from=root docker /home/docker
> >ENV HOME /home/docker
> >WORKDIR ${HOME}/data
> >USER docker
> >
> >COPY entrypoint.sh $HOME/entrypoint.sh
> >ENTRYPOINT ["/bin/bash", "/home/docker/entrypoint.sh"]
> >CMD ["Docker"]
> >~~~
> >{: .source}
> {: .solution}
{: .challenge}

> ## Add an entry point script
>
> Write and commit a Bash script to be run as `ENTRYPOINT`
>
> > ## Solution
> >
> > Make a file named `entrypoint.sh` that contains  
> >
> >~~~bash
> >#!/usr/bin/env bash
> >
> >set -e
> >
> >function main() {
> >    if [[ $# -eq 0 ]]; then
> >        printf "\nHello, World!\n"
> >    else
> >        printf "\nHello, %s!\n" "${1}"
> >    fi
> >}
> >
> >main "$@"
> >
> >/bin/bash
> >~~~
> >{: .bash}
> {: .solution}
{: .challenge}

## Required GitLab YAML

To build images using GitLab CI jobs the [kaniko](https://docs.gitlab.com/ee/ci/docker/using_kaniko.html)
tool from Google is used.
Kaniko jobs on CERN's Enterprise Edition of GitLab expect some "boiler plate" YAML to run
properly

~~~
- build

.build_template:
stage: build
image:
  # Use CERN version of the Kaniko image
  name: gitlab-registry.cern.ch/ci-tools/docker-image-builder
  entrypoint: [""]
variables:
  DOCKERFILE: <Dockerfile path>
  BUILD_ARG_1: <argument to the Dockerfile>
  TAG: latest
  # Use single quotes to escape colon
  DESTINATION: '${CI_REGISTRY_IMAGE}:${TAG}'
before_script:
  # Prepare Kaniko configuration file
  - echo "{\"auths\":{\"$CI_REGISTRY\":{\"username\":\"$CI_REGISTRY_USER\",\"password\":\"$CI_REGISTRY_PASSWORD\"}}}" > /kaniko/.docker/config.json
script:
  - printenv
  # Build and push the image from the given Dockerfile
  # See https://docs.gitlab.com/ee/ci/variables/predefined_variables.html#variables-reference for available variables
  - /kaniko/executor --context $CI_PROJECT_DIR
    --dockerfile ${DOCKERFILE}
    --build-arg ${BUILD_ARG_1}
    --destination ${DESTINATION}
only:
  # Only build if the generating files change
  changes:
    - ${DOCKERFILE}
    - entrypoint.sh
except:
  - tags
~~~
{: .source}

> ## Python 3.7 default build
>
> Revise this to build from the Python 3.7 image for the `Dockerfile` just written
>
> > ## Solution
> >
> > Make a file named `entrypoint.sh` that contains  
> >
> >~~~
> >stages:
> >  - build
> >
> >.build_template:
> >  stage: build
> >  image:
> >    # Use CERN version of the Kaniko image
> >    name: gitlab-registry.cern.ch/ci-tools/docker-image-builder
> >    entrypoint: [""]
> >  variables:
> >    DOCKERFILE: Dockerfile
> >    BUILD_ARG_1: BASE_IMAGE=python:3.7
> >    TAG: latest
> >    # Use single quotes to escape colon
> >    DESTINATION: '${CI_REGISTRY_IMAGE}:${TAG}'
> >  before_script:
> >    # Prepare Kaniko configuration file
> >    - echo "{\"auths\":{\"$CI_REGISTRY\":{\"username\":\"$CI_REGISTRY_USER\",\"password\":\"$CI_REGISTRY_PASSWORD\"}}}" > /kaniko/.docker/config.json
> >  script:
> >    - printenv
> >    # Build and push the image from the given Dockerfile
> >    # See https://docs.gitlab.com/ee/ci/variables/predefined_variables.html#variables-reference for available variables
> >    - /kaniko/executor --context $CI_PROJECT_DIR
> >      --dockerfile ${DOCKERFILE}
> >      --build-arg ${BUILD_ARG_1}
> >      --destination ${DESTINATION}
> >  only:
> >    # Only build if the generating files change
> >    changes:
> >      - ${DOCKERFILE}
> >      - entrypoint.sh
> >  except:
> >    - tags
> >~~~
> >{: .source}
> {: .solution}
{: .challenge}

Let's now add two types of jobs: validation jobs that run on MRs and deployment jobs that
run on `master`

~~~
stages:
  - build

.build_template:
  stage: build
  image:
    # Use CERN version of the Kaniko image
    name: gitlab-registry.cern.ch/ci-tools/docker-image-builder
    entrypoint: [""]
  variables:
    DOCKERFILE: Dockerfile
    BUILD_ARG_1: BASE_IMAGE=python:3.7
    TAG: latest
    # Use single quotes to escape colon
    DESTINATION: '${CI_REGISTRY_IMAGE}:${TAG}'
  before_script:
    # Prepare Kaniko configuration file
    - echo "{\"auths\":{\"$CI_REGISTRY\":{\"username\":\"$CI_REGISTRY_USER\",\"password\":\"$CI_REGISTRY_PASSWORD\"}}}" > /kaniko/.docker/config.json
  script:
    - printenv
    # Build and push the image from the given Dockerfile
    # See https://docs.gitlab.com/ee/ci/variables/predefined_variables.html#variables-reference for available variables
    - /kaniko/executor --context $CI_PROJECT_DIR
      --dockerfile ${DOCKERFILE}
      --build-arg ${BUILD_ARG_1}
      --destination ${DESTINATION}
  only:
    # Only build if the generating files change
    changes:
      - ${DOCKERFILE}
      - entrypoint.sh
  except:
    - tags

.validate_template:
  extends: .build_template
  except:
    refs:
      - master

.deploy_template:
  extends: .build_template
  only:
    refs:
      - master

# Validation jobs
validate python 3.7:
  extends: .validate_template
  variables:
    TAG: validate-latest

# Deploy jobs
deploy python 3.7:
  extends: .deploy_template
  variables:
    TAG: latest
~~~
{: .source}

> ## Python 3.6 jobs
>
> What needs to be added to build Python 3.6 images for both validation jobs and deployment
> jobs?
>
> > ## Solution
> >
> > Just more jobs that have a different `BASE_IMAGE` variable
> >
> >~~~
> >
> ># ...
> ># Same as the above
> ># ...
> >
> ># Validation jobs
> >validate python 3.7:
> >  extends: .validate_template
> >  variables:
> >    TAG: validate-latest
> >
> >validate python 3.6:
> >  extends: .validate_template
> >  variables:
> >    BUILD_ARG_1: BASE_IMAGE=python:3.6
> >    TAG: validate-py-3.6
> >
> ># Deploy jobs
> >deploy python 3.7:
> >  extends: .deploy_template
> >  variables:
> >    TAG: latest
> >
> >deploy python 3.6:
> >  extends: .deploy_template
> >  variables:
> >    BUILD_ARG_1: BASE_IMAGE=python:3.6
> >    TAG: py-3.6
> >~~~
> >{: .source}
> {: .solution}
{: .challenge}

> ## Run pipeline and build
>
> Now add and commit the CI YAML, push it, and make a MR
>
> > ## Solution
> >
> >~~~
> >git add .gitlab-ci.yml
> >git commit
> >git push -u origin feature/add-CI
> ># visit https://gitlab.cern.ch/<your user name here>/build-with-ci-example/merge_requests/new?merge_request%5Bsource_branch%5D=feature%2Fadd-CI
> >~~~
> >{: .source}
> {: .solution}
{: .challenge}

In the GitLab UI check the pipeline and the validate jobs and see that different Python 3
versions are being run.
Once they finish, merge the MR and then watch the deploy jobs.
When the jobs finish navigate to your GitLab Registry tab in your GitLab project UI and
click on the link named `<user name>/<build-with-ci-example>` under **Container Registry**.
Notice there are 4 container tags.
Click on the icon next to the `py-3.6` tag to copy its full registry name into your
clipboard.
This can be used to pull the image from your GitLab registry.

> ## Pull your image from GitLab Registry
>
> Pull your CI built Python 3.6 image using its full registry name and run it!
>
> > ## Solution
> >
> >~~~
> >docker pull gitlab-registry.cern.ch/<user name>/build-with-ci-example:py-3.6
> >docker run --rm -it gitlab-registry.cern.ch/<user name>/build-with-ci-example:py-3.6
> >python3 --version
> >~~~
> >{: .source}
> >~~~
Python 3.6.9
> >~~~
> >{: .output}
> {: .solution}
{: .challenge}

## Summary

- Wrote Dockerfile
- Wrote GitLab CI YAML
- Built multiple Docker images in parallel with GitLab CI
- Deployed built images to GitLab registry
- Pulled and used built images from GitLab registry

[![awesome](https://thumbs.gfycat.com/SecondhandSerpentineApisdorsatalaboriosa-size_restricted.gif)]()

{% include links.md %}
