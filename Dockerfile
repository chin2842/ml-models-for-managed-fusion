FROM python:3.9-slim

# Create a dedicated user for your application
RUN useradd -ms /bin/bash appuser

# Set working directory and environment variables
WORKDIR /app
ENV HF_HOME="/app/cache"
ENV TRANSFORMERS_CACHE="/app/cache"
ENV MODEL_NAME mini
ENV SERVICE_TYPE MODEL
ENV PERSISTENCE 0

# Create the cache directory and set ownership
RUN mkdir -p /app/cache && chown appuser:appuser /app/cache

# Copy requirements.txt and set ownership
COPY requirements.txt /app/requirements.txt
RUN chown appuser:appuser /app/requirements.txt

# Install dependencies as the dedicated user
USER appuser
RUN pip install --no-cache-dir -r requirements.txt

# Expose the required port
EXPOSE 5000

# Command to start the Seldon microservice
CMD ["sh", "-c", "seldon-core-microservice $MODEL_NAME --service-type $SERVICE_TYPE --persistence $PERSISTENCE"]