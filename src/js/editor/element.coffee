define [
  'uuid-js'
  'loglevel'
], (UUIDjs, log) ->
  'use strict'


  class SlideElement
    el: null
    selected: false
    disposed: false
    constructor: () ->
      @cid = UUIDjs.create().toString()

    initEvents: () ->
      log.debug 'init draggable'
      @el.click (evt) =>
        evt.stopPropagation()
        @onSelect()

      @el.dblclick @onEdit

    onSelect: () =>
      @el.addClass 'selected'
      @el.resizable({
        handles: 'n, e, s, w, ne, se, sw, nw'
      })
      @el.draggable({containment: 'parent'})
      @selected = true
      $(@).trigger 'select', @

      @ctxMenu = @getCtxMenu()
      log.debug 'ctxmenu', @ctxMenu
      $('#contextMenu').empty().append(@ctxMenu)

      @ctxMenu.on 'click', '[data-id=moveup-btn]', @moveUp
      @ctxMenu.on 'click', '[data-id=movedown-btn]', @moveDown

    onDeselect: () =>
      @el.removeClass 'selected'
      @el.resizable('destroy')
      @el.draggable('destroy')
      @selected = false
      $(@).trigger 'deselect', @
      @ctxMenu.off()

    onEdit: () =>
      $(@).trigger 'edit'

    moveUp: () =>
      $(@).trigger 'moveUp'
      log.debug 'moveUp'
      # every element needs to have a non auto z-index
      cur = @el.css('z-index')
      cur = parseInt(cur, 10) + 1
      @el.css('z-index', cur)

    moveDown: () =>
      $(@).trigger 'moveDown'
      log.debug 'moveDown'
      # every element needs to have a non auto z-index
      cur = @el.css('z-index')
      cur = parseInt(cur, 10) - 1
      if cur > 0
        @el.css('z-index', cur)

    dispose: () =>
      log.debug 'disposing', @
      return if @disposed
      @el.off()
      log.debug 'removing'
      @el.remove()
      @disposed = true



