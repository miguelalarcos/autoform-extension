makeRendered = AFE.makeRendered
tpGenerate = AFE.tpGenerate

@source_field1 = tpGenerate 'authors'
@source_field2 = tpGenerate 'authors', 'authors2'
@source_field3 = tpGenerate 'authors', 'authors3'

Template.form.rendered = ->
    makeRendered @, 'DD-MM-YYYY', 'DD-MM-YYYY HH:mm'


Session.set 'idDoc', null
items = @items
Template.form.helpers
    type: -> if Session.get 'idDoc' is null then 'insert' else 'update'
    doc: -> items.findOne Session.get 'idDoc'
    items: -> items.find()

Template.form.events
    'click .editable': (e,t)->
        _id = $(e.target).attr('_id')
        Session.set 'idDoc', _id