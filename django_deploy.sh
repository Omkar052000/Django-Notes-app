#!/bin/bash

code_clone(){
	echo "Cloning Code..."
	git clone https://github.com/LondheShubham153/django-notes-app.git
}

install_requirements(){
	echo "Installing Requirements..."
	sudo chown $USER /var/run/docker.sock
	sudo apt update
	sudo apt-get install docker.io nginx -y
}

required_restarts(){
	echo "Enabling Services..."
	sudo systemctl enable docker
	sudo systemctl enable nginx
	sudo systemctl restart docker
}

deploy(){
	docker build -t notes-app .
	docker run -d -p 8000:8000 notes-app:latest
}

echo "********* DEPLOYMENT STARTED *********"

if ! code_clone; then
	echo "The code directory already exists"
	cd django-notes-app
fi

if ! install_requirements; then
	echo "Installation Failed"
	exit 1
fi

if ! required_restarts; then
	echo "System Fault"
	exit 1
fi

deploy

echo "********* DEPLOYMENT DONE *********"
