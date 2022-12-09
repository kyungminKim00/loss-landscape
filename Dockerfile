FROM pytorch/pytorch:1.13.0-cuda11.6-cudnn8-devel
ENV DEBIAN_FRONTEND noninteractive
RUN mkdir /dev_env
WORKDIR /dev_env
COPY . .

RUN apt-get update && apt-get upgrade -y && apt-get install -y
RUN DEBIAN_FRONTEND="noninteractive" apt-get install -y tzdata
RUN apt-get install -y git vim-nox tree openssh-server
RUN apt-get autoremove -y

RUN python3 -m pip install --upgrade pip
RUN python3 -m pip install mpi4py
RUN pip3 install --no-cache-dir -r /dev_env/requirements.txt
RUN pip3 install --no-cache-dir -r /dev_env/ci_requirements.txt

RUN sed -ri 's/PermitEmptyPasswords no/PermitEmptyPasswords yes/' /etc/ssh/sshd_config
RUN sed -ri 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/^UsePAM yes/UsePAM no/' /etc/ssh/sshd_config
RUN echo "service ssh start" >> /root/.bashrc
RUN passwd -d root
EXPOSE 22


