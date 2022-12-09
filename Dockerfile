FROM pytorch/pytorch:1.13.0-cuda11.6-cudnn8-devel

ENV HOME /root
ENV MPI_DIR=/opt/ompi
ENV PATH="$MPI_DIR/bin:/root/.local/bin:$PATH"
ENV LD_LIBRARY_PATH="$MPI_DIR/lib:$LD_LIBRARY_PATH"

ENV DEBIAN_FRONTEND noninteractive
RUN mkdir /dev_env
WORKDIR /dev_env
COPY . .

RUN apt-get -q update \
    && apt-get install -y \
    python3 python3-dev python3-pip \
    gcc gfortran binutils \
    && pip3 install --upgrade pip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN DEBIAN_FRONTEND="noninteractive" apt-get install -y tzdata \
    && apt-get install -y \
    git vim-nox tree openssh-server \
    && apt-get autoremove -y

ADD https://download.open-mpi.org/release/open-mpi/v3.1/openmpi-3.1.2.tar.bz2 .
RUN tar xf openmpi-3.1.2.tar.bz2 \
    && cd openmpi-3.1.2 \
    && ./configure --prefix=$MPI_DIR \
    && make -j4 all \
    && make install \
    && cd .. && rm -rf \
    openmpi-3.1.2 openmpi-3.1.2.tar.bz2 /tmp/*

RUN pip3 install setuptools \
    && pip3 install mpi4py==2.0.0 \
    && pip3 install --no-cache-dir -r /dev_env/requirements.txt \
    && pip3 install --no-cache-dir -r /dev_env/ci_requirements.txt

RUN sed -ri 's/PermitEmptyPasswords no/PermitEmptyPasswords yes/' /etc/ssh/sshd_config
RUN sed -ri 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/^UsePAM yes/UsePAM no/' /etc/ssh/sshd_config
RUN echo "service ssh start" >> /root/.bashrc
RUN passwd -d root
EXPOSE 22
