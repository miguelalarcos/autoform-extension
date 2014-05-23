Package.describe({
    summary: "An extension for AutoForm that permit you to use typeahead and format dates."
});

Package.on_use(function (api) {
    api.use(['coffeescript', 'underscore'], 'client');
    api.use('autoform', 'client');
    api.use('typeahead', 'client');
    api.use('moment', 'client');
    api.use('bootstrap3-datetimepicker', 'client');

    api.add_files('autoform-extension.coffee', 'client');
    api.export('AFE', ['client']);
});
