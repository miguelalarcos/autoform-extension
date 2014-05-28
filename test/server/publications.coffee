Meteor.methods
    authors: (query) ->
        {name: ath} for ath in ['Dawkins', 'Dennet', 'Darwin']

if @authors.find().count() == 0
    for ath in ['Dawkins', 'Dennet', 'Darwin']
        @authors.insert(surname: ath)