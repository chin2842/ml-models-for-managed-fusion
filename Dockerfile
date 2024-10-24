# Use a slim Python 3.9 image
FROM python:3.9-slim

# Copy the entire application into /app
COPY . /app
WORKDIR /app

# Set up cache directory
RUN mkdir -p /.cache/huggingface/hub && \
    chown -R 8888 /.cache

# Install the requirements
COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Expose the required port
EXPOSE 5000

# Define environment variables
ENV TRANSFORMERS_CACHE="/.cache/huggingface/hub"
ENV MODEL_NAME mini  # Match this to the class name
ENV APP_MODULE mini:mini  # Correct reference to the module and class
ENV SERVICE_TYPE MODEL
ENV PERSISTENCE 0

# Change ownership of the /app directory
RUN chown -R 8888 /app

# Command to start the Seldon microservice
CMD ["seldon-core-microservice", "$MODEL_NAME", "--service-type", "$SERVICE_TYPE", "--persistence", "$PERSISTENCE"]