FROM        edyan/php:7.2

ARG         SATISFY_VERSION=3.2.4

COPY        --from=composer:1 /usr/bin/composer /usr/bin/composer

RUN         apt update -qq && apt install -qq --yes git unzip zip && \
            # Download satisfy
            git clone \
                --branch ${SATISFY_VERSION} \
                --single-branch \
                https://github.com/ludofleury/satisfy.git /app && \
            # Install App
            cd /app && rm -rf .git && \
            composer global require --no-ansi hirak/prestissimo && \
            composer install --no-dev --prefer-dist --no-progress --no-suggest --no-ansi && \
            composer global remove --no-ansi hirak/prestissimo && \
            # Setup env for www-data
            echo 'variables_order = "EGPCS"' >> /etc/php/current/cli/conf.d/30-custom-php.ini && \
            printf "[credential]\n    helper = store\n" > /home/www-data/.gitconfig && \
            chown -R www-data:www-data /app /home/www-data && \
            # Clean
            composer clear-cache && \
            apt autoremove --yes --purge && apt autoclean && apt clean && \
            # Empty some directories from all files and hidden files
            rm -rf /tmp/* && \
            find /root /var/lib/apt/lists /usr/share/man /usr/share/doc /var/cache /var/log -type f -delete


WORKDIR     /app
VOLUME      ["/build"]
EXPOSE      8080

# At the end as it changes everytime ;)
ARG         BUILD_DATE
ARG         DOCKER_TAG
ARG         VCS_REF
LABEL       maintainer="Emmanuel Dyan <emmanueldyan@gmail.com>" \
            org.label-schema.build-date=${BUILD_DATE} \
            org.label-schema.name=${DOCKER_TAG} \
            org.label-schema.description="Docker Image to run Satisfy, a composer web GUI based on Satis" \
            org.label-schema.url="https://cloud.docker.com/u/edyan/repository/docker/edyan/satisfy" \
            org.label-schema.vcs-url="https://github.com/edyan/satisfy" \
            org.label-schema.vcs-ref=${VCS_REF} \
            org.label-schema.schema-version="1.0" \
            org.label-schema.vendor="edyan" \
            org.label-schema.docker.cmd="docker run -d --rm ${DOCKER_TAG}"


ENV         APP_DEBUG=0
ENV         PHP_ENABLED_MODULES="dom iconv json phar simplexml tokenizer xml"
CMD         ["su", "-", "www-data", "-s", "/bin/bash", "-c", "--", "php -S 0.0.0.0:8080 -t /app/public"]
