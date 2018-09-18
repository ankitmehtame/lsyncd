FROM alpine:3.8

RUN apk --no-cache add lsyncd

ENTRYPOINT ["lsyncd", "-nodaemon", "-delay", "0"]
