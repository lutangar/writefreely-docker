FROM golang:1.21.12-alpine

WORKDIR /app

RUN apk add --update-cache \
    writefreely \
  && rm -rf /var/cache/apk/*

COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

RUN cp /etc/writefreely/config.ini /app/config.ini
RUN writefreely keys generate
RUN writefreely db init

ENTRYPOINT ["/app/entrypoint.sh"]

CMD ["writefreely"]