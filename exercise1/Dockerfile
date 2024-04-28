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