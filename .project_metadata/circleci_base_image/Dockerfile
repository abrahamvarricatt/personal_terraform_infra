FROM python:3.9.2

# Environment variables
ENV TERRAFORM_VERSION 0.15.5
ENV TFLINT_VERSION 0.29.0
ENV TFSEC_VERSION 0.39.42
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
    unzip

# install Terraform
RUN wget -q -O /terraform.zip "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" && \
    unzip /terraform.zip -d /usr/local/bin

# install checkov
RUN pip install checkov

# install tflint
RUN curl -L -o /tflint.zip "https://github.com/terraform-linters/tflint/releases/download/v${TFLINT_VERSION}/tflint_linux_amd64.zip" && \
    unzip /tflint.zip -d /usr/local/bin && \
    chmod +x /usr/local/bin/tflint

# install tfsec
RUN curl -L -o /usr/local/bin/tfsec "https://github.com/tfsec/tfsec/releases/download/v${TFSEC_VERSION}/tfsec-linux-amd64" && \
    chmod +x /usr/local/bin/tfsec

# install tfdocs
RUN curl -L -o /usr/local/bin/terraform-docs "https://github.com/terraform-docs/terraform-docs/releases/download/v${TERRAFORM_DOCS_VERSION}/terraform-docs-v${TERRAFORM_DOCS_VERSION}-linux-amd64" && \
    chmod +x /usr/local/bin/terraform-docs

# install pre-commit
RUN pip install pre-commit

# run forever
ENTRYPOINT tail -f /dev/null
