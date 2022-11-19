#!/usr/bin/env bash

#SBATCH --job-name="load docker image"
#SBATCH --time=01:00:00
#SBATCH --mem-bind=local
#SBATCH --nodes=1-1
#SBATCH --ntasks=1
#SBATCH --ntasks-per-socket=1

DOCKER_IMAGE=$1

echo "-- Node $HOSTNAME"

# -- SET UP ENVIRONMENT (define flapy_docker_command)
echo "-- Prepare for docker command"
source prepare_for_docker_command.sh || exit

echo "-- Loading image ${DOCKER_IMAGE}"
date -Iseconds
flapy_docker_command load -i "${DOCKER_IMAGE}"
date -Iseconds

echo "-- Echo image+container info"
./echo_flapy_docker_info.sh

echo "-- $0: Done!"
