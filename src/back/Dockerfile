FROM python:3.10-slim-buster

WORKDIR /python-docker

COPY requirements.txt requirements.txt
RUN pip3 install -r requirements.txt

RUN apt-get update && apt-get upgrade -y

# Install driver for pyodbc
RUN apt-get install unixodbc -y

COPY . .