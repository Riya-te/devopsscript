#!/bin/bash

sudo apt-get update
sudo apt-get install -y nginx
sudo systemctl start nginx
sudo systemctl enable nginx

echo "<h1>Welcome to Terraform class</h1>" | sudo tee /var/www/html/index.html