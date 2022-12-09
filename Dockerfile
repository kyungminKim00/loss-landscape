FROM pytorch/pytorch:1.13.0-cuda11.6-cudnn8-devel

RUN mkdir /dev_env
WORKDIR /dev_env
COPY . .

RUN apt-get -q update && apt-get upgrade -y
RUN apt-get install -y git
RUN python3 -m pip install --upgrade pip
RUN apt-get autoremove -y
RUN pip3 install --no-cache-dir -r /dev_env/requirements.txt
RUN pip3 install --no-cache-dir -r /dev_env/ci_requirements.txt
