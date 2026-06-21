#!/usr/bin/env bash
set -e

# Generate an app key if one isn't set (useful for first boot).
if [ -z "${APP_KEY}" ] && ! grep -q "^APP_KEY=base64" .env 2>/dev/null; then
    php artisan key:generate --force || true
fi

# Wait for the database to accept connections before migrating.
echo "Waiting for database at ${DB_HOST}:${DB_PORT}..."
until php -r "exit(@fsockopen(getenv('DB_HOST'), (int) getenv('DB_PORT')) ? 0 : 1);" 2>/dev/null; do
    sleep 2
done
echo "Database is up."

# Run migrations and cache config for production-style boots.
php artisan migrate --force || true
php artisan storage:link || true
php artisan config:cache || true

exec "$@"
