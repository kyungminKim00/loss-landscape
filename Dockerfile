FROM ubuntu:18.04

ENV USER dev_env
ENV HOME /home/$USER
ENV MPI_DIR=/opt/ompi
ENV PATH="$MPI_DIR/bin:$HOME/.local/bin:$PATH"
ENV LD_LIBRARY_PATH="$MPI_DIR/lib:$LD_LIBRARY_PATH"
ENV DEBIAN_FRONTEND noninteractive
ENV TZ=Asia/Seoul

WORKDIR $HOME
COPY . .

RUN echo root:admin | chpasswd

RUN apt-get -q update && apt-get upgrade -y\ 
    && apt-get install -yq --no-install-recommends \
    apt-utils curl tzdata vim less gcc gfortran binutils openssh-server git
    
RUN apt-get install -y software-properties-common \
    && add-apt-repository --yes ppa:deadsnakes/ppa \
    && apt-get install -y \
    python3.9 python3.9-dev python3.9-distutils
RUN apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.9 1
RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
RUN python3.9 get-pip.py    

RUN sed -ri 's/PermitEmptyPasswords no/PermitEmptyPasswords yes/' /etc/ssh/sshd_config \
    && sed -ri 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && sed -ri 's/^UsePAM yes/UsePAM no/' /etc/ssh/sshd_config
RUN service ssh start
RUN chmod 700 /etc/ssh
RUN ln -s /usr/bin/python3.9/usr/bin/python

ADD https://download.open-mpi.org/release/open-mpi/v3.1/openmpi-3.1.4.tar.bz2 .
RUN tar xf openmpi-3.1.4.tar.bz2 \
    && cd openmpi-3.1.4 \
    && ./configure --prefix=$MPI_DIR \
    && make -j4 all \
    && make install \
    && cd .. && rm -rf \
    openmpi-3.1.4 openmpi-3.1.4.tar.bz2 /tmp/*

RUN groupadd -r dev_env \
    && useradd -r -g dev_env $USER \
    && chown -R dev_env:dev_env $HOME
RUN chsh -s /bin/bash dev_env

USER $USER
RUN pip3 install --user -U setuptools \
    && pip3 install --user mpi4py \
    && pip3 install --user --no-cache-dir -r $HOME/requirements.txt \
    && pip3 install --user --no-cache-dir -r $HOME/ci_requirements.txt \
    && pip3 install --user torch torchvision

EXPOSE 22
