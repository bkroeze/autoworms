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
  @return {*} Array of move options if worm does not know where to go, else a direction index or null if no options
  ###
  nextMove: (used) ->
    key = Worm.usedToKey(used)
    if @brain[key]?
      return @brain[key]
    choices = []
    for dir, i in used
      if not dir
        choices.push(i)

    if choices.length is 0
      return null
    else if choices.length is 1
      return choices[0]
    choices


  update: (used, direction) ->
    @brain[Worm.usedToKey(used)] = direction

module.exports = Worm