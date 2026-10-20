# Builds Kafka UI from this repo's source, so local UI changes show up.
# Build context is the repo root (see local/docker-compose.yml).

FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /src
COPY . .
RUN --mount=type=cache,target=/root/.m2 \
    mvn -B -ntp clean package -Pprod -DskipTests -Ddocker.skip=true -pl kafka-ui-api -am \
 && cp kafka-ui-api/target/kafka-ui-api-*.jar /kafka-ui-api.jar

FROM eclipse-temurin:17-jre-alpine
RUN apk add --no-cache gcompat tzdata \
 && addgroup -S kafkaui && adduser -S kafkaui -G kafkaui \
 && mkdir /etc/kafkaui && chown kafkaui /etc/kafkaui
USER kafkaui
COPY --from=build /kafka-ui-api.jar /kafka-ui-api.jar
ENV JAVA_OPTS=
EXPOSE 8080
CMD java --add-opens java.rmi/javax.rmi.ssl=ALL-UNNAMED $JAVA_OPTS -jar /kafka-ui-api.jar
