#!/bin/bash

echo "Build the docker"

docker build . --progress=plain \
               -t mgaloto/flexdash_high:01

if [[ $? = 0 ]] ; then
echo "Pushing docker..."
docker push mgaloto/flexdash_high:01
else
echo "Docker build failed"
fi