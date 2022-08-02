1. Build base docker image: `docker build -t shell:latest .`
2. Run shell: `./start_shell.sh SHELL_ID PORT_RANGE` eg. `./start_shell.sh avodiet 8300-8320`
3. Add alias to your `.zshrc` file `alias avodiet="__PATH_TO_DOCKER_SHELL_REPO__/start_shell.sh avodiet 8300-8320"`
