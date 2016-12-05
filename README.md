# A Calculator Build With Elm

This is a basic calculator component build with elm.  See the demo in [dist/index.html]().

# Dependencies

[Install elm first](https://guide.elm-lang.org/install.html).

# Usage

You can compile the elm component with `npm run build`, or `elm-make src/Calculator.elm --output=dist/calculator.js`.  If you include this file on a page, you can create the
calculator like this...

```javascript
// Query however you choose...
var node = document.getElementById('calc');

// accepts a Node
Elm.Calculator.embed(node);
```
