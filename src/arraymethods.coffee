{
  every
  any
  unique
} = require './utils'

listString = require './listString'

last = (me) -> me[me.length-1]
first = (me) -> me[0]

sortBy = (me, property) ->
   me.sort (a,b) -> a[property] - b[property]

clump = (me, n=2) -> for j in [0...me.length] by n
   for i in [0...n] when (i+j) < me.length
      me[i+j] 

normalize = (me) -> 
   sum = 0
   for num in me # much faster than [].reduce
      sum += num
   for num, i in me
      me[i] /= sum

{defineProperty} = Object
unless defineProperty?
  defineProperty = (object, name, descriptor) ->
    if descriptor.get?
      object.__defineGetter__ name, descriptor.get
    else if descriptor.value?
      object[name] = descriptor.value

module.exports = {
   last
   listString
   sortBy
   unique
   clump
   normalize
   any
   pollute: ->
      for name, fn of module.exports when name isnt 'pollute'
        do(fn) ->
          descriptor = { 
             enumerable: no 
             value: (args...) -> fn.apply(null, [this].concat(args))
          }
          defineProperty Array::, name, descriptor unless Array::[name]?
}

if require.main is module
   exec = require('child_process').exec
   exec 'cake build', (error, stdout, stderr) -> 
      console.log {error, stdout, stderr}
   module.exports.pollute()
   console.log [1,2,3].listString()
   console.log [1,2,3].normalize()
   console.log [1,2,3].last()
   console.log ['apple', 'Apple'].unique (item) -> item.toUpperCase()