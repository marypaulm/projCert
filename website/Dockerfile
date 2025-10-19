FROM php:7.4-apache

WORKDIR /var/www/html
COPY . /var/www/html/
RUN chown -R www-data:www-data /var/www/html

# Expose HTTP
EXPOSE 80

# Start Apache in foreground
CMD ["apache2-foreground"]
