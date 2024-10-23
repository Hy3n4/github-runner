# syntax=docker/dockerfile:1
FROM ubuntu:22.04

ARG RUNNER_VERSION="2.320.0"
ARG RUNNER_OS="linux"
ARG RUNNER_ARCH="x64"

ENV DEBIAN_FRONTEND=noninteractive
ENV RUNNER_ARCHIVE_FILE="actions-runner-${RUNNER_OS}-${RUNNER_ARCH}-${RUNNER_VERSION}.tar.gz"
ENV DOWNLOAD_LINK="https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/${RUNNER_ARCHIVE_FILE}"
ENV USER="actions-runner"

LABEL Author="Hy3n4"
LABEL Email="hy3nk4@gmail.com"
LABEL Github="https://github.com/Hy3n4"
LABEL BaseImage="ubuntu:22.04"
LABEL RunnerVersion="${RUNNER_VERSION}"

RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install -y --no-install-recommends \
    curl wget unzip git jq python3 python3-dev ca-certificates

RUN useradd -m ${USER}

RUN cd /home/${USER} \
    && curl -fsSL -O ${DOWNLOAD_LINK} \
    && tar xzf ./${RUNNER_ARCHIVE_FILE}

RUN chown -R actions-runner ~actions-runner && /home/actions-runner/bin/installdependencies.sh

ADD scripts/start.sh start.sh
RUN chmod +x start.sh

USER docker

ENTRYPOINT ["./start.sh"]
