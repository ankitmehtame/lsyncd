# Difference between original and forked
Added docker images for amd64, arm and arm64

# Lsyncd Dockerfile
Dockerfile for the [Live Syncing Daemon](https://github.com/axkibe/lsyncd).

This Docker image is intended to improve file system performance on
[Docker for Mac](https://docs.docker.com/docker-for-mac/) by syncing host mounts
with named volumes.

This only provides one-way-sync.  
For setups that only occasionally require a reverse sync, a sample approach is
provided in the [Reverse sync](#reverse-sync) section.  
For setups that require two-way-sync, please have a look at
[docker-sync](http://docker-sync.io/).

See also:
[Performance tuning for volume mounts](https://docs.docker.com/docker-for-mac/osxfs-caching/)

## Usage

### With Docker Compose
See the sample [docker-compose.yml](docker-compose.yml).

### Without Docker Compose
Create a named volume:

```sh
docker volume create html
```

Start lsyncd to sync the host directory with the named volume:

```sh
docker run \
  -d \
  -v "$PWD/html:/mnt/html" \
  -v html:/var/www/html \
  --name lsyncd \
  allthings/lsyncd \
  -rsync /mnt/html /var/www/html
```

Start a web server using the named volume:

```sh
docker run \
  -d \
  -v html:/var/www/html \
  -p 80:80 \
  --name web \
  php:apache
```

Add and remove files in the `html` directory and reload http://localhost/ to see
them being synced with the named volume.

To remove the containers and the named volume, execute the following:

```sh
docker rm -vf lsyncd web
docker volume rm html
```

## Lsyncd documentation
For additional documentation, e.g. how to sync multiple directories or how to
use a config file to apply rsync options, please consult the
[lsyncd manual](https://axkibe.github.io/lsyncd/).

## Performance comparison
Start up the container set:

```sh
docker-compose up -d
```

Generate some extra data by duplicating this file into the `html` directory:

```sh
seq -f %04g 1000 | xargs -I% cp README.md html/%.md
```

Run a benchmark against the web server using a standard host mount:

```sh
docker-compose exec web ab -n 100 web2/
```

Run a benchmark against the web server using a synced named volume:

```sh
docker-compose exec web2 ab -n 100 web/
```

Remove the generated data:

```sh
rm -rf html/*.md
```

Stop the container set:

```sh
docker-compose down -v
```

## Reverse sync
To sync files back from the named volume to the host mount, a sample shell
script is provided, that stops `lsyncd`, syncs the given directories and
restarts `lsyncd` again.

It can be used the following way:

```sh
./lsyncd-rsync.sh /var/www/html/ /mnt/html/
```

Please note that the trailing slashes are required by `rsync`, which is used for
the synchronization.

## License
Released under the [MIT license](https://opensource.org/licenses/MIT).
