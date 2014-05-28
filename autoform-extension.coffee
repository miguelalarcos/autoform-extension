AutoForm.addHooks null, 
    docToForm: (doc, schema, formId) ->
        PrepareFormObject doc, schema._schema
    formToDoc: (doc, schema, formId) ->
        PrepareRealObject doc, schema._schema

tpStore = {} # to store the data received from the server that is for the typeaheads

PrepareRealObject = (doc, schema) -> 
    for key, value of schema
        if value.references?
            val = null
            for obj in tpStore[value.typeahead]
                if obj.name == doc[key]
                    val = obj._id
                    break
            doc[key] = val
        else if value.typeahead?
            if value.strict? and value.strict
                val = null
                for obj in tpStore[value.typeahead]
                    if obj.name == doc[key]
                        val = doc[key]
                        break
                doc[key] = val
        else if value.format? and doc[key]
            doc[key] = moment(doc[key], value.format).toDate()
    doc
    
PrepareFormObject = (doc, schema)->
    if doc
        for key, value of schema
            if value.references?
                a = value.references.split('.')
                collection = a[0]
                displayName = a[1]
                y = window[collection].findOne doc[key]
                if y
                    toDisplay = y[displayName]
                    if _.isFunction(toDisplay)
                        toDisplay = toDisplay.apply(y)
                    doc[key] = toDisplay
                    tpStore[value.typeahead] = [{_id: y._id, name: toDisplay}]
            else if value.typeahead?
                if value.strict? and value.strict
                    tpStore[value.typeahead] = [{_id: '', name: doc[key]}]
            else if value.format? and doc[key]
                doc[key] = moment(doc[key]).format(value.format)    
        return doc
    else
        null
    


AFE =
    _PrepareFormObject: PrepareFormObject
    _PrepareRealObject: PrepareRealObject

    localMethod : (form, method, func) ->            
        dct_2 = {}
        dct_2[method] = (doc) ->
            func(doc)
            doc
        dct = {}
        dct[form] =
            before: dct_2
        AutoForm.hooks dct

    
    # given a template, looks for the typeaheads, the dates, datetimes and times and render them
    makeRendered : (t, dateformat, datetimeformat)->
        t.findAll('.typeahead').each ->
            Meteor.typeahead @, window[$(@).attr("data-source")]
        t.findAll('.date').each ->
            $(@).datetimepicker(pickTime: false, format: dateformat)
        t.findAll('.datetime').each ->
            $(@).datetimepicker(format: datetimeformat)
        t.findAll('.time').each ->
            $(@).datetimepicker(pickDate: false)

    # you have to call this function to obtain the source function typeahead can use
    tpGenerate : (call, tag)-> # call is the Meteor call name in the server, and tag is optional
                               # tag is useful when you have two typeaheads with the same source
        if tag is undefined
            tag = call 
        tpStore[tag] = []
        (query, callback)->
            Meteor.call call, query, (error, result)->
                tpStore[tag] = result or []       
                result = (value: it.name for it in (result or []))
                callback result


