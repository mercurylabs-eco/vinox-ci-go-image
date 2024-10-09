ARG GOLANG_TAG=1.19-bullseye

FROM golang:${GOLANG_TAG}

RUN apt-get update && apt install unzip xz-utils openjdk-11-jre-headless jq -y

WORKDIR /tmp

# Install SAM CLI
RUN wget -q "https://github.com/aws/aws-sam-cli/releases/download/v1.39.0/aws-sam-cli-linux-x86_64.zip" \
    && unzip -q aws-sam-cli-linux-x86_64.zip -d sam-installation \
    && ./sam-installation/install

# Install AWS CLI
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip -q awscliv2.zip \
    && ./aws/install

# Install golangci-lint
RUN go install github.com/golangci/golangci-lint/cmd/golangci-lint@v1.44.2

# Install Zig
RUN curl -o zig.tar.xz https://ziglang.org/builds/zig-linux-x86_64-0.14.0-dev.1820+ea527f7a8.tar.xz \
    && mkdir /usr/lib/zig && tar xf zig.tar.xz -C /usr/lib/zig --strip-components=1 \
    && ln -s /usr/lib/zig/zig /usr/bin/zig

ENV PATH=$PATH:/usr/bin/zig

RUN rm -rf /tmp/*