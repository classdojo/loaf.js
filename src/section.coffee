class Section

  ###
  ###

  __isLoafSection: true

  ###
  ###

  constructor: (@nodeFactory = document) ->

    # need to have a temporary placeholder so we can
    # create a linked list

    # create a few invisible markers
    @start = nodeFactory.createTextNode ""

    # note - END is necessary because there might be a few embedded loafs, where the
    # new END node to this loaf might belong to another end node.
    @end   = nodeFactory.createTextNode ""

    @_addParent()

  ###
  ###

  replace: (node) ->
    # TODO

  ###
  ###

  insertFirst: (node) ->
    # TODO

  ###
  ###

  insertLast: (node) ->
    # TODO

  ###
  ###

  show: () ->
    return unless @_detached
    @_addParent()

    allElements = []

    for node in @_detached
      if node.parentNode and (childLoad = node.parentNode._loaf)
        node.parentNode._loaf = undefined
        allElements.push childLoad.toFragment()
      else
        allElements.push node 


    @append allElements...
    @_detached = undefined

  ###
  ###

  hide: () ->
    @_detached = @getChildNodes()
    @_detached.shift()
    @_detached.pop()
    for child in @_detached
      @start.parentNode.removeChild child


  ###
  ###

  append: (children...) ->
    @_insertAfter children, @end.previousSibling

  ###
  ###

  prepend: (children...) ->
    @_insertAfter children, @start

  ###
  ###

  replaceChildNodes: () ->
    @removeChildNodes()
    @append arguments

  ###
  ###

  toString: () -> 
    buffer = @getChildNodes().map (node) ->
      node.innerHTML or String(node)
    buffer.join("")

  ###
  ###

  toFragment: () ->
    @nodeFactory.createFragment @getChildNodes()...

  ###
  ###

  dispose: () ->
    for child in @getChildNodes()
      child.parentNode.removeChild child

  ###
  ###

  getChildNodes: () ->

    @_addParent()

    cn = @start
    end = @end.nextSibling

    children = []

    while cn isnt end
      children.push cn
      cn = cn.nextSibling

    children

  ###
  ###

  _insertAfter: (newNodes, refNode) ->

    @_addParent()

    p = refNode.parentNode

    for child in newNodes
      if child.__isLoafSection
        child._parent = @
        child = child.toFragment()

      p.insertBefore child, refNode.nextSibling
      refNode = child

  ###
  ###

  _addParent: () ->
    unless @start.parentNode
      parent = @nodeFactory.createElement "div"
      parent._loaf = @
      parent.appendChild @start
      parent.appendChild @end



module.exports = Section