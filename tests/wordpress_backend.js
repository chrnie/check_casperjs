/*==============================================================================*/
/* Casper generated Tue Mar 03 2015 09:25:01 GMT+0100 (CET) */
/*==============================================================================*/

//var login_user_username     = 'testuser';
//var login_user_password     = 'top_secret';

var login_user_username     = casper.cli.get("user");
var login_user_password     = casper.cli.get("pass");

if (!/\/$/.test(url)) {
    // We haven't trailing slash: add it
    url = url + '/';
}
var x = require('casper').selectXPath;
casper.options.viewportSize = {width: 1855, height: 993};
casper.on('page.error', function(msg, trace) {
   this.echo('Error: ' + msg, 'ERROR');
   for(var i=0; i<trace.length; i++) {
       var step = trace[i];
       this.echo('   ' + step.file + ' (line ' + step.line + ')', 'ERROR');
   }
});
casper.test.begin('Wordpress Backend Test', function(test) {
   casper.start(url + '/wp-login.php');
   casper.waitForSelector("form[name=loginform] input[name='log']",
       function success() {
           test.assertExists("form[name=loginform] input[name='log']");
           this.click("form[name=loginform] input[name='log']");
       },
       function fail() {
           test.assertExists("form[name=loginform] input[name='log']");
   });
   casper.waitForSelector("form[name=loginform] input[name='pwd']",
       function success() {
           test.assertExists("form[name=loginform] input[name='pwd']");
           this.click("form[name=loginform] input[name='pwd']");
       },
       function fail() {
           test.assertExists("form[name=loginform] input[name='pwd']");
   });
   casper.waitForSelector("input[name='log']",
       function success() {
           this.sendKeys("input[name='log']", login_user_username);
       },
       function fail() {
           test.assertExists("input[name='log']");
   });
   casper.waitForSelector("input[name='pwd']",
       function success() {
           this.sendKeys("input[name='pwd']", login_user_password);
       },
       function fail() {
           test.assertExists("input[name='pwd']");
   });
   casper.waitForSelector("form[name=loginform] input[type=submit]",
       function success() {
           test.assertExists("form[name=loginform] input[type=submit]");
           this.click("form[name=loginform] input[type=submit]");
       },
       function fail() {
           test.assertExists("form[name=loginform] input[type=submit]");
   });
   /* submit form */
   casper.waitForSelector("div#wpadminbar",
       function success() {
           test.assertExists("div#wpadminbar");
            casper.capture('/tmp/Loggeda.png');
         },
       function fail() {
           test.assertExists("div#wpadminbar");
            casper.capture('/tmp/Loggedb.png');
   });
//
   casper.waitForSelector("#wp-admin-bar-logout > a:nth-child(1)",
       function success() {
           test.assertExists("#wp-admin-bar-logout > a:nth-child(1)");
           this.click("#wp-admin-bar-logout > a:nth-child(1)");
       },
       function fail() {
           test.assertExists("#wp-admin-bar-logout > a:nth-child(1)");
   });
   casper.waitForSelector("form[name=loginform] input[type=submit]",
       function success() {
         test.assertUrlMatch(/\/wp\-login\.php\?loggedout=true$/)
            casper.capture('/tmp/Loggedoff.png');
       },
       function fail() {
         test.assertUrlMatch(/\/wp\-login\.php\?loggedout=true$/)
   });

   casper.run(function() {test.done();});
});
