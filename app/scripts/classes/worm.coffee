class Worm
  constructor: (@color) ->
    @brain = {}

  @usedToKey: (used) ->
    key=[]

    for use in used
      key.push(use)

    return key.join(':')

  ###
  Find the next direction to move, based on the "used" status of a given
  location.

  @param used {Array}
  ###
  nextMove: (used) ->
    key = Worm.usedToKey(used)
    if @brain[key]?
      return @brain[key]
    null

  update: (used, direction) ->
    @brain[Worm.usedToKey(used)] = direction
    
module.exports = Worm