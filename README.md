check_casperjs
==============

Monitoring Plugin to integrate casperjs in icinga/nagios/shinken


## Require

phantomjs and casperjs

### install

#### phantomjs

- get phantomjs from http://phantomjs.org/download.html (Version 1.9.8 has been tested)

`wget https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-1.9.8-linux-x86_64.tar.bz2`


- untar/copy to a directory

- link binary to a folder in PATH
`sudo ln -s /opt/phantomjs/bin/phantomjs /usr/local/bin/`

#### casperjs

- get casperjs from http://casperjs.org/ (Version 1.1-beta3 has been tested)

`wget https://github.com/n1k0/casperjs/zipball/1.1-beta3`

- copy to a directoy

- link binary to a folder in PATH
`sudo ln -s /opt/casperjs/bin/casperjs /usr/local/bin/`

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

    ./check_casperjs.pl -w 30000 -c 60000 -t tests/Resurrectio_icinga.org.js

## Resurrectio

It's possible to use Resurrectio. This Chrome Plugin can records casperjs files.
You can grab it from the Chrome App Market.

https://chrome.google.com/webstore/detail/resurrectio/kicncbplfjgjlliddogifpohdhkbjogm


