FROM alpine AS src
WORKDIR /app
RUN apk add --no-cache curl
RUN curl -L -o go2rtc https://github.com/AlexxIT/go2rtc/releases/latest/download/go2rtc_linux_amd64 && \
    chmod +x go2rtc

FROM alpine:latest AS tz
RUN apk add --no-cache tzdata

FROM scratch
COPY --chown=65532:65532 --from=src /app/go2rtc /app/go2rtc
COPY --chown=65532:65532 --from=tz /usr/share/zoneinfo/Asia/Ho_Chi_Minh /etc/localtime

EXPOSE 1984 8555

USER 65532:65532

CMD ["/app/go2rtc", "-config", "/etc/go2rtc.yaml"]
