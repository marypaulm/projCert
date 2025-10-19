FROM php:7.4-cli
WORKDIR /var/www/html
COPY . /var/www/html/
RUN chown -R www-data:www-data /var/www/html
EXPOSE 80
CMD ["php", "-S", "0.0.0.0:80", "-t", "."]
