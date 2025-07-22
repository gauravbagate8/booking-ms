FROM openjdk:17-jdk-slim

# Create app directory
WORKDIR /app

# Copy JAR file
COPY ./target/booking-ms*.jar app.jar

# Expose port (optional, for info)
EXPOSE 8080

# Run Spring Boot app
ENTRYPOINT ["java", "-jar", "app.jar"]

# Install Java 17
RUN apt-get update && \
    apt-get install -y openjdk-17-jdk && \
    apt-get clean;

# Set Java 17 as the default Java version
RUN update-alternatives --set java /usr/lib/jvm/java-17-openjdk-amd64/bin/java && \
    update-alternatives --set javac /usr/lib/jvm/java-17-openjdk-amd64/bin/javac

# Clean default webapps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy the War file into the Tomcat webapps directory
COPY ./target/booking-ms.jar /usr/local/tomcat/webapps

# Set the user
USER booking-ms

# Set the working directory
WORKDIR /usr/local/tomcat/webapps

# Start Tomcat
CMD ["catalina.sh", "run"]