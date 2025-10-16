FROM devopsedu/webapp

# Copy website files into container
COPY . /var/www/html/

# Install Apache and set permissions, remove default Apache index.html
RUN apt-get update && \
    apt-get install -y apache2 && \
    rm -f /var/www/html/index.html && \
    chown -R www-data:www-data /var/www/html

# Expose HTTP port
EXPOSE 80

# Set working directory
WORKDIR /var/www/html

# Start Apache in foreground
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
