
# Password Generator App Deployment

## Dockerfile
This project includes a Dockerfile for building a lightweight Python-based container for a Flask application:

```Dockerfile
# Use an official lightweight Python image
FROM python:3.10-slim

# Set the working directory in the container to /app
WORKDIR /app

# Copy the local directory contents to the /app directory in the container
COPY  password-generator /app

# Install the Flask requirement 
RUN pip install flask

# Make port 5000 available to the world outside of this container
EXPOSE 5000

# Set environment variables
ENV FLASK_APP main.py
ENV FLASK_DEBUG 1

# Run app.py when the container launches
CMD ["flask", "run", "--host=0.0.0.0"]
```

## Helm Chart
This project uses a Helm chart called "password-generator-chart". Below is the `values.yaml` for the Helm chart:

```yaml
# Default values for password-generator-chart.
# This is a YAML-formatted file.
# Declare variables to be passed into your templates.

replicaCount: 3

environment: "blue" # blue or green

image:
  repository: password-generator-image
  pullPolicy: IfNotPresent
  tag: "latest"

# Other configurations...
```

### How to Deploy the Application Using Minikube

1. **Start Minikube**: 
   ```bash
   minikube start
   ```

2. **Build the Docker Image**:
   Make sure Minikube's Docker environment is configured and build the image:
   ```bash
   eval $(minikube docker-env)
   cd ../
   docker build --no-cache -t password-generator-image:blue -f exercise1/Dockerfile .

   # or
   docker build --no-cache -t password-generator-image:green -f exercise1/Dockerfile .
   ```

### Example of Blue/Green Deployment

1. **Deploy Blue Environment**:
   ```bash
   helm upgrade --install password-generator --create-namespace --namespace password-generator-app password-generator-chart/ --debug --set environment=blue,image.tag="blue"
   ```

2. **Deploy Green Environment**:
   ```bash
   helm install password-generator ./password-generator-chart --set environment=green,image.tag="1.1.0"
   ```

3. **Switch Traffic**:
   Update your DNS or load balancer to point to the green service instead of the blue.

4. **Clean Up**:
   Delete the blue deployment after switching traffic:
   ```bash
   helm delete password-generator-blue
   ```

This way, you can perform a blue/green deployment with minimal disruption.
