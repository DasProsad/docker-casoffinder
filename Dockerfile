# Use debian bookworm base
FROM debian:bookworm-slim

# Maintainer name for docs
MAINTAINER="Prosad Kumar Das<prosaddas888@gmail.com>"

# Set working directory
WORKDIR /tmp

# Install basic libraries
RUN apt update && apt install -y \
	coreutils \
	git \
	wget \
	unzip \
	zip \
	tar \
	libc6-dev libc6 libc-bin \
	cmake \
	build-essential && \
	apt clean && rm -rf /var/li/apt/lists/*

# Set build arguments
ARG DEBIAN_FRONTEND=noninteractive
ARG APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1

# Set conda arguments
ARG CONDA_DIR=/opt/conda
ARG CONDA_ENV_NAME="PRotActor"

# Install miniconda to /miniconda
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-py38_23.11.0-2-Linux-x86_64.sh -O /tmp/miniconda.sh && \
    /bin/bash /tmp/miniconda.sh -b -p $CONDA_DIR && \
    rm /tmp/miniconda.sh && \
    $CONDA_DIR/bin/conda clean --all -y && \
    ln -s $CONDA_DIR/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate $CONDA_ENV_NAME" >> ~/.bashrc

# Set environment path
ENV PATH /opt/conda/bin:$PATH

# Create conda environment
RUN conda create --name "$CONDA_ENV_NAME" python=3.8 -y

# Install packages in Conda environment
RUN /bin/bash -c ". activate $CONDA_ENV_NAME && \
    conda config --add channels defaults && \
    conda config --add channels bioconda && \
    conda config --add channels conda-forge && \
    conda install -y intel-opencl-rt cas-offinder"

# Copy and install Python requirements
#COPY ./requirements.txt /protactor/requirements.txt

#RUN /bin/bash -c ". activate $CONDA_ENV_NAME && pip3 install -r /protactor/requirements.txt"

# Set working directory
WORKDIR /home
