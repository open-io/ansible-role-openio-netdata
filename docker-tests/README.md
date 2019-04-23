# Docker test environment

1. Fetch the test branch: `git fetch origin docker-tests`
2. Create a Git worktree for the test code: `git worktree add docker-tests docker-tests`. This will create a directory `docker-tests/`
3. The script `docker-tests.sh` will create a Docker container, and apply this role from a playbook `<test.yml>`. The Docker images are configured for testing Ansible roles and are published at <https://hub.docker.com/r/cdelgehier/docker_images_ansible/>. There are images available for several distributions and versions. The distribution and version should be specified outside the script using environment variables:

    ```
    DISTRIBUTION=centos VERSION=7 ANSIBLE_VERSION=2.5 ./docker-tests/docker-tests.sh
    DISTRIBUTION=ubuntu VERSION=16.04 ANSIBLE_VERSION=2.5 ./docker-tests/docker-tests.sh
    ```
4. You can test another use case by adding an argument to the script. An argument `<another>` will apply a playbook `<another.yml>`

5. You can run functionnal tests locally like that:

    ```
    SUT_ID=9acda29c356b ./docker-tests/functional-tests.sh
    SUT_IP=172.17.0.2   ./docker-tests/functional-tests.sh
    ```
   
The specific combinations of distributions and versions that are supported by this role are specified in `.travis.yml`.
