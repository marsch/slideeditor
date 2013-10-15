define [
  'cs!editor/element'
  'hgn!templates/imageelement'
  'hgn!templates/imagedetail'
], (SlideElement, elementTemplate, ctxMenuTpl) ->

  'use strict'

  class ImageElement extends SlideElement

    import: (el) ->
      @el = el
      @initEvents()
      @img = $(@el.find('.slideImage').get(0))

    create: () ->
      @el = $(elementTemplate())

      @img = $(@el.find('.slideImage').get(0))
      @img.attr('src', 'http://geoinformatik.htw-dresden.de/Abschlussarbeiten/DA_JINDRA_2007/bilder/earth.jpg')

      @el.append(@img)
      @initEvents()

    getCtxMenu: () ->
      @ctxMenu = $(ctxMenuTpl())
      @ctxMenu.find('#imgSrc').val @img.attr('src')
      @ctxMenu.find('#imgSrc').on 'change', (evt) =>
        console.log 'changed src',arguments
        @img.attr('src', $(evt.currentTarget).val())

      @ctxMenu
