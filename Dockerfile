# Use a slim Python 3.9 image
FROM python:3.9-slim

# Copy the entire application into /app
COPY . /app
WORKDIR /app

# Set up cache directory
RUN mkdir -p /app/cache && \
    chown -R 8888 /app/cache

# Install the requirements
COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Expose the required port
EXPOSE 5000

# Define environment variables
ENV HF_HOME="/app/cache"  # Updated environment variable
ENV TRANSFORMERS_CACHE="/app/cache"  # Set this to a writable cache directory
ENV MODEL_NAME mini  # Match this to the class name
ENV SERVICE_TYPE MODEL
ENV PERSISTENCE 0

# Change ownership of the /app directory
RUN chown -R 8888 /app

# Command to start the Seldon microservice
CMD ["sh", "-c", "seldon-core-microservice $MODEL_NAME --service-type $SERVICE_TYPE --persistence $PERSISTENCE"]
