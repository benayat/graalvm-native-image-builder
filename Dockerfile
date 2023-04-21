FROM ghcr.io/graalvm/graalvm-ce:latest as builder
WORKDIR /app
ARG GIT_PREFIX
ARG USER_NAME
ARG REPO_NAME
ARG ARTIFACT_ID
RUN microdnf install -y git
RUN git clone $GIT_PREFIX/$USER_NAME/$REPO_NAME.git
WORKDIR $REPO_NAME
RUN chmod +x mvnw && ./mvnw -Pnative package native:compile && cp ./target/$ARTIFACT_ID /app/exec
ENTRYPOINT /app/exec