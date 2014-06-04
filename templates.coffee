Template.afInput_tags.helpers
    tags: (tag) -> Session.get tag
    setInitialValue: (tag, values)->
        lista = (v for v in values when v != '')
        Session.set tag, lista              

Template.afInput_tags.events
    'click .closex': (e,t)->
        el=t.find('input[type=hidden]')
        name = $(el).attr('tagName')
        value = $(e.target).attr('value')
        lista = Session.get(name)
        lista = _.without lista, value
        Session.set name, lista
        $(el).val(lista)
    'keydown .taggin': (e,t)->
        if e.keyCode == 13
            el=t.find('input[type=hidden]')
            name = $(el).attr('tagName')
            val = $(e.target).val()
            lista = Session.get(name)
            if val != '' and val not in lista                
                lista.push val
                Session.set name, lista
                $(e.target).val('')
                $(el).val(lista)
            e.preventDefault()