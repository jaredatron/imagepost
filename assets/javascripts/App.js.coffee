component = React.component
{div, span, textarea, img, input, label, select, option} = React.DOM

@App = component
  render: ->
    div
      className: "page"
      ImagePost()

ImagePost = component

  mixins: [React.addons.LinkedStateMixin]

  getInitialState: ->
    height: 300
    width: 400
    fontFamily: 'Georgia'
    fontSize: 20
    textAlign: 'tl'
    backgroundColor: 'white'
    textColor: 'black'
    text: "People of earth\ntake me to your leader"

  render: ->
    div
      className: "ImagePost",

      ImagePostRendering(@state)

      FormGroup
        label: 'Height'
        input
          type:     'number'
          valueLink: @linkState('height')

      FormGroup
        label: 'Width'
        input
          type:     'number'
          valueLink: @linkState('width')

      FormGroup
        label: 'Background Color'
        ColorPickerInput
          valueLink: @linkState('backgroundColor')


      FormGroup
        label: 'Text Align'
        TextAlignSelectInput
          valueLink: @linkState('textAlign')

      FormGroup
        label: 'Font Family'
        FontFamilySelectInput
          valueLink: @linkState('fontFamily')

      FormGroup
        label: 'Font Size'
        input
          type:     'number'
          valueLink: @linkState('fontSize')

      FormGroup
        label: 'Text Color'
        ColorPickerInput
          valueLink: @linkState('textColor')

      FormGroup
        label: 'Text'
        ImagePostTextInput
          valueLink: @linkState('text')


FormGroup = component
  focusFirstInput: ->
    $(@getDOMNode()).find(':input:first').focus()

  render: ->
    div
      className: 'FormGroup'
      label
        onClick: @focusFirstInput
        @props.label
      @props.children

AvailableFontFamilies = {
  'Georgia':   'Georgia, serif',
  'Palatino':  '"Palatino Linotype", "Book Antiqua", Palatino, serif',
  'Times':     '"Times New Roman", Times, serif',
  'Sans':      'Sans-Serif Fonts',
  'Arial':     'Arial, Helvetica, sans-serif',
  'Arial':     '"Arial Black", Gadget, sans-serif',
  'Comic':     '"Comic Sans MS", cursive, sans-serif',
  'Impact':    'Impact, Charcoal, sans-serif',
  'Lucida':    '"Lucida Sans Unicode", "Lucida Grande", sans-serif',
  'Tahoma':    'Tahoma, Geneva, sans-serif',
  'Trebuchet': '"Trebuchet MS", Helvetica, sans-serif',
  'Verdana':   'Verdana, Geneva, sans-serif',
  'Monospace': 'Monospace Fonts',
  'Courier':   '"Courier New", Courier, monospace',
  'Lucida':    '"Lucida Console", Monaco, monospace',
}

FontFamilySelectInput = component
  render: ->
    options = Object.keys(AvailableFontFamilies).map (name, index) ->
      value = AvailableFontFamilies[name]
      option(key: index, value: value, name)

    select
      valueLink: @props.valueLink
      options


TextAlignSelectInput = component
  getInitialState: ->
    name: "TextAlignSelectInput-#{Math.round(Math.random() * 10000000)}"

  render: ->
    currentValue = @props.valueLink && @props.valueLink.value || @props.value
    requestChange = @props.valueLink && @props.valueLink.requestChange
    onChange = @props.onChange

    radio = (value) =>
      input
        type:'radio',
        name: @state.name,
        value: value,
        checked: value == currentValue
        onChange: (event) ->
          requestChange && requestChange(event.target.value)
          onChange && onChange(event)

    div
      className: 'TextAlignSelectInput'
      div null,
        radio('tl')
        radio('tc')
        radio('tr')
      div null,
        radio('ml')
        radio('mc')
        radio('mr')
      div null,
        radio('bl')
        radio('bc')
        radio('br')

ColorPickerInput = component
  render: ->
    select(@props,
      option(value: 'white', 'white')
      option(value: 'black', 'black')
      option(value: 'red', 'red')
      option(value: 'orange', 'orange')
    )


ImagePostTextInput = component
  render: ->
    textarea
      className: "ImagePostTextInput"
      valueLink: @props.valueLink

ImagePostRendering = component
  render: ->

    imgSrc = renderImageSrc(@props)

    div
      className: "ImagePostRendering"
      style:
          height: @props.height+'px'
          width:  @props.width+'px'
      img
        src: imgSrc


renderImageSrc = (props) ->
  fontSize        = Number(props.fontSize)
  fontFamily      = String(props.fontFamily)
  height          = Number(props.height)
  width           = Number(props.width)
  textColor       = String(props.textColor)
  backgroundColor = String(props.backgroundColor)

  canvas = document.createElement('canvas')
  canvas.height = height
  canvas.width  = width
  context = canvas.getContext("2d")


  context.fillStyle = backgroundColor
  context.fillRect(0,0,width,height)

  context.font = "#{fontSize}px #{fontFamily}"
  context.fillStyle = textColor
  context.textBaseline = 'bottom'

  lines = props.text.split("\n")

  switch props.textAlign[1]
    when 'l'
      context.textAlign = 'start'
      x = 0
    when 'c'
      context.textAlign = 'center'
      x = (width / 2)
    when 'r'
      context.textAlign = 'end'
      x = width

  switch props.textAlign[0]
    when 't'
      y = fontSize
    when 'm'
      y = (height / 2) - (fontSize / 2)
    when 'b'
      y = height - (fontSize*(lines.length-1))

  lines.forEach (line) ->
    context.fillText(line, x, y)
    y += fontSize



  window.DEBUG_CANVAS = canvas
  window.DEBUG_CANVAS_CONTEXT = context

  return canvas.toDataURL("image/png")
