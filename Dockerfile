FROM alpine:3

EXPOSE 25 80
VOLUME /etc/letsencrypt

# Install system dependencies.
RUN apk add --update --no-cache \
    # Postfix itself:
    postfix postfix-pgsql \
    # To generate Postfix config files:
    python3 \
    # To generate and renew Postfix TLS certificate:
    certbot \
    dcron

# Install Python dependencies.
RUN python3 -m ensurepip
RUN pip3 install jinja2

# Copy sources.
ADD generate_config.py /src/
ADD scripts/certbot-renew-crontab.sh /etc/periodic/hourly/renew-postfix-tls
ADD scripts/certbot-renew-posthook.sh /etc/letsencrypt/renewal-hooks/post/reload-postfix.sh
ADD templates /src/templates

# Generate config, ask for a TLS certificate to Let's Encrypt, start Postfix and Cron daemon.
WORKDIR /src
CMD ./generate_config.py --certbot && certbot -n certonly; crond && ./generate_config.py --postfix && postfix start-fg

# Idea taken from https://github.com/Mailu/Mailu/blob/master/core/postfix/Dockerfile
HEALTHCHECK --start-period=350s CMD echo QUIT|nc localhost 25|grep "220 .* ESMTP Postfix"
