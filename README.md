## Starting the container

Docker run

```shell
docker run --rm \
    --name lidarr \
    -p 8686:8686 \
    -e PUID=1000 \
    -e PGID=1000 \
    -e UMASK=002 \
    -e TZ="Etc/UTC" \
    -v /<host_folder_config>:/config \
    -v /<host_folder_data>:/data \
    docker.io/tainrs/lidarr
```

Docker compose:

```yaml
services:
    lidarr:
    container_name: lidarr
    image: docker.io/tainrs/lidarr
    ports:
        - "8686:8686"
    environment:
        - PUID=1000
        - PGID=1000
        - UMASK=002
        - TZ=Etc/UTC
    volumes:
        - /<host_folder_config>:/config
        - /<host_folder_data>:/data
```
