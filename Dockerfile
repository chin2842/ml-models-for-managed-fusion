# Use a slim Python 3.9 image
FROM python:3.9-slim

# Set working directory
WORKDIR /app

# Copy the application files into /app
COPY . /app

# Set up cache directory and change ownership
RUN mkdir -p /app/cache && \
    chown -R 8888 /app/cache

# Install the requirements
COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Expose the required port
EXPOSE 5000

# Define environment variables
ENV HF_HOME="/app/cache"
ENV TRANSFORMERS_CACHE="/app/cache"
ENV MODEL_NAME="mini"
ENV SERVICE_TYPE="MODEL"
ENV PERSISTENCE="0"

# Change ownership of the /app directory
RUN chown -R 8888 /app

# Command to start the Seldon microservice
CMD ["sh", "-c", "seldon-core-microservice $MODEL_NAME --service-type $SERVICE_TYPE --persistence $PERSISTENCE"]