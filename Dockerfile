# Container image that runs your code
FROM dataeditors/stata17:2021-12-16

USER root
# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.sh /entrypoint.sh
RUN ["chmod", "+x", "/entrypoint.sh"]

# add the statauser to sudo so can update license
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y \
         sudo \
    && echo "statauser  ALL=(ALL) NOPASSWD:ALL" | \
       tee /etc/sudoers.d/statauser

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]
#USER statauser

