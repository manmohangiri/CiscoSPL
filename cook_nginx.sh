#! /bin/bash
sudo apt-get update
sudo apt-get install -y nginx
sudo systemctl start nginx
sudo systemctl enable nginx
echo "Cisco SPL" | sudo tee /var/www/html/index.nginx-debian.html
echo "Run Completed"
