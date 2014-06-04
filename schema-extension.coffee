SimpleSchema.extendOptions
    references: Match.Optional String
    typeahead: Match.Optional String
    strict: Match.Optional Boolean
    format: Match.Optional String
    tags: Match.Optional Boolean

window = @

SimpleSchema.addValidator ->
    if Meteor.isServer
        if @definition.references?           
            references = @definition.references
            a = references.split('.')
            collection = a[0]
            collection = window[collection]
            if collection.findOne @value
                return true
            else
                return 'Error Foreign Key.'
        else
            return true
    else
        true

            