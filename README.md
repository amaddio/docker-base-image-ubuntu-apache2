# Base Image for Ubuntu 24.04 and Apache2

## Commands to Build, Run and Access a Running Container

```sh
docker build --tag ubuntu-apache2-image .
docker container run --detach --interactive --tty --publish 80:80 --name ubuntu-apache2-container ubuntu-apache2-image
docker container exec -it ubuntu-apache2-container /bin/bash
docker container list
docker stop ubuntu-apache2-container
docker container rm my_test_container
```

Browse the running container at http://localhost:80.
