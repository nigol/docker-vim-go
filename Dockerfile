FROM phusion/baseimage:0.11                                               
MAINTAINER Martin Polak

ENV HOME /root

RUN apt-get clean && apt-get update && apt-get install -y locales
RUN locale-gen cs_CZ.UTF-8
ENV LANG cs_CZ.UTF-8

RUN (apt-get update && \
     DEBIAN_FRONTEND=noninteractive \
     apt-get install -y software-properties-common \
                        vim git byobu wget curl unzip tree exuberant-ctags \
                        python gdb screen)

# Add a non-root user
RUN (useradd -m -d /home/docker -s /bin/bash docker && \
     echo "docker ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers)

# Install golang
RUN (wget https://dl.google.com/go/go1.13.5.linux-amd64.tar.gz && \
tar -xvf go1.13.5.linux-amd64.tar.gz)


USER docker
ENV HOME /home/docker
WORKDIR /home/docker

RUN (git config --global user.email "nigol@nigol.cz" && \
  git config --global user.name "Martin Polak")
  
# Vim configuration
RUN (mkdir /home/docker/.vim && mkdir /home/docker/.vim/bundle && \
    mkdir -p ~/.vim/autoload ~/.vim/bundle && \
    curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim && \
    git clone https://github.com/nigol/vimrc && \
    cp vimrc/vimrc .vimrc && \
    cd /home/docker/.vim/bundle && \
    git clone https://github.com/tpope/vim-fugitive.git && \
    git clone https://github.com/vim-airline/vim-airline.git && \
    git clone https://github.com/airblade/vim-gitgutter && \
    echo "set makeprg=/home/docker/go/bin/go\ build" >> ~/.vimrc)

# Prepare SSH key file
RUN (mkdir /home/docker/.ssh && \
    touch /home/docker/.ssh/id_rsa && \
    chmod 600 /home/docker/.ssh/id_rsa)

USER root
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

CMD [“/bin/sh”]
