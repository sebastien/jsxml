
## JSXML: Generate React render code from XML

---
project: JSXML
url: https://github.com/sebastien/jsxml
license: MIT
version: 0.0.0
---

JSXML is a set of XSL stylesheets that transform XML into JavaScript code equivalent to JSX. Unlike JSX, JSXML is easy to parse (it uses XML) and can easily be re-targetted to different rendering engines (React, Inferno, D3, etc‥).

One of the main drawback of JSX is that it introduces a tigh coupling between the JavaScript (the controller) and the HTML code (the view) by enourage you to mix view code within controller code.

The JSX XSLT Templates allows you to write XML documents that are automatically rendered to an UMD JavaScript module definining the JSX equivalent (using `React.createElement`) that can be readily imported as view.

The result is that the view can be written predominently in XML/XHTML and can be dynamically integrated with the controller at runtime using dynamic module loading.

## Quick start

Create a file named `view.xml`

```
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" media="screen" href="https://cdn.rawgit.com/sebastien/jsxml/master/dist/jsxml.xsl"?>
<jsx:Component(xmlns::jsx="https://github.com/sebastien/jsxml",xmlns::on="https://github.com/sebastien/jsxml/actions")
   Hello, world!
</jsx:Component>
```

Now open this file using your browser, and you should see the following code:

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

## Overview

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

Note how HTML tags are not prefixed by any namespace while JSXML directives are within the `jsxml` namespace.

### JSX Elements in a nutshell

#### Namespaces

 - __jsxml__: <https://github.com/sebastien/jsxml> -- base namespace 
 - __on__: <https://github.com/sebastien/jsxml/extra/on> -- used for event handlers 


#### Root

 - [`<jsx:Component>CONTENT‥`](#jsx:Component) declares a component. This is the _root node_ of JSXML.


#### Node content

 - [`<jsx:value>`](#jsx:value) evaluates a (JS) expression and returns its content


 - [`<jsx:attribute name=>`](#jsx:attribute) Sets an attribute on the current node.


 - [`<jsx:map value= with=>`](#jsx:map) Iterates over the given `value`


 - [`<jsx:T>`](#jsx:T) dynamically translates the given string through the JavaScript defined `T` function.


#### Control flow

 - [`<jsx:if test=>`](#jsx:if) Applies the current node only if the condition is true


 - [`<jsx:elif test=>`](#jsx:if) Applies a consecutive test right after an `jsx:if>


 - [`<jsx:else>`](#jsx:else) Applies the current node if all the other conditions have failed


#### Templates

 - [`<jsx:Template name=>`](#jsx:Template) declares a new re-usable snippet within a _component_.


 - [`<jsx:apply template jsx:map= jsx:with=>`](#jsx:apply) applies a `jsx:Template` to the current node., optionally mapping it to the given name.


#### Modules

 - [`<jsx:import value from as>`](#jsx:import) imports an external component so that it can be referenced using `<jsx:component>`


 - [`<jsx:component class>`](#jsx:component) instanciates an imported component.


### JSXML Attributes

 - [`@jsx:map`+`@jsx:with`](#@jsx:map) Maps the selected items to the contents of the node. Works for both arrays and objects.


 - [`@jsx:value`](#@jsx:value) replaces the element's content with the given value


 - [`@jsx:if`](#@jsx:if) Only add the node if the given condition is valid.


 - [`@jsx:as`/`@jsx:ref`](#@jsx:as) creates a reference (accessible in the underlying JavaScript) to the current rendered node.


### Special namespace attributes

 - [`@on:*`](#@on:event) registers a callback to handle the given event.


## The JSXML language

<dl>

<dt><a name=jsx:Component>`<jsx:Component name="NAME">`<dt>
<dd>Declares a new JSX component

 - `name` is the variable name to which the created `ReactElement` factory will be bound. If not specified, it will default to `View`.


```html
<jsx:Component name="Button">
   <button jsx:text="data.name">Untitled button</button>
</jsx:Component>
```

</dd>

<dt>`<jsx:Template name="NAME" param="NAME>`<dt>
<dd>Defines a named template that can be referenced with [<jsx:apply>](#apply)

 - `name` is the name of the template, referenced in `apply` 
 - _`param`_, the optional parameter name for the given data (`_` by default)


```html
<ul>
  <li jsx:map="state.items>
    <!-- This is where the template is REFERENCED -->
    <jsx:apply template="item" />
  </li>
</ul>
<!-- This is where the template is DECLARED -->
<jsx:Template name="item" param="item">
   <span jsx:text="item.name" />
   <span jsx:text="item.value />
</jsx:Template>
```

</dd>

<dt>`<jsx:value>EXPRESSION</jsx:value>`<dt>
<dd>Evaluates the given `EXPRESSION` and adds its result to the content of the current node (the parent of the `jsx:value` node).

</dd>

<dt>`<jsx:component jsx:class="CLASSNAME" js:ref="REF" data="EXPRESSION" options="EXPRESSION">NODES</jsx:component>`<dt>
<dd>TODO

</dd>

<dt>`<jsx:apply template="NAME">`<dt>
<dd>Applies the template with the given name. This requires a previously defined `<jsx:Template name=NAME>` tag in the document.

```html
<jsx:apply template="placeholder />
<jsx:Template name="placeholder">Lorem ipsum dolor sit amet‥</jsx:Template>
```

Note that you can use the [`jsx:map`](#jsx-map) attribute in the `jsx:apply` element.

</dd>

<dt>`jsx:value="EXPRESSION"`<dt>
<dd>Indicates that the content of the current element will be replaced by the the value of the given `EXPRESSION` (in JavaScript)

When the expression evaluates to either to `null`, `false` or `undefined`, then the default value will be used.

```html
<div class="person">
    <!-- The name will be replaced by `Unnamed person` if missing -->
    <span class="name" jsx:value="_.name">Unnamed person</span>
    <!-- while the age will be empty if the value if missing -->
    <span class="age"  jsx:value="_.age"></span>
</div>
```

</dd>

<dt>`jsx:map=''EXPRESSION" jsx:with="NAME''<dt>
<dd>The current node will be repeated as many times as there are elements in the array returned by `EXPRESSION`.

If `jsx:with` is specified, then the variable with the given `NAME` will be used for iteration, otherwise it defaults to `_`.

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

</dd>


</dl>



