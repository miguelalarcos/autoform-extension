@items = new Meteor.Collection "Items",
    schema:
        field1_id:
            type: String
            references: 'authors.surname'
            translate: true
            tag: 'authors'
        field2:
            type: String
            references: 'authors.surname'
            translate: false
            strict: true
            tag: 'authors2'
        field3:
            type: String
            references: 'authors.surname'
            translate: false
            strict: false
            tag: 'authors3'
        date:
            type: Date
            format: 'DD-MM-YYYY'
        datetime:
            type: Date
            format: 'DD-MM-YYYY HH:mm'
        time:
            type: String