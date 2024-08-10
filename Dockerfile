# Use the official Ubuntu image from the Docker Hub as a base image
FROM ubuntu:24.04

RUN apt update && apt upgrade -y 

# Install git
RUN apt install git -y

# Set environment variables to avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Update the package list and install necessary dependencies
RUN apt-get update && \
    apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# Add Docker’s official GPG key
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

# Set up the Docker repository
RUN echo "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list

# Update the package list again and install Docker
RUN apt-get update && \
    apt-get install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io

# Verify Docker installation
RUN docker --version

# Install nvm and node v20.16.0 and bun
ENV NVM_DIR=/usr/local/nvm
RUN mkdir -p $NVM_DIR

# Install nvm
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash

# Install Node.js using nvm
RUN bash -c "source $NVM_DIR/nvm.sh && \
    nvm install v20.16.0 && \
    nvm use v20.16.0 && \
    nvm alias default v20.16.0"

# Add nvm to the PATH
ENV PATH=$NVM_DIR/versions/node/v20.16.0/bin:$PATH
# Verify installation
RUN node -v && npm -v
RUN npm i -g bun

# Installing neovim
RUN mkdir -p /root/.local
RUN apt install neovim -y
RUN curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin

RUN git clone https://github.com/LazyVim/starter ~/.config/nvim
RUN rm -rf ~/.config/nvim/.git

# Enabling firewall ufw && GUI -> gufw
RUN apt install ufw -y
RUN systemctl enable ufw
# RUN apt install gufw -y

# neofetch, htop, gcc
RUN apt install neofetch htop gcc -y

# JAVA SDK
RUN apt install default-jre -y

# Install ffmepg
RUN apt install ffmpeg -y

# flaptpak install
# RUN apt install flatpak -y
# RUN apt install gnome-software-plugin-flatpak -y
# RUN flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# Brave Install
# RUN flatpak install flathub com.brave.Browser -y
# OBS Install
# RUN flatpak install flathub com.obsproject.Studio -y

# Steam
# RUN apt install steam obs -y

# preload -> to boost startup time
# RUN apt install preload -y

# Restart camera module
# RUN systemctl --user restart pipewire

# Laptop power tweaks
# RUN apt install tlp tlp-rdw -y
# RUN systemctl start tlp

# Clearing caches
# RUN apt install bleachbit -y

# Install Vlc
# RUN apt install ubuntu-restricted-extrasapt
# RUN apt install vlc

# Shell extension
# RUN apt install gnome-tweaks gnome-shell-extensions -y

# Enable click on icon to minimise
# RUN gsettings set org.gnome.shell.extensions.dash-to-dock click-action "minimize"

CMD ["bash"]
