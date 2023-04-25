FROM alpine/git as git
ARG REPO_ADDRESS
WORKDIR /git
RUN git clone $REPO_ADDRESS .

FROM graalvm-static-base:latest as nativeBuilder
WORKDIR /app
COPY --from=git /git .
RUN chmod +x mvnw && ./mvnw -Pnative package && ./mvnw -Pnative native:compile

FROM alpine:latest
ARG ARTIFACT_ID
ARG REPO_NAME
WORKDIR app
EXPOSE 8080
COPY --from=nativeBuilder /app/$REPO_NAME/target/$ARTIFACT_ID /app/exec
ENTRYPOINT ["/app/exec"]