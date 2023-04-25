FROM native-image-offline
COPY ./temp /app
WORKDIR /app
# update last command to your repo
ENTRYPOINT ./mvnw -Pnative package native:compile && /app/target/spring-websocket-demo