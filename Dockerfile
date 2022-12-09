FROM pytorch/pytorch:1.13.0-cuda11.6-cudnn8-devel

ENV USER mpitest
ENV HOME /home/$USER
ENV MPI_DIR=/opt/ompi
ENV PATH="$MPI_DIR/bin:$HOME/.local/bin:$PATH"
ENV LD_LIBRARY_PATH="$MPI_DIR/lib:$LD_LIBRARY_PATH"
WORKDIR $HOME

RUN apt-get -q update && apt-get install -y python3 python3-dev python3-pip gcc gfortran binutils 
RUN pip3 install --upgrade pip 
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD https://download.open-mpi.org/release/open-mpi/v3.1/openmpi-3.1.2.tar.gz .
RUN tar -zxvf openmpi-3.1.2.tar.gz
RUN cd openmpi-3.1.2 && ./configure --prefix=$MPI_DIR
RUN make -j8 all && make install
RUN cd .. && rm -rf openmpi-3.1.2 openmpi-3.1.2.tar.gz /tmp/*

RUN groupadd -r mpitest \
    && useradd -r -g mpitest $USER \
    && chown -R mpitest:mpitest $HOME

USER $USER
RUN pip3 install --user -U setuptools && pip3 install --user mpi4py

# Test mpi
# >> mpiexec --version 
# >> mpirun --version
