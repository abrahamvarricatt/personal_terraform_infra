FROM python:3.9.2

# Environment variables
ENV TERRAFORM_VERSION 0.14.9

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

# run forever
ENTRYPOINT tail -f /dev/null
