#It is important that python version is 3.x-slim for seldon-core
FROM python:3.9-slim
# Whatever directory(folder)the python file for your python class, Dockerfile, and
# requirements.txt is in should be copied then denoted as the work directory.
COPY . /app
WORKDIR /app

# The requirements file for the Docker container
COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Copy source code
COPY . .

# GRPC - Allows Managed Fusion to do a Remote Procedure Call
EXPOSE 5000

# Define environment variable for seldon-core
# !!!MODEL_NAME must be the EXACT same as the python file & python class name!!!
ENV MODEL_NAME mini
ENV SERVICE_TYPE MODEL
ENV PERSISTENCE 0

# Changing active directory folder (same one as above on lines 5 & 6) to default user, required for Managed Fusion
RUN chown -R 8888 /app

# Command to wrap python class with seldon-core to allow it to be usable in Managed Fusion
CMD ["sh", "-c", "seldon-core-microservice $MODEL_NAME --service-type $SERVICE_TYPE --persistence $PERSISTENCE"]

# You can use the following if You need shell features like environment variable expansion or
# You need to use shell constructs like pipes, redirects, etc.
# See https://docs.docker.com/reference/dockerfile/#cmd for more details.
# CMD exec seldon-core-microservice $MODEL_NAME --service-type $SERVICE_TYPE --persistence $PERSISTENCE