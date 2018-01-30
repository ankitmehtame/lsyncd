FROM alpine:3.7

RUN apk --no-cache add lsyncd

ENTRYPOINT ["lsyncd", "-nodaemon", "-delay", "0"]
