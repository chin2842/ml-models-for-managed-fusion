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
ENV HF_HOME="/app/cache"
ENV MODEL_NAME="mini"  # Match this to the class name
ENV APP_MODULE="mini:mini"  # Correct reference to the module and class
ENV SERVICE_TYPE="MODEL"
ENV PERSISTENCE="0"

# Command to start the Seldon microservice
CMD ["sh", "-c", "seldon-core-microservice $MODEL_NAME --service-type $SERVICE_TYPE --persistence $PERSISTENCE"]