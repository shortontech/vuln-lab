#!/usr/bin/env bash
composer install --no-interaction --prefer-dist --quiet --no-progress
php artisan migrate --quiet --step
stat /var/www/html/storage
php-fpm -F