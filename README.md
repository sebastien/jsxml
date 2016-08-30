
## The JSXML Templating language

JSXML is a set of XSL stylesheets that transform XML into JavaScript code equivalent to JSX. Unlike JSX, JSXML is easy to parse (it uses XML) and can easily be re-targetted to different rendering engines (React, Inferno, D3, etc‥).

One of the main drawback of JSX is that it introduces a tight coupling between the JavaScript (the controller) and the HTML code (the view) by enouraging a mix of view code within controller code.

JSXML was build to satisfy the following requirements:

 - Encourage decoupling of view code from controller code 
 - Stay close to a classic HTML/CSS + JavaScript workflow, as opposed to JS/JSX workflow 
 - Abstract from rendering back-end 
 - Leverage open web technologies (XML, XSLT)


In practice, JSXML allows you to write X(HT)ML documents that are automatically rendered to an UMD JavaScript module in expanded JSX (using `React.createElement`) that can be readily imported as view.

The result is that the view can be written predominently in XML/XHTML and can be dynamically integrated with the controller at runtime using dynamic module loading.

A complete JSXML example looks like that:

```xml{4,6,7,9,12,13}
<?xml version="1.0" encoding="UTF-8"?>
<jsx:Component(xmlns::jsx="https://github.com/sebastien/jsxml",xmlns::on="https://github.com/sebastien/jsxml/actions")
   <h1>To do list: 
       <jsx:value="this.state.items.length" /> items
   <h1>
   <ul jsx:map="this.state.items">
      <jsx:apply template="item" />
   </ul>
   <jsx:Template name="item">
      <li>
        <span class="label">item.name</span>
        <span class="priority">item.priority</span>
      <li>
   </jsx:template>
</jsx:Component>
```

### Quick start

Create a file named `view.xml`

```
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" media="screen" href="https://cdn.rawgit.com/sebastien/jsxml/master/dist/jsxml.xsl"?>
<jsx:Component xmlns:jsx="https://github.com/sebastien/jsxml" xmlns::on="https://github.com/sebastien/jsxml/actions">
   Hello, world!
</jsx:Component>
```

Now open this file using your browser, and you should see the following code:

```
TODO
```

If you'd like to convert the XML file through your command line, make sure you have `xsltproc` and `curl` installed and do:

```bash
curl 'https://cdn.rawgit.com/sebastien/jsxml/master/dist/jsxml.xsl' > jsxml.xsl
xsltproc jsxml.xsl view.xml > view.js
```

Now you can directly import the view in your React component:

```javascript{1,6}
import {View} from "./view.js";
import {ReactComponent} from "react";

export class Component extends ReactComponent {
    render(){
       return View(this.state, this);
    }
}
```

### JSXML in a nutshell

#### Namespaces

 - __jsxml__: <https://github.com/sebastien/jsxml> -- base namespace 
 - __on__: <https://github.com/sebastien/jsxml/extra/on> -- used for event handlers 


