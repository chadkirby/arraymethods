
module.exports = {
   every: (arr, testFn) -> # slightly faster than [].every
      for item, i in arr when not testFn(item, i)
         return no
      return yes

   any: (arr, testFn) -> 
      for item, i in arr when testFn(item, i)
         return yes
      return no

   unique: (me, compareFn) ->
      out = {}
      if compareFn?
         for val in me
            val = compareFn(val)
            out[val] = val
      else
         out[val] = val for val in me
      value for key, value of out

   isNumber: (n) -> !isNaN(parseFloat(n)) && isFinite(n)

   isInt: (value) ->
      not isNaN(parseInt(value, 10)) and (parseFloat(value, 10) is parseInt(value, 10))
}