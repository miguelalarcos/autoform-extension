Meteor.methods
    authors: (query) ->
        {name: ath} for ath in ['Dawkins', 'Dennet', 'Darwin']

@authors.remove()
for ath in ['Dawkins', 'Dennet', 'Darwin']
    @authors.insert(surname: ath)