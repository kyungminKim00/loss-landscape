# RAPIDAI spec - https://rapids.ai/start.html
# torch & torchvision spec - https://download.pytorch.org/whl/torch_stable.html
# tensorflow spec - https://www.tensorflow.org/install/source

# install custom stable version
# pip install torch===1.11.0+cu115 -f https://download.pytorch.org/whl/torch_stable.html
# pip install torchvision===0.12.0+cu115 -f https://download.pytorch.org/whl/torch_stable.html

FROM nvcr.io/nvidia/rapidsai/rapidsai-core:22.10-cuda11.5-base-ubuntu20.04-py3.9

ENV USER=kmkim
ENV HOME=/home/$USER
ENV MPI_DIR=/opt/ompi
ENV PATH="$MPI_DIR/bin:$HOME/.local/bin:$PATH"
ENV LD_LIBRARY_PATH="$MPI_DIR/lib:$LD_LIBRARY_PATH"
ENV DEBIAN_FRONTEND noninteractive
ENV TZ=Asia/Seoul
ENV OMPI_V=openmpi-4.1.4

# (202212.15) tensorflow2.11 활용 protobuf 버젼이 낮아 다른 패키지와 호환성 문제가 있어 설치 하지 못함
ENV INGREDIENTS="rapidsai_core22.10_cuda11.5_ubuntu20.04_py3.9-torch1.13.0+cu117-cudnn8.5-openmpi4.1-openssh_server"

RUN mkdir /dev_env
RUN mkdir -p $MPI_DIR/bin
RUN mkdir -p $HOME/.local/bin
WORKDIR /dev_env
COPY . .
RUN cp .bashrc /root/ && cp .bashrc /home/$USER  && echo $INGREDIENTS

# lib update layer
RUN apt-get -q update && apt-get upgrade -y \ 
    && apt-get install -yq apt-utils curl tzdata \ 
    vim less gcc g++ gfortran binutils openssh-server \
    git software-properties-common make \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# configure layer
RUN sed -ri 's/PermitEmptyPasswords no/PermitEmptyPasswords yes/' /etc/ssh/sshd_config \
    && sed -ri 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && sed -ri 's/^UsePAM yes/UsePAM no/' /etc/ssh/sshd_config \
    && chsh -s /bin/bash \
    && mkdir -p /var/run/sshd \
    && chmod 755 /var/run/sshd \
    && chmod 600 -R /etc/ssh \
    && echo root:admin | chpasswd

# openmpi layer
ADD https://download.open-mpi.org/release/open-mpi/v4.1/$OMPI_V.tar.bz2 .
RUN tar xf $OMPI_V.tar.bz2 \
    && cd $OMPI_V \
    && ./configure --prefix=$MPI_DIR \
    && make -j4 all \
    && make install \
    && cd .. && rm -rf \
    $OMPI_V $OMPI_V.tar.bz2 /tmp/*

# python package layer
RUN groupadd -r kmkim \
    && useradd -r -g kmkim $USER \
    && chown -R kmkim:kmkim /home/$USER
USER $USER
RUN pip3 install --user -U setuptools \
    && pip3 install --user mpi4py \
    && pip3 install --user --no-cache-dir -r requirements.txt \
    && pip3 install --user --no-cache-dir -r ci_requirements.txt \
    && pip3 install --user --no-cache-dir torch torchvision gym==0.11.0 tensorboard
RUN chsh -s /bin/bash  && conda init --all && conda activate rapids

# ad-hoc layer
# Two different libs with the same identifier (one for rapidai and the other for torch)
USER root
WORKDIR /usr/lib/x86_64-linux-gnu/
RUN cp /conda/envs/rapids/lib/libstdc++.so.6.0.30 /usr/lib/x86_64-linux-gnu/ \
    && rm libstdc++.so.6 && ln -s libstdc++.so.6.0.30 libstdc++.so.6
WORKDIR /dev_env

EXPOSE 22 6006
CMD ["service", "ssh", "start"]
