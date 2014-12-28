// Configuration and some usefull methods

/**
 * Debug/Verbose
 * ----------------------------------------------------------------------------
 */
var debug_mode = !!casper.cli.get('verbose');
if (debug_mode) {
    debug_mode = true;
    casper.options.verbose = true;
    casper.options.logLevel = 'debug';
}

/**
 * The view
 * ----------------------------------------------------------------------------
 */

// The viewport size
casper.options.viewportSize = {
    width: 1024,
    height: 768
};

/**
 * Utils, XPath, FileSystem
 * ----------------------------------------------------------------------------
 */
var utils   = require('utils');
var x       = casper.selectXPath;
var fs      = require('fs');

// Done for the test file
// ----------------------------------------------------------------------------
casper.test.done();
