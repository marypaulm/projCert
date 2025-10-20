FROM devopsedu/webapp

# Remove default Apache index.html 
RUN rm -f /var/www/html/index.html

# Copy your website files into the container
COPY . /var/www/html/

# Set proper ownership and permissions
RUN chown -R www-data:www-data /var/www/html

# Expose HTTP port
EXPOSE 80

# Set working directory
WORKDIR /var/www/html

# Start Apache in foreground
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
