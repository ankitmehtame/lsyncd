# Lsyncd Dockerfile
Dockerfile for the [Live Syncing Daemon](https://github.com/axkibe/lsyncd).

## Usage
Syncing a host directory with a container directory via `rsync`:

```sh
docker run --rm -it -v "$PWD:$PWD" allthings/lsyncd -rsync "$PWD" /srv/www
```

Syncing multiple directories via `rsync`:

```sh
docker run --rm -it allthings/lsyncd -rsync /src/1 /dst/1 -rsync /src/2 /dst/2
```

## License
Released under the [MIT license](https://opensource.org/licenses/MIT).
