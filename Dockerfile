# Test mpi
# >> mpiexec --version 
# >> mpirun --version

# FROM ubuntu:18.04
FROM ubuntu:20.04

ENV USER mpitest
ENV HOME /home/$USER
ENV MPI_DIR=/opt/ompi
ENV PATH="$MPI_DIR/bin:$HOME/.local/bin:$PATH"
ENV LD_LIBRARY_PATH="$MPI_DIR/lib:$LD_LIBRARY_PATH"
WORKDIR $HOME
COPY . .

RUN apt-get -q update \
    && apt-get install -y \
    python3 python3-dev python3-pip \
    gcc gfortran binutils openssh-server \
    && pip3 install --upgrade pip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD https://download.open-mpi.org/release/open-mpi/v3.1/openmpi-3.1.4.tar.bz2 .
RUN tar xf openmpi-3.1.4.tar.bz2 \
    && cd openmpi-3.1.4 \
    && ./configure --prefix=$MPI_DIR \
    && make -j4 all \
    && make install \
    && cd .. && rm -rf \
    openmpi-3.1.4 openmpi-3.1.4.tar.bz2 /tmp/*

RUN sed -ri 's/PermitEmptyPasswords no/PermitEmptyPasswords yes/' /etc/ssh/sshd_config \
    && sed -ri 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && sed -ri 's/^UsePAM yes/UsePAM no/' /etc/ssh/sshd_config

RUN groupadd -r mpitest \
    && useradd -r -g mpitest $USER \
    && chown -R mpitest:mpitest $HOME

USER $USER
RUN pip3 install --user -U setuptools \
    && pip3 install --user mpi4py \
    && pip3 install --user --no-cache-dir -r /dev_env/requirements.txt \
    && pip3 install --user --no-cache-dir -r /dev_env/ci_requirements.txt \
    && pip3 install --user torch

RUN echo "service ssh start" >> /root/.bashrc
RUN passwd -d root

EXPOSE 22
