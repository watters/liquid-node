Range = require "./range"
Promise = require "bluebird"

isString = (input) ->
  Object::toString.call(input) is "[object String]"

module.exports = class Iterable
  first: ->
    @slice(0, 1).then (a) -> a[0]

  map: ->
    @toArray().map arguments...

  sort: ->
    args = arguments
    @toArray().then (a) ->
      a.sort args...

  toArray: ->
    @slice 0

  slice: ->
    throw new Error "#{@constructor.name}.slice() not implemented"

  last: ->
    throw new Error "#{@constructor.name}.last() not implemented"

  @cast: (v) ->
    if v instanceof Iterable
      v
    else if v instanceof Range
      new IterableForArray v.toArray()
    else if Array.isArray(v) or isString(v)
      new IterableForArray v
    else if v?
      new IterableForArray [v]
    else
      new IterableForArray []

class IterableForArray extends Iterable
  constructor: (@array) ->

  slice: ->
    Promise.cast @array.slice arguments...

  last: ->
    Promise.cast @array[@array.length - 1]
