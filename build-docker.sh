#!/bin/sh -v

VERSION=$(git describe | sed s!release/!!g)

HOST=$1
shift
NAME=waysofdarkness/wiki

MEDIAWIKI_VERSION=1.34.2

REPOSITORY=$HOST/$NAME:$VERSION

echo "Building $REPOSITORY"

on_fail() {
    buildah rm "${C}"
    exit 1
}

install_pecl_extensions() {
    while [ $# -gt 0 ]
    do
        NAME=$1
        shift
        buildah run -- "${C}" sh -c "pecl install \"${NAME}\" && docker-php-ext-enable \"${NAME}\"" || on_fail
    done
}

install_extensions() {
    while [ $# -gt 0 ]
    do
        NAME=$1
        shift
        buildah run -- "${C}" docker-php-ext-install "${NAME}" || on_fail
    done
}

run_composer() {
    while [ $# -gt 0 ]
    do
        NAME=$1
        shift
        buildah run -- "${C}" sh -c "( cd extensions/$NAME; php ../../composer.phar install; )" || on_fail
    done
}

#C=$(buildah from "mediawiki:$MEDIAWIKI_VERSION")

#buildah run -- "${C}" usermod -u 1033 www-data || on_fail
#buildah run -- "${C}" apt-get update || on_fail
#buildah run -- "${C}" apt-get install -y lua5.1-dev libpq-dev unzip locales || on_fail
#buildah run --add-history -- "${C}" locale-gen --no-purge en_US.UTF-8 || on_fail
#buildah run -- "${C}" docker-php-source extract || on_fail

#install_pecl_extensions luasandbox
#install_extensions pdo pdo_pgsql pgsql

#buildah run --add-history -- "${C}" docker-php-source delete || on_fail

#buildah copy ${C} fonts/ addons/ LocalSettings.php ./ || on_fail
#buildah copy ${C} htaccess .htaccess || on_fail

#buildah copy ${C} "https://getcomposer.org/installer" composer-setup.php || on_fail
#buildah run -- "${C}" php composer-setup.php || on_fail
#buildah run -- "${C}" rm composer-setup.php || on_fail
#buildah run -- "${C}" php composer.phar install || on_fail

#run_composer Widgets TemplateStyles

#buildah run -- "${C}" rm composer.phar || on_fail

#buildah run -- "${C}" chown www-data -R . || on_fail

#buildah commit "${C}" "docker://$REPOSITORY"

buildah bud -t "$1:$VERSION" . || exit 1
buildah push "$1:$VERSION" "docker://$1:$VERSION" || exit 1
#podman --cgroup-manager=cgroupfs image push $REPOSITORY || exit 1

cat > mediawiki.version.auto.tfvars <<EOC # language=terraform
app_version = "$VERSION"
EOC
