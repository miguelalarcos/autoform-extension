@items = new Meteor.Collection "Items",
    schema:
        field1_id:
            type: String
            references: 'authors.surname'
            typeahead: 'authors'
            optional: true
        field2:
            type: String
            typeahead: 'authors2'
            strict: true
            optional: true
        field3:
            type: String
            typeahead: 'authors3'
            strict: false
            optional: true
        field4:
            type: [String]
            tags: true
            optional: true
        date:
            type: Date
            format: 'DD-MM-YYYY'
            optional: true
        datetime:
            type: Date
            format: 'DD-MM-YYYY HH:mm'
            optional: true
        time:
            type: String
            optional: true