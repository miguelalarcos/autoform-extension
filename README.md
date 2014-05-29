AutoForm Extension
==================

It is an extension for autoform so you can have fields that references other collection, and you can use typeahead to autocomplete the values. Also it takes care of dates.

Note: I'm new at writing tests in Meteor. Any help is welcomed.

```coffee
@books = new Meteor.Collection "Books", 
    schema:
        title:
            type: String
        authorId:
            type: String
            references: 'authors.fullName'  # authorId references collection authors, and fullName is the field to display
            typeahead: 'authors' # the tag commented below
        coauthor:
            type: String
            typeahead: 'coauthors' # without references, the value will not be traslated. For example, 'Dennet' is stored in field coauthor and not an _id
            strict: true # means that the value to be stored must be in the list of the typeahead
        publication:
            type: Date
            format: 'DD-MM-YYYY'

# we generate the function source for the typeahead authors
@source_author = tpGenerate 'authors' # there must exist a Meteor method 'authors'. It is the same than @source_author = tpGenerate 'authors', 'authors'

@source_coauthor = @Utils.tpGenerate 'authors', 'coauthors' # we use the same Meteor method 'authors' but a different typeahead (tagged 'coauthors')

# if we want a local method to be called when the submit button is clicked
localMethod "searchForm", "searchMethod", (doc)->  
    Session.set "book.publication", doc.publication 
    Session.set "book.title", doc.title

Template.book.rendered = ->  # and we render the typeaheads and the date pickers
    makeRendered @, 'DD-MM-YYYY', 'DD-MM-YYYY HH:mm'    
```

And in the server:

```coffee
Meteor.methods
    authors: (query) -> 
        aths = authors.find({fullName: {$regex: '.*'+ query + '.*', $options: 'i'}}).fetch()
        {name: x.fullName, _id:x._id} for x in aths 
        # return in the form {_id:..., name:...}
```

Let's see the html:
```html
    {{#autoForm collection="books" doc=selectedBook id="BookForm" type=typeBookForm validation='submit'}}
    <fieldset>    
        <legend>Register and modify books</legend>    
        {{> afQuickField name='title'}}        
        {{> afQuickField name='authorId' autocomplete="off" spellcheck="off" class="typeahead" data-source="source_author"}}   
        {{> afQuickField name='coauthor' autocomplete="off" spellcheck="off" class="typeahead" data-source="source_coauthor"}}        
        {{> afQuickField name='publication' type='text' class="date"}}
    </fieldset>
    <button type="submit" class="btn btn-primary">Save</button>
    <button type="reset" class="btn btn-primary reset">New</button>
    {{/autoForm}}

    {{#autoForm schema="searchSchema" id="searchForm" type="method" meteormethod="searchMethod"}}
    <fieldset>
    <legend>Search for a book</legend>
    {{> afQuickField name="title"}}
    {{> afQuickField name="publication" type='text' class='date'}}
    <div>
      <button type="submit" class="btn btn-primary">Search</button>
    </div>
  </fieldset>
  {{/autoForm}}  
```

For the dates, you can specify *class* as *date*, *datetime* or *time*, and of course *type='text'* to avoid the native date-picker.

In the server I use ```publish-composite``` so the author of each book is published with the book.
