FROM php:7.3-cli-alpine

RUN docker-php-ext-install pdo_mysql && \
    apk add --no-cache bash patch git make mysql-client openssh-client gcc g++ autoconf imagemagick-dev imagemagick libzip-dev freetype libpng libjpeg-turbo freetype-dev libpng-dev libjpeg-turbo-dev && \
    docker-php-ext-configure gd \
    --with-gd --with-freetype-dir=/usr/include/ \
    --with-png-dir=/usr/include/ \
    --with-jpeg-dir=/usr/include/ && \
    NPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) && \
    docker-php-ext-install -j${NPROC} gd && \
    docker-php-ext-install zip && \
    pecl install imagick && \
    docker-php-ext-enable imagick && \
    apk del --no-cache freetype-dev libpng-dev libjpeg-turbo-dev make gcc g++ 


RUN curl -o /tmp/composer-setup.php https://getcomposer.org/installer && \
    curl -o /tmp/composer-setup.sig https://composer.github.io/installer.sig && \
    # Make sure we're installing what we think we're installing!
    php -r "if (hash_file('sha384', '/tmp/composer-setup.php') !== trim(file_get_contents('/tmp/composer-setup.sig'))) { unlink('/tmp/composer-setup.php'); echo 'Invalid installer' . PHP_EOL; exit(1); }" && \
    php /tmp/composer-setup.php --no-ansi --install-dir=/usr/local/bin --filename=composer --snapshot && \
    rm -f /tmp/composer-setup.*
