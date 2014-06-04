
Package.describe({
    summary: "An extension for AutoForm that permit you to use typeahead and format dates."
});

Package.on_use(function (api) {
    api.use(['coffeescript', 'underscore', 'check'], ['client', 'server']);
    api.use('templating', 'client');
    api.use('autoform', 'client');
    api.use('typeahead', 'client');
    api.use('moment', 'client');
    api.use('bootstrap3-datetimepicker', 'client');
    api.use('simple-schema', ['client', 'server']);

    api.add_files(['autoform-extension.coffee', 'templates.html', 'templates.coffee'], 'client');
    api.add_files('schema-extension.coffee', ['client', 'server']);
    api.export('AFE', ['client']);
});

Package.on_test(function (api) {
    api.use(['coffeescript','underscore'], ['client', 'server']);
    api.use('templating', 'client');
    api.use('autopublish', 'server');
    //api.use(['autoform', 'typeahead', 'moment', 'bootstrap3-datetimepicker', 'simple-schema'], ['client', 'server']);
    api.use('autoform', ['client']);
    api.use('collection2', 'client');
    api.use('autoform-extension', ['client', 'server']);
    api.use('tinytest', ['client', 'server']);
    api.use('test-helpers', ['client', 'server']);

    api.add_files('test/collections.coffee', ['client', 'server']); 
    api.add_files('test/client/home.html', 'client'); 
    api.add_files('test/client/test.coffee', 'client'); 
    api.add_files('test/server/publications.coffee', 'server');     
});