if not @authors.findOne()
    for surname in ['Darwin', 'Dawkins', 'Dennet']
        @authors.insert({surname: surname})