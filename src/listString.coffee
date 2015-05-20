{
  every
  any
  unique
  isInt
} = require './utils'

Articles = require 'articles'

listString = (me, andor, article, comma = ', ') ->
   isRange = not andor?
   andor ?= 'and'
   andOrProvided = andor?.length > 0

   isRange = every me, isInt
   if isRange
      # is numeric range
      arr = consolidateRanges(parseInt(a) for a in me)
   else # test if alphabetic range
      isRange = every me, (item) -> /^[a-z]$/i.test(item)
      arr = consolidateAlphaRanges(me) if isRange

   if me.length > 2
      if isRange 
         delimiter = comma if arr.length > 2
      else
         complex = any me, (item) -> /,/.test(item)
         delimiter = if complex then '; ' else comma

   unless delimiter?
      delimiter = if andOrProvided then andor else ''
      delimiter = " #{delimiter} " if /^[\w\/]+$/i.test(delimiter)

   unless arr?
      arr = me[..] # (item for item in me when item?) 
   # add articles
   if /^an?$/.test article
      arr = for item in arr
         Articles.articlize(item)
   else if article?.length > 0
      arr = ("#{article} #{item}" for item in arr)

   arr.push "#{andor} #{arr.pop()}" if andOrProvided and (arr.length > 2)
   arr.join delimiter

listCoffeeArrStr = (me) ->
   arr = consolidateRanges(me, '..')
   if arr.length > 1 and any(arr, (item) -> /\d\.\.\d/.test(item))
      "[].concat.call([#{arr.join '], ['}])"
   else
      "[#{arr.join ', '}]"

consolidateRanges = (inputArray, delimiter = '–') ->
    arr = unique(inputArray).sort (a,b) -> a-b
    rangeEnds = []
    rangeBegs = []
    for num, i in arr
      rangeBegs.push(num) unless num is arr[i-1]+1
      rangeEnds.push(num) unless num is arr[i+1]-1

    for start, i in rangeBegs
      end = rangeEnds[i]
      if start is end
          start
      else
          "#{start}#{delimiter}#{end}"

consolidateAlphaRanges = (inputArray, delimiter = '–') ->
    arr = unique(inputArray).sort()
    rangeEnds = []
    rangeBegs = []
    for ltr, i in arr
         rangeBegs.push(ltr) unless ltr.charCodeAt() is arr[i-1]?.charCodeAt()+1
         rangeEnds.push(ltr) unless ltr.charCodeAt() is arr[i+1]?.charCodeAt()-1

    for start, i in rangeBegs
         end = rangeEnds[i]
         if start is end
             start
         else
             "#{start}#{delimiter}#{end}"

module.exports = {listString, listCoffeeArrStr}

if require.main is module
   exec = require('child_process').exec
   exec 'cake build', (error, stdout, stderr) -> 
      console.log {error, stdout, stderr}

   console.log listCoffeeArrStr [1,2,3,4]
   console.log listCoffeeArrStr [1,2,3,4, 11, 21, 22, 23]
   console.log listCoffeeArrStr [1,3,5]
