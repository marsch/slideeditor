define [
  'cs!editor/element'
  'hgn!templates/textelement_h1'
  'hgn!templates/textelement_h2'
  'hgn!templates/textelement_p'
  'hgn!templates/textdetail'
], (SlideElement, h1_tpl, h2_tpl, p_tpl, ctxMenuTpl) ->
  'use strict'

  class TextElement extends SlideElement
    import: (el) ->
      @el = el
      @txt = $(@el.find('.slideText').get(0))
      @initEvents()


    create: (options) ->
      switch options.format
        when 'headline1' then @el = $(h1_tpl())
        when 'headline2' then @el = $(h2_tpl())
        else @el = $(p_tpl())

      @txt = $(@el.find('.slideText').get(0))
      if (options.mode == 'html' && options.content)
        @txt.empty().html(options.content)
      if (options.mode == 'text' && options.content)
        @txt.empty().text(options.content)
      @el.append @txt
      @initEvents()


    onEdit: () =>
      super
      @txt.attr 'contenteditable', true
      @el.draggable('destroy')
      @txt.focus()

    onDeselect: () =>
      super
      @txt.removeAttr 'contenteditable'

    getCtxMenu: () ->
      @ctxMenu = $(ctxMenuTpl())

