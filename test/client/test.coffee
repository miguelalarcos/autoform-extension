makeRendered = AFE.makeRendered
tpGenerate = AFE.tpGenerate

source = AFE.tpGenerate 'authors'
testAsyncMulti 'autoform-extension - test tpGenerate', [
    (test, expect)->        
        source 'D', expect (result)->
            test.isTrue(_.isEqual(result, ({value: ath} for ath in ['Dawkins', 'Dennet', 'Darwin'])), "mensaje") 
]

_id = @authors.findOne(surname:'Darwin')._id

before = {field1_id:_id, field2: 'Dennet', field3: 'Dawkins'}
Template.form.doc = -> before
window.source_field1 = tpGenerate 'authors'
window.source_field2 = tpGenerate 'authors', 'authors2'
window.source_field3 = tpGenerate 'authors', 'authors3'

Tinytest.add 'autoform-extension - test hooks', (test)->
    after = AutoForm.getFormValues('ItemForm').insertDoc
    test.isTrue(_.isEqual(before, after))

PrepareFormObject = AFE._PrepareFormObject
schema = @items._c2._simpleSchema._schema
Tinytest.add 'autoform-extension - test PrepareFormObject', (test)->
    after = PrepareFormObject(before, schema)
    test.isTrue(_.isEqual(after, {field1_id:'Darwin', field2: 'Dennet', field3: 'Dawkins'}))

PrepareRealObject = AFE._PrepareRealObject
Tinytest.add 'autoform-extension - test PrepareRealObject', (test)->
    before = PrepareFormObject(before, schema)
    after = PrepareRealObject(before, schema)
    test.isTrue(_.isEqual(after, {field1_id:_id, field2: 'Dennet', field3: 'Dawkins'}))

Tinytest.add 'autoform-extension - test PrepareRealObject null values', (test)->
    before = PrepareFormObject(before, schema)
    before.field2 = 'Dennetx'
    before.field1_id = 'Darwinx'
    before.field3 = 'Dawkinsx'
    after = PrepareRealObject(before, schema)
    test.isTrue(_.isEqual(after, {field1_id: null, field2: null, field3: 'Dawkinsx'}))    

