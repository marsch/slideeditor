define [], () ->
  'use strict'


  class SlideElement
    el: null
    selected: false
    initEvents: () ->
      console.log 'init draggable'
      @el.click (evt) =>
        evt.stopPropagation()
        @onSelect()

      @el.dblclick @onEdit

      $('#slidePane').click (evt) =>
        console.log 'evt', evt
        if @selected == false
          return
        @onDeselect()

    onSelect: () =>
      @el.addClass 'selected'
      @el.resizable({
        handles: 'n, e, s, w, ne, se, sw, nw'
      })
      @el.draggable({containment: 'parent'})
      @selected = true
      $(@).trigger 'select', @

    onDeselect: () =>
      @el.removeClass 'selected'
      @el.resizable('destroy')
      @el.draggable('destroy')
      @selected = false
      $(@).trigger 'deselect', @

    onEdit: () =>
      @ctxMenu = @getCtxMenu()
      console.log 'ctxmenu', @ctxMenu
      $('#contextMenu').empty().append(@ctxMenu)
      $(@).trigger 'edit'



