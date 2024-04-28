# SRE Engineer Interview Exercise

## Exercise 1: Kubernetes
Duration: You should spend around 2 hours

As a potential SRE Engineer, your task is to containerize and to create a Helm Chart for a REST API application written 
in Python. The source code for the application is located under [password-generator](password-generator) folder.
Please, get familiar with the source code. The application generates secure passwords and takes as input parameters in the API request:
* minimum length
* number of special characters in the password
* number of numbers in the password
* number of passwords that must be created

You should consider high-availability while designing and deploying the Helm Chart.

Additionally, you must **be prepared to build and run the application** with the designed Helm Chart as a demo during 
the interview. The demo must include the following steps and should be no longer than 5 minutes:
* Build an image for the application
* Deploy the application in your local Kubernetes cluster with the developed Helm Chart
* Send an API call to the application and receive the generated passwords as a result 

## Exercise 2: Terraform
Duration: You should spend around 2 hours

Write Terraform code to provision an AWS EKS cluster or an Azure AKS cluster for the application in Exercise 1:
* Include the necessary resources for high-availability. Application running in the cluster must provide 99.97% uptime
* Follow principle of least privilege while designing networking, security groups and any related infrastructure components
* Ensure the Terraform code follows best practices, is well-documented, and can be easily executed

## Extra Credits Exercise
As an SRE Engineer, your challenge is to design a robust and efficient setup for blue/green deployment testing on a 
Kubernetes cluster for the API application from Exercise 1. The blue/green deployment strategy allows for seamless 
switching between two identical environments, referred to as the "blue" and "green" environments. 
The objective is to minimize downtime and ensure a smooth transition during software releases.
