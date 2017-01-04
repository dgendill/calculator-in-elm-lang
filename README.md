# A Calculator Build With Elm

This is a basic calculator component build with elm.  See the demo in [dist/index.html](http://htmlpreview.github.io/?https://github.com/dgendill/calculator-in-elm-lang/blob/master/dist/index.html).

# Changelog

- Version 2
  1. No longer using String.eval.  Built a property postfix expression parser.
  2. Added multiplication and division.

- Version 1
  1. The calculator works

# Dependencies

[Install elm first](https://guide.elm-lang.org/install.html)

# Compilation and Usage

You can compile the elm component with `npm run build`, or `elm-make src/Calculator.elm --output=dist/calculator.js`.  If you include the `calculator.js` file on a page, you can create the
calculator on a dom node like this...

```javascript
// Query however you choose...
var node = document.getElementById('calc');

// accepts a Node
Elm.Calculator.embed(node);
```
See `dist/index.html` for an example.

# Elm Reactor

You can also run `elm-reactor` in the project root, and visit [http://localhost:8000/src/Calculator.elm](http://localhost:8000/src/Calculator.elm) to see the
individual component working and make changes to Calculator.elm.

# Tests

There are some basic tests in the `tests` folder you can run with `elm test`.  To install elm test run `npm install -g elm-test`.

If you need to test individual components like the Expression.elm, you can start the repl and import the library, e.g.

```
elm repl
---- elm-repl 0.18.0 -----------------------------------------------------------
 :help for help, :exit to exit, more at <https://github.com/elm-lang/elm-repl>
--------------------------------------------------------------------------------
> import Expression exposing(..)
```

You can then test the functions and datatypes that are exposed in the repl.
