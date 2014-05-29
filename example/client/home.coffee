makeRendered = AFE.makeRendered
tpGenerate = AFE.tpGenerate
selectizeGenerate = AFE.selectizeGenerate

@source_field1 = tpGenerate 'authors'
@source_field2 = tpGenerate 'authors', 'authors2'
@source_field3 = tpGenerate 'authors', 'authors3'
@source_coauthors = selectizeGenerate 'authors'

Template.form.rendered = ->
    makeRendered @, 'DD-MM-YYYY', 'DD-MM-YYYY HH:mm'

