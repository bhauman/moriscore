# MoriScore

Giving mori.js underscore like usage patterns.

## Usage

Just grab the `moriscore.js` script from the resources directory and
include it in your project.

## Examples

### OOP like usage

You can wrap a mori data stucture so that you can call the various
mori operations on it.

```javascript

m_(m_.vector(1,2,3,4)).first() //=> 1

m_(m_.vector(1,2,3,4)).last() //=> 4

m_(m_.vector(1,2,3,4)).map(m_.inc) //=> mori vector [2 3 4 5]

m_(m_.hash_map({first: "John", last: "Doe"})).assoc("middle", "A")
//=> { :first "John" :last "Doe" :middle "A"}

```

This works in the same way that it works in underscore.js. The call to
the wrapper will return the raw Mori datastructure. If you want to
operate on the new value you have to wrap it again.

### Chaining

Chaining works the same way it does in underscore as well.

```javascript

m_.chain(m_.vector(1,2,3,4)).conj(5).conj(6).value() // => [1 2 3 4 5 6]

m_(m_.vector(1,2,3,4)).chain().conj(5).conj(6, 7).value() 
// => [1 2 3 4 5 6 7]

```

Chaining is so common that I created the `m$` as a short hand for `m_.chain`.

```javascript

m$({first: "John", last: "Jackson"}).assoc("middle", "A").assoc("birthday", Date.now()).value()

```

### Creating mori structures

You can create wrapped Mori data structures from native javascript
structures by simply passing javascript structures into the `m_`
function. The javascript strutures are coerced with the mori function
`js_to_clj`.

```javascript

// creates a mori hash_map
m_({ first: "John", last: "Doe" }) //=> #wrapped { :first "John" :last "Doe" }

// creates a mori vector
m_([1,2,3,4])          //=> #wrapped [1 2 3 4]

```

