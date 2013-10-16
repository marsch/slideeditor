define [
  'jquery'
  'cs!editor/elements/textelement'
  'cs!editor/elements/imageelement'
  'underscore'
  'keymaster'
  'html2canvas'
  'thumbnailer'
  'loglevel'
], ($, TextElement, ImageElement, _, key, html2canvas, thumbnailer, log) ->
  'use strict'

  class Editor
    elements: []
    areaSelector: '#slidePane'
    editing: false
    constructor:() ->
      @el = $(@areaSelector)
      key 'backspace', @onDeleteElement

      $(document).on 'paste', @onPaste

      $('#addNormal').click () =>
        @addTextElement({format: 'normal'})
      $('#addHeading1').click () =>
        @addTextElement({format: 'headline1'})
      $('#addHeading2').click () =>
        @addTextElement({format: 'headline2'})

      $('#addImg').click @addImageElement

      $(@el).click (evt) =>
        _(@elements).each (element) ->
          return if element.selected == false
          element.onDeselect()

    addTextElement: (options) =>
      console.log 'add textnode'
      n = new TextElement()
      @elements.push n
      n.create(options)
      $(n).on 'select', @onSelectElement
      $(n).on 'deselect', @onDeselectElement
      $(n).on 'edit', @onEditElement
      $(n).on 'moveUp', @onMoveUpElement
      $(n).on 'moveDown', @onMoveDownElement

      n.el.css('z-index', @elements.length + 1)

      $('#slidePane').append(n.el)

    addImageElement: (options = {}) =>
      console.log 'add imagenode'
      n = new ImageElement()
      @elements.push n
      n.create(options)
      $(n).on 'select', @onSelectElement
      $(n).on 'deselect', @onDeselectElement
      $(n).on 'moveUp', @onMoveUpElement
      $(n).on 'moveDown', @onMoveDownElement

      # set z-index default
      n.el.css('z-index', @elements.length + 1)
      $('#slidePane').append(n.el)



    addShapeElement: () ->

    onSelectElement:  (evt, element)  =>
      @ctxMenu = element.getCtxMenu()
      $('#contextMenu').empty().append(@ctxMenu)
      _(@elements).each (otherElement) =>
          if element.cid != otherElement.cid
            if otherElement.selected == true

              otherElement.onDeselect()

    onDeselectElement: () =>
      @editing = false
      $('#contextMenu').empty()

    onEditElement: () =>
      @editing = true

    getContent: () ->
      $(@areaSelector).html()

    setContent: (html) ->
      $(@areaSelector).html(html)

      #find elements an load them into the classes
      textElements = $(@areaSelector).find('[data-type=textElement]')
      imageElements = $(@areaSelector).find('[data-type=imageElement]')

      console.log 'found texts', textElements
      console.log 'found images', imageElements

      _(textElements).each (elem) =>
        n = new TextElement()
        @elements.push n
        # set z-index default
        n.el.css('z-index', @elements.length + 1)
        n.import $(elem)

      _(imageElements).each (elem) =>
        n = new ImageElement()
        # set z-index default
        n.el.css('z-index', @elements.length + 1)
        @elements.push n
        n.import $(elem)

    onPaste: (evt) =>
      imageMatch = /image.*/
      textMatch = /text\/plain/
      htmlMatch = /text\/html/
      containsHtml = /<[a-z][\s\S]*>/i


      console.log 'paste evt', evt
      cpData = evt.originalEvent.clipboardData
      console.log 'cpdata',cpData.types
      _(cpData.types).each (type, i) =>
        console.log 'handle type:', type
        if type.match(imageMatch) || cpData.items[i].type.match(imageMatch)
          file = cpData.items[i].getAsFile()
          reader = new FileReader()
          reader.onload = (evt) =>
            # should be an event on editor
            opts =
              url: evt.target.result
              event: evt
              file: file
              name: file.name

            @addImageElement opts

          reader.readAsDataURL(file)
        else if type.match(htmlMatch) || cpData.items[i].type.match(htmlMatch)
          html = cpData.getData(type)
          opts =
            format: 'normal'
            mode: 'html'
            content: html

          @addTextElement opts

        else if type.match(textMatch) || cpData.items[i].type.match(textMatch)
          # html is prefered
          if 'text/html' in cpData.types
            return
          txt = cpData.getData(type)
          if txt.match(containsHtml)
            opts =
              format: 'normal'
              mode: 'html'
              content: txt
          else
            opts =
              format: 'normal'
              mode: 'text'
              content: txt

          @addTextElement opts
          console.log 'handling text', cpData.getData(type)

    onDeleteElement: () =>
      return if @editing
      _(@elements).each (element, i) =>
        if element.selected
          element.dispose()

      @elements = _(@elements).filter (element) ->
        return element.disposed == false


    screenshot: () =>
      df = new $.Deferred()
      el = @el.get(0)
      console.log 'element', el
      html2canvas([el], {
        allowTaint: true
        useCORS: true
        onrendered: (canvas) =>
          console.log canvas
          df.resolve canvas
      })
      df

    thumbnail: () =>
      df = new $.Deferred()
      @screenshot()
        .done (canvas) =>
          img = new Image
          img.width = canvas.width
          img.height = canvas.height
          img.onload = () ->
            new thumbnailer canvas, img, 188, 8
            df.resolve canvas

      df
