var url = casper.cli.get("url");
if (!/\/$/.test(url)) {
    // add a trailing slash
    url = url + '/';
}
casper.test.done();
