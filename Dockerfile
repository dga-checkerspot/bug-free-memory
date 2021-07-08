FROM ubuntu:18.04
ENV PATH="/root/miniconda3/bin:${PATH}"
ARG PATH="/root/miniconda3/bin:${PATH}"
RUN apt-get update

RUN apt-get install -y wget && rm -rf /var/lib/apt/lists/*



RUN wget \
    https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && mkdir /root/.conda \
    && bash Miniconda3-latest-Linux-x86_64.sh -b \
    && rm -f Miniconda3-latest-Linux-x86_64.sh 
RUN conda --version

RUN conda config --add channels defaults
RUN conda config --add channels bioconda
RUN conda config --add channels conda-forge

RUN conda install -c anaconda git 
RUN mkdir -p /opt/augustus/scripts/ \
	&& mv ./Augustus/scripts/* /opt/augustus/scripts/ \
	&& mv /Augustus/docs/tutorial2018/BRAKER_v2.0.4+/*.pl /opt/augustus/scripts/ \
	&& chmod 777 /opt/augustus/scripts/*


ENV PATH="/opt/augustus/scripts:${PATH}"

RUN conda install kallisto

RUN conda update --all