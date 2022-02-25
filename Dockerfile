ARG BASE_IMAGE=ghcr.io/cseelye/ubuntu-base


# First stage build container
FROM ${BASE_IMAGE} as builder

# Install pip
RUN apt-get update && \
    apt-get install --yes \
        python3-pip \
    && \
    apt-get autoremove --yes && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/log/apt/* /var/log/dpkg* && \
    pip --no-cache-dir --disable-pip-version-check install --upgrade pip && \
    pip --version

# Install ansible
RUN pip --no-cache-dir --disable-pip-version-check install --force-reinstall  --user \
        ansible==5.4.0 \
        ansible-core==2.12.2 \
        certifi

# Second stage the actual container
FROM ${BASE_IMAGE} as final

# Copy in the python packages from the builder image
COPY --from=builder /root/.local/ /root/.local/

# Install ansible modules
RUN ansible-galaxy collection install community.general
