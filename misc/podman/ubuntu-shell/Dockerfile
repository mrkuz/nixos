FROM ubuntu:rolling

ENV DEBIAN_FRONTEND noninteractive
ENV TERM xterm

# Basics
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends \
    apt-utils \
    ca-certificates \
    dialog \
    locales \
    tzdata \
    && rm -rf /var/lib/apt/lists/* \
    && locale-gen en_US.UTF-8

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8

# Tools
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    bash-completion \
    curl \
    fzf \
    git \
    nano \
    sudo \
    unzip \
    zip \
    && rm -rf /var/lib/apt/lists/*

ARG USER
ARG USER_ID
ARG GROUP
ARG GROUP_ID
RUN userdel -r ubuntu \
    && groupadd -g $GROUP_ID $GROUP \
    && useradd -u $USER_ID -g $GROUP_ID -G adm,sudo,audio,video,plugdev,games -s /bin/bash -m $USER \
    && install -o $USER -g $GROUP -m 700 -d /run/user/$USER_ID \
    && install -o $USER -g $GROUP -m 700 -d /run/user/$USER_ID/pulse \
    && echo "$USER ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

WORKDIR /home/$USER/
CMD [ "/bin/bash" ]
