#!/bin/zsh
# This script rebuilds the ubuntu-apache2-image docker image and restarts the container using the updated image.

IMAGE_NAME="ubuntu-apache2-image"
CONTAINER_NAME="ubuntu-apache2-container"

printf "Rebuilding the Docker image...\n"
docker build --build-arg BUILD_DATE="$(date)" --build-arg UNAME="$(uname)" --tag $IMAGE_NAME .

printf "Stopping and removing running test container based on the old image...\n"
if ! docker container stop "$CONTAINER_NAME"; then
  printf "Failed to stop the container: '%s'.\n" "$CONTAINER_NAME"
  exit 1
fi

if ! docker container rm "$CONTAINER_NAME"; then
  printf "Failed to remove the container: '%s'.\n" "$CONTAINER_NAME"
  exit 1
fi

printf "Starting a new container to test using the updated image...\n"
if docker container run --detach --interactive --tty --publish 80:80 --name $CONTAINER_NAME $IMAGE_NAME; then
  printf "Started container: %s\n" "$CONTAINER_NAME"
else
  printf "Failed to start the container. Exiting...\n"
  exit 1
fi
