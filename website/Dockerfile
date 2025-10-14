# Use official PHP image with Apache
FROM php:8.2-apache

# Copy website files into the container
COPY . /var/www/html/

# Expose port 80
EXPOSE 80

# Start Apache in the foreground
CMD ["apache2-foreground"]
