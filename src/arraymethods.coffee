{
  every
  any
  unique
  isNumber
} = require './utils'

{listCoffeeArrStr, listString} = require './listString'

last = (me) -> me[me.length-1]
first = (me) -> me[0]

sortBy = (me, property) ->
    me.sort (a,b) ->
        a = a[property]
        b = b[property]
        if a.localeCompare?
            a.localeCompare b
        else
            a - b

findBy = (me, properties = {}) ->
  for item in me
    match = yes
    for own key, val of properties when item[key] isnt val
      match = no
      break
    return item if match

  return null

clump = (me, n=2) -> for j in [0...me.length] by n
   for i in [0...n] when (i+j) < me.length
      me[i+j]

normalize = (me) ->
   sum = 0
   for num in me # much faster than [].reduce
      sum += num
   for num, i in me
      me[i] /= sum

wrapAt = (me, index) ->
  me[index % me.length]

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
   listCoffeeArrStr
   sortBy
   findBy
   unique
   clump
   normalize
   any
   wrapAt
   pollute: ->
      for own name, fn of module.exports when name isnt 'pollute'
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
   arr = [
       {a: 1},
       {a: 0}
   ]
   console.log sortBy(arr, 'a')
   arr = [
       {a: 'b'},
       {a: 'a'}
   ]
   console.log sortBy(arr, 'a')
