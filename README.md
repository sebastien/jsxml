
## JSXML: Generate code for React, D3, etc. from XML

---
project: JSXML
url: https://github.com/sebastien/jsxml
license: MIT
version: 0.0.0
---

JSXML is a set of XSL stylesheets that transform XML into JavaScript code equivalent to JSX. Unlike JSX, JSXML is easy to parse (it uses XML) and can easily be re-targetted to different rendering engines (React, Inferno, D3, etc‥).

## Quick start

One of the main drawback of JSX is that it introduces a tigh coupling between the JavaScript (the controller) and the HTML code (the view).

The JSX XSLT Templates allows you to write XML documents that are automatically rendered to an UMD JavaScript module definining the JSX equivalent (using `React.createElement`).

The result is that the view can be written predominently in XML/XHTML and can be dynamically integrated with the controller at runtime using dynamic module loading.

The JSX XSLT Template defines the following elements:

## Overview

A complete JSXML example looks like that

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

### Elements

#### Root

<dl>

<dt>[`<jsx:Component>`](#jsx:Component)<dt>
<dd>declares a component. This is the _root node_ of JSXML.</dd>


</dl>

#### Node content

<dl>

<dt>[`<jsx:value>`](#jsx:value)<dt>
<dd>evaluates a (JS) expression and returns its content</dd>

<dt>[`<jsx:attribute>`](#jsx:attribute)<dt>
<dd>Sets an attribute on the current node.</dd>

<dt>[`<jsx:map>`](#jsx:map)<dt>
<dd>Iterates over the given items</dd>

<dt>[`<jsx:T>`](#jsx:T)<dt>
<dd>dynamically translates the given string</dd>


</dl>

#### Control flow

<dl>

<dt>[`<jsx:if>`](#jsx:if)<dt>
<dd>Applies the current node only if the condition is true</dd>

<dt>[`<jsx:else>`](#jsx:else)<dt>
<dd>Applies the current node if all the other conditions have failed</dd>

<dt>[`<jsx:choose>`](#jsx:map)<dt>
<dd>Wraps a series of `<jsx:if>`‥<jsx:else>.</dd>


</dl>

#### Templates

<dl>

<dt>[`<jsx:Template>`](#jsx:Template)<dt>
<dd>declares a new re-usable snippet within a _component_.</dd>

<dt>[`<jsx:apply>`](#jsx:apply)<dt>
<dd>applies a `jsx:Template` to the current node.</dd>


</dl>

#### Modules

<dl>

<dt>[`<jsx:import>`](#jsx:import)<dt>
<dd>imports an external component so that it can be referenced using `<jsx:component>`</dd>

<dt>[`<jsx:component>`](#jsx:component)<dt>
<dd>instanciates an imported component.</dd>


</dl>

### Attributes

<dl>

<dt>[`@jsx:map`](#@jsx:map)<dt>
<dd>Maps the selected items to the contents of the node. Works for both arrays and objects.</dd>

<dt>[`@jsx:value`](#@jsx:value)<dt>
<dd>replaces the element's content with the given value</dd>

<dt>[`@jsx:if`](#@jsx:if)<dt>
<dd>Only add the node if the given condition is valid.</dd>

<dt>[`@on:*`](#@on:event)<dt>
<dd>registers a callback to handle the given event.</dd>

<dt>[`@jsx:as`](#@jsx:as)/`jsx:ref`<dt>
<dd>creates a reference (accessible in the underlying JavaScript) to the current rendered node.</dd>


</dl>

## The JSXML language

<dl>

<dt>[Component][#COMPONENT]`<jsx:Component name="NAME">`<dt>
<dd>Declares a new JSX component

[ ] `name` is the variable name to which the created `ReactElement` factory will be bound. If not specified, it will default to `View`.


```html
<jsx:Component name="Button">
   <button jsx:text="data.name">Untitled button</button>
</jsx:Component>
```

</dd>


</dl>

Defines a named template that can be referenced with [<jsx:apply>](#apply)

[ ] `name` is the name of the template, referenced in `apply` 
[ ] _`param`_, the optional parameter name for the given data (`_` by default)


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

Evaluates the given `EXPRESSION` and adds its result to the content of the current node (the parent of the `jsx:value` node).

TODO

<dl>

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



