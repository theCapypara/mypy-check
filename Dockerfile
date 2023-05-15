ARG pyver=3.9

FROM python:$pyver

LABEL "maintainer"="Jacobi Petrucciani <j@cobi.dev>"

ADD entrypoint.sh /entrypoint.sh
ADD github.py /github.py
ADD _manylinux.py /usr/local/lib/python3.9/_manylinux.py

RUN apt-get update && apt-get install -y \
    bash gcc musl-dev \
    && rm -rf /var/lib/apt/lists/*

RUN pip install -U pip && \
    pip install --upgrade mypy

## RUST
ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        gcc \
        libc6-dev \
        wget \
        ; \
    \
    url="https://static.rust-lang.org/rustup/dist/x86_64-unknown-linux-gnu/rustup-init"; \
    wget "$url"; \
    chmod +x rustup-init; \
    ./rustup-init -y --no-modify-path --default-toolchain nightly; \
    rm rustup-init; \
    chmod -R a+w $RUSTUP_HOME $CARGO_HOME; \
    rustup --version; \
    cargo --version; \
    rustc --version; \
    \
    apt-get remove -y --auto-remove \
        wget \
        ; \
    rm -rf /var/lib/apt/lists/*;
## RUST END

## GTK SUPPORT
RUN apt-get update && apt-get install -y \
    libgirepository1.0-dev \
    && rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/entrypoint.sh"]
