# Stage 1: Build stage
FROM ubuntu:latest AS builder
ENV MY_NAME="yeshwanth"
ENV MY_COMPANY="linux-aws-devops"
LABEL Designedby="yesh" Email="yolaryeshwanth@gmail.com"

# Install necessary tools
RUN apt update -y && apt install -y wget unzip

# Download and extract the WordPress theme
RUN wget https://downloads.wordpress.org/theme/medisat.1.0.3.zip
RUN mkdir /output && unzip medisat.1.0.3.zip -d /output

# Stage 2: Final stage
FROM nginx:alpine

# Copy only the required files from the builder stage
COPY --from=builder /output /var/www/html

# Set CMD for Nginx
CMD ["nginx", "-g", "daemon off;"]