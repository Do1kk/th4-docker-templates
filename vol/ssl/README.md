# README

You need to create and add your certificates into this folder and update the `certs.conf` file.

For self sign:

`sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout nginx-selfsigned.key -out nginx-selfsigned.crt`