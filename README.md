AutoForm Extension
==================

It is an extension for autoform so you can have fields that references other collection, and you can use typeahead to autocomplete the values. Also it takes care of dates.

```coffee
# we generate the function source for the typeahead authors
@source_author = tpGenerate 'authors'
# if we have a coauthor field (that references authors as well) in the book, we have to define
# @source_coauthor = @Utils.tpGenerate 'authors', 'coauthor'
# so the tag coauthor is used to distinguish the two sources of typeahead

extendForm "BookForm", # you pass the name of the form and the schema extension
    authorId:
        references: 'authors.fullName' # authorId references collection authors, and fullName is the field to display
        tag: 'authors' # the tag commented before
    publication:
        format: 'DD-MM-YYYY'

extendForm "searchForm",
    publication:
        format: 'DD-MM-YYYY'

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
        {name: x.fullName, _id:x._id} for x in aths # return in the form {_id:..., name:...}
```

Let's see the html:
```html
    {{#autoForm collection="books" doc=selectedBook id="BookForm" type=typeBookForm validation='submit'}}
    <fieldset>    
        <legend>Register and modify books</legend>    
        {{> afQuickField name='title'}}        
        {{> afQuickField name='authorId' autocomplete="off" spellcheck="off" class="typeahead" data-source="source_author"}}        
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

In the server I use *publish-composite* so the author of each book is published with the book.
