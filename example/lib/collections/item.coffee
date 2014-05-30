@items = new Meteor.Collection "Items",
    schema:
        field1_id:
            type: String
            references: 'authors.surname'
            typeahead: 'authors'
        field2:
            type: String
            typeahead: 'authors2'
            strict: true
        field3:
            type: String
            typeahead: 'authors3'
            strict: false
        field4:
            type: [String]
            selectize: true
        date:
            type: Date
            format: 'DD-MM-YYYY'
        datetime:
            type: Date
            format: 'DD-MM-YYYY HH:mm'
        time:
            type: String