# Ubuntu 20.04 image
FROM ubuntu:focal-20210416 AS builder

# Environment variables
ENV TERRAFORM_VERSION 1.0.0
ENV TFLINT_VERSION 0.29.1
ENV TFSEC_VERSION 0.40.2
ENV TERRAFORM_DOCS_VERSION 0.14.1

# Add /usr/local/bin to $PATH
ENV PATH="/usr/local/bin:$PATH"

# update remote repositories
RUN apt-get update

# Install the following tools,
# wget - needed to download remote files
# unzip - unzip terraform
RUN apt-get install -y \
    wget \
    curl \
    unzip

# Setup a working directory
WORKDIR /usr/src

# Download and extract Terraform
RUN wget -q -O ./terraform.zip "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" && \
    unzip ./terraform.zip -d ./terraform

# Download and extract tflint
RUN curl -L -o ./tflint.zip "https://github.com/terraform-linters/tflint/releases/download/v${TFLINT_VERSION}/tflint_linux_amd64.zip" && \
    unzip ./tflint.zip -d ./tflint
RUN chmod +x ./tflint/tflint

# Download tfsec
RUN curl -L -o ./tfsec "https://github.com/tfsec/tfsec/releases/download/v${TFSEC_VERSION}/tfsec-linux-amd64" && \
    chmod +x ./tfsec

# Download and extract terraform docs
RUN curl -L -o ./terraform-docs.tar.gz "https://github.com/terraform-docs/terraform-docs/releases/download/v${TERRAFORM_DOCS_VERSION}/terraform-docs-v${TERRAFORM_DOCS_VERSION}-linux-amd64.tar.gz" && \
    mkdir ./terraform-docs && \
    tar -xvzf ./terraform-docs.tar.gz -C ./terraform-docs

# Setting up the base image
FROM ubuntu:focal-20210416 AS base_image

# Add /usr/local/bin to $PATH
ENV PATH="/usr/local/bin:$PATH"

# Setup a working directory
WORKDIR /usr/src

# Copy over the terraform binary
COPY --from=builder /usr/src/terraform/terraform /usr/local/bin/terraform

# Copy over tflint
COPY --from=builder /usr/src/tflint/tflint /usr/local/bin/tflint

# Copy over tfsec
COPY --from=builder /usr/src/tfsec /usr/local/bin/tfsec

# Copy over terraform-docs
COPY --from=builder /usr/src/terraform-docs/terraform-docs /usr/local/bin/terraform-docs

# # install checkov
# RUN pip install checkov

# # install pre-commit
# RUN pip install pre-commit

# # run forever
# ENTRYPOINT tail -f /dev/null
