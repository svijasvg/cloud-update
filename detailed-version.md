[logo]: http://files.svija.love/github/readme-logo.png "Svija: SVG-based websites built in Adobe Illustrator"

*Updated 29 July, 2021*

![Svija: SVG-based websites built in Adobe Illustrator][logo]

# Releasing a New Version of Svija

**Detailed version** — change to [simple version](https://github.com/svijalove/cloud-update).

**For future reference:** fixtures are pre-filled database tables that can be used to give people new content. For example, if I wanted to add a module to every Svija site, I could create a fixture for the module and include it with the update.

Most of the time they are not needed.

- info at [djangoproject.com](https://docs.djangoproject.com/en/3.0/howto/initial-data/) ·  
- info at [stackoverflow.com](https://stackoverflow.com/questions/1113096/django-dump-data-for-a-single-model)

To create a fixture, use:

    $ ./manage.py dumpdata svija.help  --indent 4 >> help.json

Where **svija** is the app name and **help** is the model name.

The JSON file will be available to all sites once it is moved to:

    cloud/svija/fixtures

If fixtures are erroneously not included, verify that they're listed in the MANIFEST.in file.

* * * * *

**1. Database Backups**
-----------------------

First, run the **database backup script** — there are currently four servers:

    Linode andrewswift: dev.svija.com
    Linode andrewswift: live.svija.com
    Linode svija: beta.svija.com
    Linode svija: ftp.svija.com (ancoprint)

Obviously, the **dev server will not be updated** because it is the source of the update.

#### sitelist.txt

The backup script depends on **sitelist.txt** being up to date:

    $ cd /home
    $ ls                # copy the directory listing with the cursor
    $ vi sitelist.txt   # paste and delete unneeded info

Update the **version numbers** in the git repository.

**New version** is the version of the dev branch that will be implemented:

    $ vi /opt/cloud-update/update.sh # new version 
    $ vi /opt/cloud-update/backup.sh # new version minus 1

Clone the **git repository** on each server to be updated:

    $ git clone ssh://git@github.com/svijalove/cloud-update.git

Check the **current version number** — it should match the "minus 1" version of the backup script:

    $ vi /opt/venv/djangoEnv/lib/python3.8/site-packages/svija/views/__init__.py 

Run **backup-data.sh**:

    $ cloud-update/backup.sh

* * * * *

**Linode Backups**
------------------

Make **cloud backups** for the appropriate Linode accounts:

    andrewswift: live-svija-50
    svija: beta-svija-50go & ftp-svija-25go

**dev** won't need to be updated.

**Check for Migrations**
------------------------

Back on the **dev server**, in the dev site folder:

    $ workon djangoEnv
    $ ./manage.py makemigrations
    $ ./manage.py migrate

**Merge to Master**
-------------------

If there are migrations or modifications to settings, include this information in the merge.

The merge comments will be the changelog text at [tech.svija.com](https://tech.svija.love/programs/cloud/changelog), so write clearly. A list of commits is available on the [github page](https://github.com/svijalove/cloud/commits/beta).

Check out the **branch you are merging to** (Master), then merge:

    $ git status
    # add any migrations etc.

    $ git push -u
    $ git checkout master
    $ git merge dev --no-ff
    $ git push origin master

**In Vim**, to prepare the text for selection:

- set nonu
- set colorcolumn=0
- set foldcolumn=0

The **--no-ff** flag prevents git merge from executing a "fast-forward" if it detects that your current HEAD is an ancestor of the commit you're trying to merge.

**Update the Documentation**
------------------------

Copy info from/to:

[github.com/svijalove/cloud/commits/master](https://github.com/svijalove/cloud/commits/master)
[tech.svija.love/programs/cloud/changelog](https://tech.svija.love/programs/cloud/changelog)

**Create an Installable Version**
---------------------------------

Create an **installable version** so that will be available in case of future compatibility problems:

Run the tarball creation script:

    $ cd /opt/cloud
    $ ./save_tar.sh

*save_tar.sh contains:*

     /opt/venv/djangoEnv/bin/activate
     python setup.py sdist
     git add dist/django-svija-2.1.x.tar.gz
     git commit -m "added version 2.1.x" -a
     git push origin master

Files are included based on **MANIFEST.in** in /opt/cloud

**Update the Svija Servers**
----------------------------

**Check that the Linode backups are finished.**

If the update is being done manually, make any changes to the site files at this time:

    $ vi -O */*/settings.py

**Run the update script.** It's good to start with the **ftp server**, because there are only two sites.

    $ vi cloud-update/update.sh # make sure it looks good
    $ cloud-update/update.sh
    $ rm -rf cloud-update  

**NOTE**: if installation is done manually, make sure to start the virtual environment before proceeding:

    $ workon djangoEnv  
    $ pip install git+ssh://git@github.com/svijalove/cloud.git@master#egg=django-svija --upgrade

In each project folder:

    $ ./manage.py migrate && ./manage.py collectstatic --noinput

At the end:

    $ service uwsgi restart

**Note**: errors related to pip and directory ownership do not require intervention.

**Visit The Sites**
-------------------

Visit one site on each server to verify that they're working correctly.

*At this point, the updating process is finished. The rest is setting up a new version.*

**Update the Sync Message**
---------------------------

If desired, SSH to the Svija Apache server to update the message at [msg.svija.love](http://msg.svija.love) to announce the changes:

    $ ssh sites
    $ cd msg.svija.love
    $ vi -O 1.1.1/*

**Create A New Release**
------------------------

On github, create a new release from the master branch.

- use the current version number
- use the month & year for the title
- use the changelog text for the description

**Check Out the Dev Branch**
----------------------------

Commit any changes, then check out the dev branch:

    $ git status
    $ git commit -m "last commit before going back to dev" -a
    $ git checkout dev
    $ git merge master --no-ff -m "starting new version"
    $ git push -u

**Start A New Version**
----------------------

Places to update the version number:

    $ cd /opt/cloud
    $ vi README.md  
    $ vi setup.py  
    $ vi save_tar.sh # 2 places 
    $ vi svija/views/__init__.py
    $ vi svija/templates/admin/base_site.html

Then commit the version number change:

    $ git commit -m "updated version number" -a  
    $ git push -u  

**Post to Social Media**
------------------------

Find a nice picture or make an ad to accompany the update, then

* [facebook.com/svijalove](https://facebook.com/svijalove)  
* [twitter.com/svijalove](https://twitter.com/svijalove)  
* [instagram/svijalove](https://instagram/svijalove) (make it 3x wide · has to be posted from phone)  
* [linkedin.com/company/svijalove](https://linkedin.com/company/svijalove) (add text before adding image)

**Update tutorial content at tech.svija.com**
---------------------------------------------

Read through the [changelog](https://tech.svija.love/programs/cloud/changelog) and make a list of modfications for the new version.

Update the [documentation pages](https://tech.svija.com) if necessary.

