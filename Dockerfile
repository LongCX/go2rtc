FROM alpine AS src
WORKDIR /app
RUN apk add --no-cache curl
RUN curl -L -o go2rtc https://github.com/AlexxIT/go2rtc/releases/latest/download/go2rtc_linux_amd64 && \
    chmod +x go2rtc

FROM gcr.io/distroless/base-debian12:nonroot
COPY --chown=nonroot:nonroot --from=src /app/go2rtc /app/go2rtc

USER nonroot

ENV TZ=Asia/Ho_Chi_Minh

EXPOSE 1984 8555

CMD ["/app/go2rtc", "-config", "/etc/go2rtc.yaml"]