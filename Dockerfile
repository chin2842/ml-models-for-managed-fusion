# Use a slim Python 3.9 image
FROM python:3.9-slim

# Set a working directory
WORKDIR /app

# Copy the entire application into /app
COPY . .

# Set up cache directory
RUN mkdir -p /app/cache && \
    chown -R 8888 /app/cache

# Install the requirements
COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Change ownership of the /app directory
RUN chown -R 8888 /app

# Expose the required port
EXPOSE 5000

# Define environment variables
ENV HF_HOME=/app/cache \
    MODEL_NAME=mini \
    APP_MODULE=mini:mini \
    SERVICE_TYPE=MODEL \
    PERSISTENCE=0

# Command to start the Seldon microservice
CMD ["seldon-core-microservice", "mini", "--service-type", "MODEL", "--persistence", "0"]