#### Root

 - [`<jsx:Component>CONTENT‥`](#jsx:Component) declares a component. This is the _root node_ of JSXML.


#### Node content

 - [`<jsx:value>`](#jsx:value) evaluates a (JS) expression and returns its content


 - [`<jsx:attribute name=>`](#jsx:attribute) Sets an attribute on the current node.


 - [`<jsx:style=>`](#jsx:style) Sets a style property for the current node.


 - [`<jsx:children>`](#jsx:children) Inserts the children that might have been passed by a parent component.


 - [`<jsx:T>`](#jsx:T) dynamically translates the given string through the JavaScript defined `T` function.


#### Control flow

 - [`<jsx:for each= in=>`](#jsx:for) Loops over the values returned by the given expression


 - [`<jsx:if test=>`](#jsx:if) Applies the current node only if the condition is true


 - [`<jsx:elif test=>`](#jsx:if) Applies a consecutive test right after an `jsx:if>


 - [`<jsx:else>`](#jsx:else) Applies the current node if all the other conditions have failed


#### Templates

 - [`<jsx:Template name=>`](#jsx:Template) declares a new re-usable snippet within a _component_.


 - [`<jsx:apply template jsx:map= jsx:each=>`](#jsx:apply) applies a `jsx:Template` to the current node., optionally mapping it to the given name.


#### Modules

 - [`<jsx:import value from as>`](#jsx:import) imports an external component so that it can be referenced using `<jsx:component>`


 - [`<jsx:component class>`](#jsx:component) instanciates an imported component.


#### JSXML Attributes

 - [`@jsx:map`+`@jsx:each`](#@jsx:map) Maps the selected items to the contents of the node. Works for both arrays and objects.


 - [`@jsx:value`](#@jsx:value) replaces the element's content with the given value


 - [`@jsx:if`](#@jsx:if) Only add the node if the given condition is valid.


 - [`@jsx:as`/`@jsx:ref`](#@jsx:as) creates a reference (accessible in the underlying JavaScript) to the current rendered node.


#### Special namespace attributes

 - [`@on:*`](#@on:event) registers a callback to handle the given event.


### Element reference

#### <a name=jsx:Component>`<jsx:Component name>`

Declares a new JSX component

 - `name=NAME` is the variable name to which the created `ReactElement` factory will be bound. If not specified, it will default to `View`.


```html
<jsx:Component name="Button">
   <button jsx:text="data.name">Untitled button</button>
</jsx:Component>
```

#### <a _html="true" name="jsx:Template"/>
`<jsx:Template name params>`

Defines a named template that can be referenced with [<jsx:apply>](#apply)

 - `name` is the name of the template, referenced in `apply` 
 - _`params`_, the optional parameter names for the template


```html
<ul>
  <li jsx:map="state.items>
    <!-- This is where the template is REFERENCED -->
    <jsx:apply template="item" />
  </li>
</ul>
<!-- This is where the template is DECLARED -->
<jsx:Template name="item" params="item,index">
   <span jsx:value="item.name"  />
   <span jsx:value="item.value" />
   [<span jsx:value="index + 1" />]
</jsx:Template>
```

#### <a _html="true" name="jsx:import"/>
`<jsx:import name from as>`

Imports a value from an external module

#### <a _html="true" name="jsx:component"/>
`<jsx:component jsx:class jsx:ref data options>`

Instanciates the component with the given `jsx:class` feeding it the given `data` and `options`.

 - `jsx:class=NAME` the symbol name of the class that will be instanciated 
 - `data=EXPRESSION?` an expression evaluating to the data that will be passed to the component. 
 - `options=EXPRESSION?` an expression evaluating to the options that will be passed to the component (this will set `props` in React).


When the `<jsx:component>` is not empty, its content will be passed as children of the component (`props.children` in React).

```
<jsx:component jsx:class="SearchBox" jsx:ref="search">
   <button>Extra button!</button>
</jsx:Component>
```

#### <a _html="true" name="jsx:apply"/>
`<jsx:apply template params>`

Applies the template with the given name. This requires a previously defined `<jsx:Template name=NAME>` tag in the document.

```html
<jsx:apply template="placeholder />
<jsx:Template name="placeholder">Lorem ipsum dolor sit amet‥</jsx:Template>
```

Note that you can use the [`jsx:map`](#jsx-map) attribute in the `jsx:apply` element.

#### <a _html="true" name="jsx:for"/>
`<jsx:for each in>`

Loops over the values defined in `EXPRESSION`, assigning each item to `NAME` (`_` by default). This requires that the given EXPRESSION evaluates to a list.

```html
<ul><jsx:for each="number" in="[1,2,3,4,5]">
    <li>
       Number: <jsx:value>number</jsx:value>
    </li>
</jsx></ul>
```

#### <a _html="true" name="jsx:if"/>
`<jsx:if test>`

Only applies the nodes below if the condition is true

```html
<jsx:if test="state.items.length &gt 0">
    <ul><li jsx:map="state.items>
       Item: <jsx:value>_</jsx:value>
    </li></ul>
</jsx>
<jsx:else>
    No items.
</jsx:else>
```

#### <a _html="true" name="jsx:value"/>
`<jsx:value>`

Evaluates the given `EXPRESSION` and adds its result to the content of the current node (the parent of the `jsx:value` node).

#### <a _html="true" name="jsx:attribute"/>
`<jsx:attribute name= when= do=>`

Sets/adds the attribute with the given `name` when the given condition is true.

 - `name` is the name of the attribute to be set in the current node 
 - `when` is an optional condition to be met for the attribute to be set 
 - `do` is optional and can be either `set` or `add`, defining whether the attribute value is to be reset of expanded (useful for `class`).


The content of the `<jsx:attribute>` element is the `{}`-expression or text value to be used.

<blockquote><div class='content'><ul class=''list> <jsx:attribute name="class" when="items.length==0" do=''add>empty</jsx:attribute> ‥

</div></blockquote>#### <a _html="true" name="jsx:style"/>
`<jsx:style name= when=>`

Sets the style (CSS) attribute with the given `name` when the given condition is true (if specified).

 - `name` is the name of the attribute to be set in the current node 
 - `when` is an optional condition to be met for the attribute to be set


The content of the `<jsx:attribute>` element is the `{}`-expression or text value to be used.

<path _html="true" d="M0,0 L100,100">
 &lt;jsx:style name=
<quote>strokeWidth</quote>
:1.5 * _.strength&lt;/jsx:style&gt; 
</path>
#### <a _html="true" name="jsx:children"/>
`<jsx:children>`

Inserts the children that might have been passed whe composing the component into another component.

Here is how you would define the children of an embedded component:

```html
<jsx:component jsx:class="Dialog">
   <p>Are you sure you would like to remove this item?</p>
</jsx:component>
```

And here is how to use the `<jsx:children>` element

```html
<jsx:Component jsx:class="Dialog">
   <div class="Dialog">
       <div class="message">
           <jsx:children />
       </div>
       <div class="actions">
           <button>Yes</button>
           <button>No</button>
       </div>
   </div>
</jsx:component>
```

#### <a _html="true" name="jsx:T"/>
`<jsx:T>`

Feeds the content of the node through the global JavaScript `T` function. `T` is expected to be `T(text:String,lang:String?):String`.

```html
<jsx:T>Hello, world</jsx:T>
```

```html
<jsx:T>{"Hello" + ", world"}<jsx:T>
```

### Attributes reference

#### <a _html="true" name="@jsx:map"/>
`@jsx:map jsx:each`

The current node will be repeated as many times as there are elements in the array returned by `EXPRESSION`.

If `jsx:each` is specified, then the variable with the given `NAME` will be used for iteration, otherwise it defaults to `_`.

```html
<ul class="people">
    <li class="person" jsx:map="data.people" jsx::with="person">
      <!-- The name will be replaced by `Unnamed person` if missing -->
      <span class="name" jsx:value="person.name">Unnamed person</span>
      <!-- while the age will be empty if the value if missing -->
      <span class="age"  jsx:value="person.age"></span>
    </li>
</div>
```

> Note: > > With React, a `key` will be automatically inserted based on the > index unless a `key` attribute is already there.

#### <a _html="true" name="@jsx:value"/>
`@jsx:value`

The attribute variant of <jsx:value>. Evaluates the given `value` and replaces the current node's content with it _unless_ it is null or undefined. In this case, the default content of the node will be used.

```html
<div class="person">
    <!-- The name will be replaced by `Unnamed person` if missing -->
    <span class="name" jsx:value="_.name">Unnamed person</span>
    <!-- while the age will be empty if the value if missing -->
    <span class="age"  jsx:value="_.age"></span>
</div>
```



