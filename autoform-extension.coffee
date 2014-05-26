tpStore = {} # to store the data received from the server that is for the typeaheads

PrepareRealObject = (doc, schema) -> 
    for key, value of schema
        if value.references?
            if value.strict? and not value.strict
                val = doc[key]
            else
                val = null
            for obj in tpStore[value.tag]
                if obj.name == doc[key]
                    if value.translate? and not value.translate
                        val = doc[key]
                    else
                        val = obj._id
                    break
            doc[key] = val
        else if value.format? and doc[key]
            doc[key] = moment(doc[key], value.format).toDate()
    doc
    
PrepareFormObject = (doc, schema)->
    if doc
        for key, value of schema
            if value.references?
                if value.translate? and not value.translate
                    continue
                a = value.references.split('.')
                collection = a[0]
                displayName = a[1]
                y = window[collection].findOne doc[key]
                if y
                    toDisplay = y[displayName]
                    if _.isFunction(toDisplay)
                        toDisplay = toDisplay.apply(y)
                    doc[key] = toDisplay
                    tpStore[value.tag] = [{_id: y._id, name: toDisplay}]
            else if value.format? and doc[key]
                doc[key] = moment(doc[key]).format(value.format)    
        return doc
    else
        null
    


AFE =

    # set the docToForm and formToDoc hooks:
    # when an id that references other collection: display de field of the other collection.
    # Example: authorId :
    #             references: 'authors.fullName' # where authors is the collection an fullName the field to display
    # reverse when obtaining the object from the form
    # idem with dates: when a date is received it is converted to string according to a format
    # reverse when obtaining the object from the form
    extendForm : (form, schema) ->
        dct = {}
        dct[form] = 
            docToForm: (doc) ->
                PrepareFormObject doc, schema 
            formToDoc: (doc) ->
                PrepareRealObject doc, schema
        
        AutoForm.hooks dct
     
    # after you have called extendForm, you can do something like
    # localMethod "searchForm", "searchMethod", (doc)-> console.log doc    
    # this is for forms type method        
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
                               # tag is useful when you have to typeaheads with the same source
        if tag is undefined
            tag = call 
        tpStore[tag] = []
        (query, callback)->
            Meteor.call call, query, (error, result)->
                tpStore[tag] = result or []       
                result = (value: it.name for it in (result or []))
                callback result


