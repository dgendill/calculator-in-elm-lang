# A Calculator Build With Elm

This is a basic calculator component build with elm.  See the demo in [dist/index.html](http://htmlpreview.github.io/?https://github.com/dgendill/calculator-in-elm-lang/blob/master/dist/index.html).

# Dependencies

[Install elm first](https://guide.elm-lang.org/install.html)

# Compilation and Usage

You can compile the elm component with `npm run build`, or `elm-make src/Calculator.elm --output=dist/calculator.js`.  If you include the `calculator.js` file on a page, you can create the
calculator on any node like this...

```javascript
// Query however you choose...
var node = document.getElementById('calc');

// accepts a Node
Elm.Calculator.embed(node);
```
See `dist/index.html` for an example.

# Elm Reactor

You can also run `elm-reactor` in the project root, and visit http://localhost:8000/src/Calculator.elm
