# Page Parts

Page Parts enhances the basic PagePart model by allowing you to store any content -- not just strings -- in page parts. You can also create new types of page parts with custom behavior and use them to manage complex objects like associations and file uploads. Anything you can do with ActiveRecord and a form builder, you can do with Page Parts.

## Basic Usage

Out of the box, Page Parts gives you a few simple part types to work with. These correspond to native DB storage types: strings, integers, booleans, and datetimes. After installing Page Parts, whenever you add a new part to a page you'll be prompted to select the type.

The basic types are useful for storing simple values and using them to intelligently query your Pages. For example, you might add a boolean or a datetime and use that value to filter a page's children.

### Radius tags

New Radius tags are included for working with the basic part types. Full references are available on the page editing screen, but these additional tags are available:

+ `if_bool`
+ `unless_bool`
+ `if_earlier`
+ `if_later`
+ `if_greater`
+ `if_less`
+ `if_equal`
+ `unless_equal`
 
The standard `date` tag is also extended to accept the name of any datetime 
page part:

`<r:date for="datetime page part name" [format="%A, %B %d, %Y"] />`

### Creating new parts

You can add your own parts if you want to extend the behavior of one of the basic types. You can set the column type in which your Part subclass should store its content with the `PagePart.content` method:

    class TrueFalsePagePart < PagePart
      content :boolean
    end

Valid arguments to `PagePart.content` are `:integer`, `:string`, `:boolean`, and `:datetime`.

And you can tell the part how to render its content with the `PagePart#render_content` method:

    class ReversedPagePart < PagePart
      def render_content
        content.reverse
      end
    end

`PagePart#render_content` is useful if you need to interpret the part's value before outputting it with a tag like `<r:content>`.

Each type of page part needs its own subclass and a partial view. The partial is used to render the part's form element when editing a page. If a part doesn't need to display the filter list and reference (i.e. it's not text) you can turn off the filter and reference display:

    class NumericPagePart < PagePart
      content :integer
      show_filters false
    end

See this extension's `/app/models` and `/app/views/admin/page_parts` directories for examples of basic part & view definitions.

If your parts are part of an extension, the parts can be stored in `app/models` and the view partials in `app/views/admin/page_parts`. If you don't want to create an extension just to hold some custom parts, you can put the parts in `RAILS_ROOT/app/models` and the view partials in `RAILS_ROOT/app/views/admin/page_parts`.

## Advanced Usage

The basic types are nice, but the real power of Page Parts is in its ability to extend the PagePart model. Advanced parts can manage complex objects or add arbitrary elements to your page editing forms. Some things you can do by creating your own advanced parts:

+ Add file uploads
+ Manage associations directly on the Page instance
+ Add nested attributes to the Page form
+ Provide a form-based interface for creating Radius tags
+ Serialize arbitrary data to the database

There are functional examples for each of these in the /examples folder to get you started. You should read through all of them to get an idea of what's possible with Page Parts!