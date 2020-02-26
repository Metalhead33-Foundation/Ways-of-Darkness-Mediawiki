FROM mediawiki:1.34
RUN apt-get update && apt-get install -y lua5.1-dev libpq-dev
RUN docker-php-source extract && \
    pecl install LuaSandbox && \
    docker-php-ext-enable luasandbox && \
    docker-php-ext-install pdo pdo_pgsql pgsql && \
    docker-php-source delete

COPY fonts addons ./
COPY LocalSettings.php .
RUN chown www-data -R .
