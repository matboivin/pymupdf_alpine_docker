# syntax=docker/dockerfile:1

FROM python:3.10-alpine3.16

ARG PYMUPDF_VERSION=1.20.1

RUN apk update \
    && apk add --update --no-cache \
        build-base \
        gcc \
        jbig2dec \
        jpeg-dev \
        harfbuzz-dev \
        libc-dev \
        mupdf-dev \
        musl-dev \
        openjpeg-dev \
        swig \
    && ln -s /usr/lib/libjbig2dec.so.0 /usr/lib/libjbig2dec.so
# Without this link, jbig2dec is not found

# Install PyMuPDF (will take a few minutes) without pip
# MuPDF 1.20.0 is automatically downloaded at build
WORKDIR /tmp
RUN wget https://github.com/pymupdf/PyMuPDF/archive/refs/tags/${PYMUPDF_VERSION}.tar.gz \
    && tar -xzf ${PYMUPDF_VERSION}.tar.gz \
    && rm ${PYMUPDF_VERSION}.tar.gz \
    && cd PyMuPDF-${PYMUPDF_VERSION} \
    && python setup.py build && python setup.py install

RUN apk del gcc build-base

# ENTRYPOINT ["your", "entrypoint"]
