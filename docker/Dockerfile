FROM ubuntu:latest
ENV MY_NAME="yeshwanth"
ENV MY_COMPANY="linux-aws-devops"
LABEL Designedby="yesh" Email="yolaryeshwanth@gmail.com"
RUN apt update -y && apt install -y wget unzip net-tools tree vim nginx
RUN mkdir html
RUN wget https://downloads.wordpress.org/theme/medisat.1.0.3.zip
RUN rm -rf /var/www/html
RUN unzip medisat.1.0.3.zip -d /var/www/html
CMD ["nginx","-g","daemon off;"]



# Use a smaller base image
FROM ubuntu:latest 

# Set environment variables and metadata
ENV MY_NAME="yeshwanth" \
    MY_COMPANY="linux-aws-devops"
LABEL Designedby="yesh" Email="yolaryeshwanth@gmail.com"

# Install required packages and clean up
RUN apt update -y && \
    apt install -y wget unzip net-tools tree vim nginx && \
    rm -rf /var/lib/apt/lists/*

# Download and extract theme in one step
RUN wget -q https://downloads.wordpress.org/theme/medisat.1.0.3.zip -O /tmp/medisat.zip && \
    mkdir -p /var/www/html && \
    unzip /tmp/medisat.zip -d /var/www/html && \
    rm /tmp/medisat.zip

# Start Nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]








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
FROM nginx:latest

# Copy only the required files from the builder stage
COPY --from=builder /output /var/www/html

# Set CMD for Nginx
CMD ["nginx", "-g", "daemon off;"]