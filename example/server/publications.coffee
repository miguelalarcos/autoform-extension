authors = @authors

Meteor.methods
    authors: (query)->
        aths = authors.find({surname: {$regex: '.*' + query + '.*', $options: 'i'}}).fetch()
        {_id: x._id, name: x.surname} for x in aths