# Use the project-required base image
FROM devopsedu/webapp

# Copy website files into container
COPY . /var/www/html/

# Set correct permissions
RUN chown -R www-data:www-data /var/www/html

# Expose HTTP port
EXPOSE 80

# Set working directory
WORKDIR /var/www/html

# Start Apache in foreground (already included in base image)
CMD ["apache2-foreground"]
