# # RAPIDAI spec - https://rapids.ai/start.html
# # torch & torchvision spec - https://download.pytorch.org/whl/torch_stable.html
# # tensorflow spec - https://www.tensorflow.org/install/source

# # install custom stable version
# # pip install torch===1.11.0+cu115 -f https://download.pytorch.org/whl/torch_stable.html
# # pip install torchvision===0.12.0+cu115 -f https://download.pytorch.org/whl/torch_stable.html

# # FROM rapidsai/rapidsai-core:22.08-cuda11.2-runtime-ubuntu18.04-py3.9
# FROM nvcr.io/nvidia/rapidsai/rapidsai-core:22.10-cuda11.5-base-ubuntu20.04-py3.9

# ENV USER dev_env
# ENV HOME /home/$USER
# ENV MPI_DIR=/opt/ompi
# ENV PATH="$MPI_DIR/bin:$HOME/.local/bin:$PATH"
# ENV LD_LIBRARY_PATH="$MPI_DIR/lib:$LD_LIBRARY_PATH"
# ENV DEBIAN_FRONTEND noninteractive
# ENV TZ=Asia/Seoul
# ENV OMPI_V=openmpi-4.1.4
# WORKDIR $HOME
# COPY . .

# # tensorflow2.11 202212.15 활용 protobuf 버젼이 낮아 다른 패키지와 호환성 문제가 있어 설치 하지 못함
# ENV INGREDIENTS="python3.9-torch1.11.0-cuda11.5-cudnn8.5-openmpi4.1-openssh_server"

# RUN echo root:admin | chpasswd
# RUN apt-get -q update && apt-get upgrade -y \ 
#     && apt-get install -yq apt-utils curl tzdata \ 
#     vim less gcc g++ gfortran binutils openssh-server \
#     git software-properties-common make
    
# # RUN add-apt-repository --yes ppa:ubuntu-toolchain-r/test \
# #     && apt-get update -y \
# #     && apt-get install -y --only-upgrade libstdc++6
    
# RUN apt-get clean \
#     && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# RUN sed -ri 's/PermitEmptyPasswords no/PermitEmptyPasswords yes/' /etc/ssh/sshd_config \
#     && sed -ri 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
#     && sed -ri 's/^UsePAM yes/UsePAM no/' /etc/ssh/sshd_config
# RUN mkdir -p /var/run/sshd && chmod 755 /var/run/sshd && chmod 600 -R /etc/ssh && chmod 777 -R /etc/ssh/sshd_config

# ADD https://download.open-mpi.org/release/open-mpi/v4.1/$OMPI_V.tar.bz2 .
# RUN tar xf $OMPI_V.tar.bz2 \
#     && cd $OMPI_V \
#     && ./configure --prefix=$MPI_DIR \
#     && make -j4 all \
#     && make install \
#     && cd .. && rm -rf \
#     $OMPI_V $OMPI_V.tar.bz2 /tmp/*

# # RUN groupadd -r dev_env \
# #     && useradd -r -g dev_env $USER \
# #     && chown -R dev_env:dev_env $HOME
# RUN useradd -r -g root $USER \
#     && chown -R root:dev_env $HOME
# RUN chsh -s /bin/bash dev_env

# USER $USER
# RUN pip3 install --user -U setuptools \
#     && pip3 install --user mpi4py \
#     && pip3 install --user --no-cache-dir -r $HOME/requirements.txt \
#     && pip3 install --user --no-cache-dir -r $HOME/ci_requirements.txt \
#     && pip3 install --user --no-cache-dir torch==1.11.0 torchvision==0.12.0 gym==0.11.0 tensorboard
#     # && pip3 install --user --no-cache-dir torch --extra-index-url https://download.pytorch.org/whl/cu112 

# # Two different libs with the same identifier (one for rapidai and the other for torch)
# USER root
# RUN cp /conda/envs/rapids/lib/libstdc++.so.6.0.30 /usr/lib/x86_64-linux-gnu/
# WORKDIR /usr/lib/x86_64-linux-gnu/
# RUN rm libstdc++.so.6
# RUN ln -s libstdc++.so.6.0.30 libstdc++.so.6
# # RUN echo service ssh start >> $HOME/.bashrc
# ENTRYPOINT ["service", "ssh", "start"]
# RUN echo $INGREDIENTS

# USER $USER
# WORKDIR $HOME

# EXPOSE 22 6006



# RAPIDAI spec - https://rapids.ai/start.html
# torch & torchvision spec - https://download.pytorch.org/whl/torch_stable.html
# tensorflow spec - https://www.tensorflow.org/install/source

# install custom stable version
# pip install torch===1.11.0+cu115 -f https://download.pytorch.org/whl/torch_stable.html
# pip install torchvision===0.12.0+cu115 -f https://download.pytorch.org/whl/torch_stable.html

FROM nvcr.io/nvidia/rapidsai/rapidsai-core:22.10-cuda11.5-base-ubuntu20.04-py3.9

ENV MPI_DIR=/opt/ompi
ENV PATH="$MPI_DIR/bin:/root/.local/bin:$PATH"
ENV LD_LIBRARY_PATH="$MPI_DIR/lib:$LD_LIBRARY_PATH"
ENV DEBIAN_FRONTEND noninteractive
ENV TZ=Asia/Seoul
ENV OMPI_V=openmpi-4.1.4
# tensorflow2.11 202212.15 활용 protobuf 버젼이 낮아 다른 패키지와 호환성 문제가 있어 설치 하지 못함
ENV INGREDIENTS="python3.9-torch1.11.0-cuda11.5-cudnn8.5-openmpi4.1-openssh_server"

RUN mkdir /dev_env
WORKDIR /dev_env
COPY . .
RUN cp .bashrc /root/ && echo $INGREDIENTS

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
RUN pip3 install setuptools \
    && pip3 install mpi4py \
    && pip3 install --no-cache-dir -r requirements.txt \
    && pip3 install --no-cache-dir -r ci_requirements.txt \
    # && pip3 install --no-cache-dir torch==1.11.0 torchvision==0.12.0 gym==0.11.0 tensorboard
    && pip3 install --no-cache-dir torch torchvision gym==0.11.0 tensorboard

# ad-hoc layer
# Two different libs with the same identifier (one for rapidai and the other for torch)
WORKDIR /usr/lib/x86_64-linux-gnu/
RUN cp /conda/envs/rapids/lib/libstdc++.so.6.0.30 /usr/lib/x86_64-linux-gnu/ \
    && rm libstdc++.so.6 && ln -s libstdc++.so.6.0.30 libstdc++.so.6
WORKDIR /dev_env

EXPOSE 22 6006
CMD ["service", "ssh", "start"]