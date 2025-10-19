# Use official PHP image with CLI
FROM php:7.4-cli

# Set working directory
WORKDIR /var/www/html

# Copy website files
COPY . /var/www/html/

# Set permissions
RUN chown -R www-data:www-data /var/www/html

# Expose port
EXPOSE 80

# Start PHP built-in server
CMD ["php", "-S", "0.0.0.0:80", "-t", "."]
