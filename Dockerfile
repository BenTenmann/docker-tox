FROM ubuntu:20.04

SHELL ["/bin/bash", "-c"]

RUN apt update && \
    apt install -y software-properties-common && \
    add-apt-repository ppa:deadsnakes/ppa

RUN apt update && \
    apt install -y build-essential git

RUN apt update && \
    apt install -y \
    python2.7-dev python3.{5..11}-dev \
    pypy-dev pypy3-dev \
    python3.{5..11}-venv

RUN apt update && \
    apt install -y python3-pip && \
    pip install 'tox>=4.0.0a2'

ONBUILD COPY install-prereqs*.sh requirements*.txt tox.ini /app/
ONBUILD ARG SKIP_TOX=false
ONBUILD RUN bash -c " \
    if [ -f '/app/install-prereqs.sh' ]; then \
        bash /app/install-prereqs.sh; \
    fi && \
    if [ $SKIP_TOX == false ]; then \
        TOXBUILD=true tox; \
    fi"
