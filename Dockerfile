FROM amd64/debian:wheezy

RUN apt-get update && apt-get install -y locales

# Ensure UTF-8 locale
ENV LANGUAGE="en_US.UTF-8" LANG="en_US.UTF-8" LC_ALL="en_US.UTF-8"
RUN sed -i 's/^# *\(en_US.UTF-8\)/\1/' /etc/locale.gen && locale-gen

RUN apt-get install -y wget git bash make bzip2 supervisor

# switch from dash to bash to make "source activate" work
RUN echo "dash dash/sh boolean false" | debconf-set-selections && \
    DEBIAN_FRONTEND=noninteractive dpkg-reconfigure dash

# install and configure miniconda
RUN wget http://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh && \
    chmod +x miniconda.sh && ./miniconda.sh -b && rm -r ./miniconda.sh

ENV PATH "/root/miniconda3/bin/:${PATH}"

RUN conda config --set always_yes yes --set changeps1 no && \
    conda config --append channels conda-forge

# Install Anaconda Python 3 distribution (for Python)
# and all the dependencies
RUN git clone --depth=1 https://github.com/FreeDiscovery/FreeDiscovery.git &&\
    cd FreeDiscovery/ &&\
    git checkout 8c8338a0c73cea5eca38cffab6972c6ae3949574 && \ 
    conda install --yes --file ./requirements_engine.txt python=3.6 &&\
    pip install . && cd .. && rm -r FreeDiscovery/

COPY build_tools/docker/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

ADD . /fd_shared/

WORKDIR /fd_shared/

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
