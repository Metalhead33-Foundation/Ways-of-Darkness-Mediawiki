FROM mediawiki:1.37.0
RUN usermod -u 1033 www-data
RUN apt-get update && apt-get install -y lua5.1-dev libpq-dev unzip locales
RUN locale-gen --no-purge en_US.UTF-8
RUN docker-php-source extract && \
    pecl install LuaSandbox && \
    docker-php-ext-enable luasandbox && \
    docker-php-ext-install pdo pdo_pgsql pgsql intl && \
    docker-php-source delete

COPY fonts addons ./
COPY LocalSettings.php .
COPY htaccess .htaccess

RUN ( \
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"; \
    php composer-setup.php; \
    php -r "unlink('composer-setup.php');"; \
    php composer.phar install; \
    ( cd extensions/Widgets; php ../../composer.phar install; ) ; \
    ( cd extensions/TemplateStyles; php ../../composer.phar install --no-dev; ) ; \
    php -r "unlink('composer.phar');"; \
)
RUN chown www-data -R .
