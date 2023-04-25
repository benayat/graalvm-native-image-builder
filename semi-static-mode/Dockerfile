FROM alpine/git as git
ARG GIT_PREFIX
ARG USER_NAME
ARG REPO_NAME
WORKDIR /git
RUN git clone $GIT_PREFIX/$USER_NAME/$REPO_NAME.git .

FROM ghcr.io/graalvm/native-image:latest as nativeBuilder
WORKDIR /app
COPY --from=git /git .
RUN chmod +x mvnw && ./mvnw -Pnative package native:compile

FROM frolvlad/alpine-glibc
ARG ARTIFACT_ID
WORKDIR app
EXPOSE 8080
COPY --from=nativeBuilder /app/target/$ARTIFACT_ID /app/exec
ENTRYPOINT ["/app/exec"]