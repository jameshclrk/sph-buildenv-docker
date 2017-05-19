FROM jameshclrk/petsc:latest

MAINTAINER James Clark <james.clark@stfc.ac.uk>

ARG ZOLTAN_VERSION=3.83
ARG ZOLTAN_INSTALL_PATH=/opt/zoltan
ARG JUDY_VERSION=1.0.5

RUN set -x \
    && curl -fSL "https://downloads.sourceforge.net/project/judy/judy/Judy-${JUDY_VERSION}/Judy-${JUDY_VERSION}.tar.gz" -o judy.tar.gz \
	&& mkdir -p /usr/src/judy \
	&& tar -xf judy.tar.gz -C /usr/src/judy --strip-components=1 \
	&& rm judy.tar.gz* \
	&& cd /usr/src/judy \
	&& ./configure \
	&& make \
    && make install \
    && ldconfig \
    && rm -rf /usr/src/judy

RUN set -x \
    && curl -fSL "http://www.cs.sandia.gov/~kddevin/Zoltan_Distributions/zoltan_distrib_v${ZOLTAN_VERSION}.tar.gz" -o zoltan.tar.gz \
	&& mkdir -p /usr/src/zoltan \
	&& tar -xf zoltan.tar.gz -C /usr/src/zoltan --strip-components=1 \
	&& rm zoltan.tar.gz* \
	&& cd /usr/src/zoltan \
    && mkdir build \
    && cd build \
	&& ../configure \
        --prefix=${ZOLTAN_INSTALL_PATH} \
        --enable-f90interface \
        --enable-mpi \
        --with-gnumake \
	&& make everything \
    && make install \
    && rm -rf /usr/src/zoltan

ENV PATH="${ZOLTAN_INSTALL_PATH}/bin:${PATH}" LD_LIBRARY_PATH="${ZOLTAN_INSTALL_PATH}/lib:${LD_LIBRARY_PATH}" 
ENV ZOLTAN_DIR="${ZOLTAN_INSTALL_PATH}"
