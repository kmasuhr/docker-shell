#!/usr/bin/env zsh

name=$1
name_lower=$(echo $name | tr A-Z a-z)
name_upper=$(echo $name | tr a-z A-Z)

docker_container_name="shell_${name_lower}"

shell_path="/Users/karol.masuhr/work_shell/${name_lower}"

if [ ! "$(docker ps -q -f name="$docker_container_name")" ]; then
    if [ "$(docker ps -aq -f status=exited -f name="$docker_container_name")" ]; then
        docker rm "$docker_container_name"
    fi

    mkdir -p ${shell_path}
    docker run -itd -e PROMPT_PREFIX=${name_upper} -v /var/run/docker.sock:/var/run/docker.sock -v ${shell_path}:/root --name "$docker_container_name" shell zsh
fi

docker exec -it "$docker_container_name" zsh
