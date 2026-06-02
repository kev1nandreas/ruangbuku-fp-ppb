# syntax=docker/dockerfile:1

FROM php:8.4-cli AS base

# System dependencies + PHP extensions required by Laravel + Postgres.
RUN apt-get update && apt-get install -y --no-install-recommends \
        git \
        unzip \
        libpq-dev \
        libzip-dev \
        libicu-dev \
    && docker-php-ext-configure intl \
    && docker-php-ext-install -j"$(nproc)" pdo pdo_pgsql pgsql zip intl bcmath \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Composer from the official image.
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

# Install PHP dependencies first to leverage Docker layer caching.
COPY composer.json composer.lock ./
RUN composer install \
        --no-dev \
        --no-interaction \
        --no-scripts \
        --prefer-dist \
        --optimize-autoloader

# Copy the rest of the application.
COPY . .

# Finish autoloader optimization now that all source is present.
RUN composer dump-autoload --optimize --no-dev \
    && chmod -R 775 storage bootstrap/cache

COPY docker/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 8000

ENTRYPOINT ["entrypoint.sh"]
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]
