# Use the required base image
FROM devopsedu/webapp

# Copy website files into container
COPY . /var/www/html/

# Install Apache if not present and set permissions
RUN apt-get update && \
    apt-get install -y apache2 && \
    chown -R www-data:www-data /var/www/html

# Add apache2-foreground script
RUN echo '#!/bin/bash\nexec /usr/sbin/apache2ctl -D FOREGROUND' > /usr/local/bin/apache2-foreground \
    && chmod +x /usr/local/bin/apache2-foreground

# Expose HTTP port
EXPOSE 80

# Set working directory
WORKDIR /var/www/html

# Start Apache in the foreground using apache2-foreground
CMD ["apache2-foreground"]
