Docker Review Board
-------------------

Full stack solution to run [Review Board](https://www.reviewboard.org) with [MariaDB](https://mariadb.org) and [Memcached](https://memcached.org).


### Usage

```
$ docker-compose up
```

### Config

    RB_PORT=8000
    RB_DOMAIN=localhost
    RB_ROOT=/
    RB_STATIC_URL=static/
    RB_MEDIA_URL=media/
    RB_ADMIN_USER=admin
    RB_ADMIN_PASS=admin
    RB_ADMIN_MAIL=admin@localhost
    DB_NAME=reviewboard
    DB_USER=reviewboard
    DB_PASS=reviewboard
    MYSQL_ROOT_PASSWORD=root
