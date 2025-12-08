FROM alpine AS src
WORKDIR /app
RUN apk add --no-cache curl
RUN curl -L -o go2rtc https://github.com/AlexxIT/go2rtc/releases/latest/download/go2rtc_linux_amd64 && \
    chmod +x go2rtc

FROM alpine:latest AS tz
RUN apk add --no-cache tzdata

# Health
FROM 11notes/distroless:localhealth AS distroless-localhealth

FROM scratch
COPY --chown=65532:65532 --from=src /app/go2rtc /app/go2rtc
COPY --chown=65532:65532 --from=tz /usr/share/zoneinfo/Asia/Ho_Chi_Minh /etc/localtime
COPY --chown=65532:65532 --from=distroless-localhealth / /

EXPOSE 1984 8555

HEALTHCHECK --interval=15s --timeout=2s --start-period=5s \
  CMD ["/usr/local/bin/localhealth", "http://127.0.0.1:1984/"]


USER 65532:65532

CMD ["/app/go2rtc", "-config", "/etc/go2rtc.yaml"]
