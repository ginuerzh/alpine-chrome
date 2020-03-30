FROM alpine:latest

# Installs Chromium and font package.
RUN echo @testing http://dl-cdn.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories \
    && apk add --no-cache \
    chromium \
    nss \
    font-noto \
    font-noto-cjk \
    font-noto-emoji@testing

# Add Chrome as a user
RUN mkdir -p /usr/src/app \
    && adduser -D chrome \
    && chown -R chrome:chrome /usr/src/app

COPY local.conf /etc/fonts

RUN fc-cache -f \
    && fc-list

# Run Chrome as non-privileged
USER chrome
WORKDIR /usr/src/app

ENV CHROME_BIN=/usr/bin/chromium-browser \
    CHROME_PATH=/usr/lib/chromium/

# Autorun chrome headless with no GPU
ENTRYPOINT ["chromium-browser", "--headless", "--disable-gpu", "--disable-software-rasterizer", "--disable-dev-shm-usage"]
