define [
  'cs!editor/elements/textelement'
  'cs!editor/elements/imageelement'
  'underscore'
], (TextElement, ImageElement, _) ->
  'use strict'

  class Editor
    areaSelector: '#slidePane'
    constructor:() ->

      $(document).on 'paste', @onPaste

      $('#addNormal').click @addTextElement('normal')
      $('#addHeading1').click @addTextElement('headline1')
      $('#addHeading2').click @addTextElement('headline2')

      $('#addImg').click @addImageElement

    addTextElement: (mode='normal') ->
      () =>
        console.log 'add textnode'
        n = new TextElement()
        n.create(mode)
        $(n).on 'select', (evt, element) =>
          @ctxMenu = element.getCtxMenu()
          $('#contextMenu').empty().append(@ctxMenu)

        $(n).on 'deselect', (evt, element) ->
          $('#contextMenu').empty()
        $('#slidePane').append(n.el)

    addImageElement: (options = {}) ->
      console.log 'add imagenode'
      n = new ImageElement()
      n.create(options)
      $(n).on 'select', (evt, element) =>
        @ctxMenu = element.getCtxMenu()
        $('#contextMenu').empty().append(@ctxMenu)

      $(n).on 'deselect', (evt, element) ->
        $('#contextMenu').empty()
      $('#slidePane').append(n.el)



    addShapeElement: () ->


    getContent: () ->
      $(@areaSelector).html()

    setContent: (html) ->
      $(@areaSelector).html(html)

      #find elements an load them into the classes
      textElements = $(@areaSelector).find('[data-type=textElement]')
      imageElements = $(@areaSelector).find('[data-type=imageElement]')

      console.log 'found texts', textElements
      console.log 'found images', imageElements

      _(textElements).each (elem) ->
        n = new TextElement()
        n.import $(elem)

      _(imageElements).each (elem) ->
        n = new ImageElement()
        n.import $(elem)

    onPaste: (evt) =>
      imageMatch = /image.*/

      console.log 'paste evt', evt
      cpData = evt.originalEvent.clipboardData
      console.log 'cpdata',cpData.items[0]
      _(cpData.types).each (type, i) =>
        console.log 'handle type:', type
        if type.match && type.match(imageMatch) || cpData.items[i].type.match(imageMatch)
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
