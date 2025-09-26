[logo]: http://files.svija.love/github/readme-logo.png "Svija: SVG-based websites built in Adobe Illustrator"

*Updated 17 Nobember, 2022*

![Svija: SVG-based websites built in Adobe Illustrator][logo]

### Updating a crashed database

I was trying to upgrade a site to the newest version of Svija and I kept getting errors when migrating.

Here are the steps I took to fix the problem.

---

Export data from a working site
```
$ cd working.com
$ ./manage.py dumpdata > working.json
```
Duplicate the broken site:
```
$ sudo rm broken.com/cache/*
$ cp -r broken.com temp.broken.com
```
Move exported data
```
$ mv working.com/working.json temp.broken.com
$ cd temp.broken.com
```
Create new db
```
$ sudo -u postgres psql
```
Then
```
postgres=# CREATE DATABASE newdb;
postgres=# CREATE USER newuser WITH PASSWORD 'jU7dg(34';
postgres=# ALTER ROLE newuser SET client_encoding TO 'utf8';
postgres=# ALTER ROLE newuser SET default_transaction_isolation TO 'read committed';
postgres=# ALTER ROLE newuser SET timezone TO 'CET';
postgres=# GRANT ALL PRIVILEGES ON DATABASE newdb TO newuser;
```
Then
```
$ ./manage.py migrate --run-syncdb
$ ./manage.py shell
>>> from django.contrib.contenttypes.models import ContentType
>>> ContentType.objects.all().delete()
>>> quit()
```
Load new data into site
```
$ ./manage.py loaddata working.json
```
This created a working site with all the wrong data. I had to go back in and manually add all the old pages, SEO text etc.
