# Use official PHP with Apache
FROM php:8.2-apache

# Enable mod_rewrite (MyBB needs it)
RUN a2enmod rewrite

# Install PostgreSQL driver
RUN apt-get update && \
    apt-get install -y libpq-dev && \
    docker-php-ext-install pdo pdo_pgsql

# Set working directory
WORKDIR /var/www/html

# Copy MyBB files
COPY . .

# Fix permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Use $PORT (Koyeb injects it)
ENV PORT=8080
ENV APACHE_DOCUMENT_ROOT=/var/www/html

# Override Apache port
RUN sed -i "s/80/$PORT/g" /etc/apache2/sites-available/000-default.conf /etc/apache2/ports.conf

# Expose port
EXPOSE $PORT

# Start Apache
CMD ["apache2-foreground"]
