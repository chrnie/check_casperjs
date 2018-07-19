check_casperjs
==============

Monitoring Plugin to integrate casperjs in icinga/nagios/shinken


## Require

phantomjs and casperjs

### Perl libs:

- XML::Simple

## install Requirements

### phantomjs

- get phantomjs from http://phantomjs.org/download.html (Version 2.1.1 has been tested)

  - `wget https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2`

  - `tar xf phantomjs-2.1.1-linux-x86_64.tar.bz2`


- untar/copy to a directory (LSB says /opt)

- link binary to a folder in PATH
`sudo ln -s /opt/phantomjs/bin/phantomjs /usr/local/bin/`

### casperjs

- get casperjs from http://casperjs.org/ (Version 1.1.4-1 has been tested)
  - `wget https://github.com/casperjs/casperjs/archive/1.1.4-1.zip`
  - `unzip 1.1.4-1.zip`

- copy to a directory (LSB says /opt)

- link binary to a folder in PATH
  - `sudo ln -s /opt/casperjs/bin/casperjs /usr/local/bin/`

### XML::Simple

#### Debian/Ubuntu
`aptitude install libxml-simple-perl`

#### RedHat/CentOS
`yum install perl-XML-Simple.noarch`

## install plugin

   icinga:/usr/local/icinga/libexec # git clone https://github.com/chrnie/check_casperjs 

## usage

./check_casperjs.pl --help

    check_casperjs.pl 0.61 - checks casperjs usecases
    Options are:
      -c, --critical                  critical threshold in ms for overall duration
      -w, --warning                   warning threshold in ms for overall duration
      -o, --casperjs-options          add extra options for casperjs
      -t, --test-case                 test case for casperjs
      -h, --help                      display this help and exit
          --usage                     display a short usage instruction
      -p  --proxy                     need proxy?
      -u  --url                       for variable urls
      -s  --screenshots               capture screenshots on each step.
      -v, --verbose                   be verbose
      -V, --version                   output version information and exit
    Requirements:
      This plugin uses casperjs and phantomjs.

## Example
- simple Resurrectio Example
`./check_casperjs.pl -w 30000 -c 60000 -t tests/Resurrectio_icinga.org.js`
- wordpress backend example (with static screenshot in /tmp)
`check_casperjs.pl --warning 50000 --critical 60000 -t tests/wordpress_backend.js --url http://my_wordpress_blog.example.org -o user=testuser -o pass=SecretPassword`

```
OK - PASS Find an element matching: form[name=loginform] input[name=log] in 0.877 s
PASS Find an element matching: form[name=loginform] input[name=pwd] in 0.078 s
PASS Find an element matching: form[name=loginform] input[type=submit] in 0.241 s
PASS Find an element matching: div#wpadminbar in 1.853 s
PASS Find an element matching: #wp-admin-bar-logout > a:nth-child(1) in 0.898 s
PASS Current url matches the provided pattern in 0.846 s
|'Find an element matching: form[name=loginform] input[name=log]'=0.877s;50;60;0;60 'Find an element matching: form[name=loginform] input[name=pwd]'=0.078s;50;60;0;60 'Find an element matching: form[name=loginform] input[type=submit]'=0.241s;50;60;0;60 'Find an element matching: div#wpadminbar'=1.853s;50;60;0;60 'Find an element matching: #wp-admin-bar-logout > a:nth-child(1)'=0.898s;50;60;0;60 'Current url matches the provided pattern'=0.846s;50;60;0;60 'total'=4.793s;50;60;0;60
```

## Resurrectio

It's possible to use Resurrectio. This Chrome Plugin can records casperjs files.
You can grab it from the Chrome App Market.

https://chrome.google.com/webstore/detail/resurrectio/kicncbplfjgjlliddogifpohdhkbjogm

## Download

- `git clone git://git.netways.org/plugins/check_casperjs.git`

or

- `wget https://git.netways.org/plugins/check_casperjs/archive-tarball/master`
- `tar xf master`
