# Use the project-required base image
FROM devopsedu/webapp

# Remove Apache's default index page to avoid conflicts
RUN rm -rf /var/www/html/*

# Copy website files into container
COPY . /var/www/html/

# Set correct permissions
RUN chown -R www-data:www-data /var/www/html

# Expose HTTP port
EXPOSE 80

# Set working directory
WORKDIR /var/www/html

# Start PHP built-in server
CMD ["php", "-S", "0.0.0.0:80", "-t", "."]
