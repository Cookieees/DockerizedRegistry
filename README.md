# DockerizedRegistry
This is one of many solutions to the https://hackattic.com/challenges/dockerized_solutions

## Prerequisites
You will need a token to get the secret.
You can get this token by logging in to the hackattic and visiting [page](https://hackattic.com/challenges/dockerized_solutions). 
On this page, in the "Getting the problem set" section, you will see a GET request with the "access_token" parameter, get it.

You also, of course, need to have Docker and ... docker-compose (don't ask me, just coz) installed.
And finally you'll need unzip installed, for unzip downloaded repository containing solution. Or you just can download .sh and .yml files manually

## Getting a secret
```
wget -qO main.zip https://github.com/Cookieees/DockerizedRegistry/archive/refs/heads/main.zip && unzip main.zip && cd DockerizedRegistry-main && sudo chmod +x ./getSecret.sh && bash ./getSecret.sh
```
## Important note
Please note that currently it is not possible to get the secret, due to errors on the resolver server (HTTP500)
