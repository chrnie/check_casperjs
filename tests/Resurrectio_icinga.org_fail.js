/*==============================================================================*/
/* Casper generated Wed Dec 17 2014 21:59:56 GMT+0100 (CET) */
/*==============================================================================*/

var x = require('casper').selectXPath;
casper.options.viewportSize = {width: 1855, height: 993};
casper.on('page.error', function(msg, trace) {
   this.echo('Error: ' + msg, 'ERROR');
   for(var i=0; i<trace.length; i++) {
       var step = trace[i];
       this.echo('   ' + step.file + ' (line ' + step.line + ')', 'ERROR');
   }
});
casper.test.begin('Resurrectio test', function(test) {
   casper.start('https://www.icinga.org/');
   casper.waitForSelector("#main-header .container.clearfix",
       function success() {
           test.assertExists("#main-header .container.clearfix");
           this.click("#main-header .container.clearfix");
       },
       function fail() {
           test.assertExists("#main-header .container.clearfix");
   });
   casper.waitForSelector(".et_pb_section.et_section_regular:nth-child(2)",
       function success() {
           test.assertExists(".et_pb_section.et_section_regular:nth-child(2)");
           this.click(".et_pb_section.et_section_regular:nth-child(2)");
       },
       function fail() {
           test.assertExists(".et_pb_section.et_section_regular:nth-child(2)");
   });
   casper.waitForSelector(x("//*[normalize-space(text())='Contact']"),
       function success() {
           test.assertExists(x("//*[normalize-space(text())='Contactoo']"));
         },
       function fail() {
           test.assertExists(x("//*[normalize-space(text())='Contactoo']"));
   });
   casper.waitForSelector(".et_pb_section.et_section_regular:nth-child(2)",
       function success() {
           test.assertExists(".et_pb_section.et_section_regular:nth-child(2)");
           this.click(".et_pb_section.et_section_regular:nth-child(2)");
       },
       function fail() {
           test.assertExists(".et_pb_section.et_section_regular:nth-child(2)");
   });

   casper.run(function() {test.done();});
});
