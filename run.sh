#!/bin/bash -e

DB_TYPE=${DB_TYPE:-mysql}
DB_HOST=${DB_HOST:-mysql}
DB_PORT=${DB_PORT:-3306}
DB_NAME=${DB_NAME:-reviewboard}
DB_USER=${DB_USER:-reviewboard}
DB_PASS=${DB_PASS:-reviewboard}
DB_UP_TIMEOUT=${DB_UP_TIMEOUT:-120}
RB_DOMAIN=${RB_DOMAIN:-localhost}
RB_ROOT=${RB_ROOT:-/}
RB_STATIC_URL=${RB_STATIC_URL:-static/}
RB_MEDIA_URL=${RB_MEDIA_URL:-media/}
RB_ADMIN_USER=${RB_ADMIN_USER:-admin}
RB_ADMIN_PASS=${RB_ADMIN_PASS:-admin}
RB_ADMIN_MAIL=${RB_ADMIN_MAIL:-admin@localhost}
CACHE_TYPE=${CACHE_TYPE:-memcached}
CACHE_INFO=${CACHE_INFO:-memcached:11211}

for i in $(seq 0 $DB_UP_TIMEOUT); do
  echo "Waiting for database..."
  case $DB_TYPE in
  mysql)
    if echo 'SELECT 1' | mysql -h$DB_HOST -u$DB_USER -p$DB_PASS $DB_NAME &> /dev/null; then
      echo "Database ready"
      break
    fi
    sleep 1s
    ;;
  postgresql)
    #TODO
    ;;
  sqlite3)
    #TODO
    ;;
  *)
    break
    ;;
  esac
done

if [ -d /var/www/reviewboard ]; then
    rb-site upgrade /var/www/reviewboard
else
    rb-site install /var/www/reviewboard \
                       --noinput \
                       --domain-name=$RB_DOMAIN \
                       --site-root=$RB_ROOT \
                       --static-url=$RB_STATIC_URL \
                       --media-url=$RB_MEDIA_URL \
                       --db-type=$DB_TYPE \
                       --db-host=$DB_HOST \
                       --db-name=$DB_NAME \
                       --db-user=$DB_USER \
                       --db-pass=$DB_PASS \
                       --cache-type=$CACHE_TYPE \
                       --cache-info=$CACHE_INFO \
                       --admin-user=$RB_ADMIN_USER \
                       --admin-password=$RB_ADMIN_PASS \
                       --admin-email=$RB_ADMIN_MAIL \
                       --opt-out-support-data
    chown -R www-data /var/www/reviewboard/htdocs/media/uploaded
    chown -R www-data /var/www/reviewboard/data
    chown -R www-data /var/www/reviewboard/htdocs/media/ext
    chown -R www-data /var/www/reviewboard/htdocs/static/ext
    cp /var/www/reviewboard/conf/apache-wsgi.conf /etc/apache2/sites-enabled/000-default.conf
    mkdir -p /var/log/reviewboard && chown www-data /var/log/reviewboard
fi

apachectl -DFOREGROUND

