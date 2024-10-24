# Use the slim version of Python
FROM python:3.9-slim

# Set the working directory
WORKDIR /app

# Copy the necessary files
COPY mini.py /app/mini.py
COPY requirements.txt /app/requirements.txt

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Set environment variables for Seldon Core
ENV MODEL_NAME mini
ENV SERVICE_TYPE MODEL
ENV PERSISTENCE 0

# Set APP_FILE and APP_MODULE
ENV APP_FILE mini.py  # Specify the main file
ENV APP_MODULE mini:App  # Specify the module and the callable class

# Expose the necessary port
EXPOSE 5000

# Command to run the Seldon Core microservice
CMD ["sh", "-c", "seldon-core-microservice $MODEL_NAME --service-type $SERVICE_TYPE --persistence $PERSISTENCE"]