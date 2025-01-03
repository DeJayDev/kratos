# Backups

We store our compressed (and if possible, encrypted) backups on [Cloudflare R2](https://www.cloudflare.com/developer-platform/products/r2/). All tools here are compatible with with any provider that has an S3 compatible API.

## Databases

Kratos services depend on any of the following databases:

* [PostgreSQL](https://postgresql.org)
* [MariaDB](https://mariadb.com/)
* [KeyDB](https://keydb.dev)
* [MongoDB](https://mongodb.com)

To backup these services we use **blackbox** [lemonsaurus/blackbox](https://github.com/lemonsaurus/blackbox).

blackbox runs as it's own user, on the system and in each database.

### PostgreSQL

```bash
$ sudo -i -u postgres
$ createuser blackbox
$ psql
```

Then, while still in `psql` `GRANT` the built-in role `pg_read_all_data`.

```sql
GRANT pg_read_all_data TO blackbox;
```

If the response was `GRANT ROLE`, use `\q` and continue.

### MariaDB

Access `mariadb` however you please. For ease, we'll use the root users peer auth:

```bash
$ sudo -i -u root
$ mariadb -u root
```

Then, create a user, granting it the `SELECT`, `LOCK TABLES`, and `SHOW VIEW` privileges:

```sql
CREATE USER 'blackbox'@'localhost' IDENTIFIED BY 'A_VERY_SECURE_PASSWORD';
GRANT SELECT ON *.* TO 'blackbox'@'localhost';
GRANT LOCK TABLES ON *.* TO 'blackbox'@'localhost';
GRANT SHOW VIEW ON *.* TO 'blackbox'@'localhost';
FLUSH PRIVILEGES;
``` 

### KeyDB

If you are using KeyDB instead of Redis, you will need to add a symlink from `keydb-cli` to `redis-cli`:

`sudo ln /usr/bin/keydb-cli /usr/bin/redis-cli`

Define `requirepass` in `/etc/keydb/keydb.conf` if you have not already.

> [!IMPORTANT]  
> If you enabled `requirepass` while following this guide, and you were already using KeyDB/Redis, all of your services will need to be reconfigured with your KeyDB/Redis password.
