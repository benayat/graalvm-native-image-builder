FROM native-image-offline
COPY ./temp /app
WORKDIR /app
ENTRYPOINT ./mvnw -Pnative package native:compile && /app/target/spring-websocket-demo