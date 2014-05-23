Package.describe({
    summary: "An extension for AutoForm that permit you to use typeahead and format dates."
});

Package.on_use(function (api) {
    api.use(['coffeescript'], ['client']);
    api.use('typeahead', ['client']);

    api.add_files('autoform-extension.coffee', 'client');
    api.export('AFE', ['client']);
});
