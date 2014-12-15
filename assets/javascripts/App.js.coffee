component = React.component
{div, span, textarea, img, input, label, select, option, button} = React.DOM

@App = component
  render: ->
    div
      className: "page"
      ImagePost()

ImagePost = component

  mixins: [React.addons.LinkedStateMixin]

  getInitialState: ->
    height:          300
    width:           400
    fontStyle:       'normal'
    fontWeight:      'normal'
    fontSize:        20
    fontFamily:      AvailableFontFamilies[0]
    textAlign:       'tl'
    backgroundColor: 'white'
    textColor:       'black'
    textStrokeColor: 'white',
    textStrokeSize:  0,
    textPadding:     0,
    text:            "People of earth\ntake me to your leader"
    backgroundImage: null

  render: ->
    div
      className: "ImagePost",

      ImagePostRendering(@state)

      FormGroup
        label: 'Size'
        IntegerInput
          valueLink: @linkState('height')
        '  X  '
        IntegerInput
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
        label: 'Font Style'
        FontStyleSelectInput
          valueLink: @linkState('fontStyle')

      FormGroup
        label: 'Font Weight'
        FontWeightSelectInput
          valueLink: @linkState('fontWeight')

      FormGroup
        label: 'Font Size'
        IntegerInput
          valueLink: @linkState('fontSize')

      FormGroup
        label: 'Text Padding'
        IntegerInput
          valueLink: @linkState('textPadding')

      FormGroup
        label: 'Text Color'
        ColorPickerInput
          valueLink: @linkState('textColor')


      FormGroup
        label: 'Text Stroke Color'
        ColorPickerInput
          valueLink: @linkState('textStrokeColor')

      FormGroup
        label: 'Text Stroke Size'
        IntegerInput
          valueLink: @linkState('textStrokeSize')

      FormGroup
        label: 'Text'
        ImagePostTextInput
          valueLink: @linkState('text')

      FormGroup
        label: 'Background Image'
        ImageUploadInput
          valueLink: @linkState('backgroundImage')


IntegerInput = component
  render: ->
    input
      type:  'number'
      value: @props.valueLink.value
      onChange: (event) =>
        value = Number(event.target.value)
        return if isNaN(value)
        @props.valueLink.requestChange(value)

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

    select(valueLink: @props.valueLink, options)


FontStyleSelectInput = component
  render: ->
    options = ['normal','italic','oblique'].map (value, index) ->
      option(key: index, value: value, value)

    select(valueLink: @props.valueLink, options)

FONT_WEIGHTS = [
  'normal',
  'bold',
  'bolder',
  'lighter',
  '100',
  '200',
  '300',
  '400',
  '500',
  '600',
  '700',
  '800',
  '900',
]
FontWeightSelectInput = component
  render: ->
    options = FONT_WEIGHTS.map (value, index) ->
      option(key: index, value: value, value)

    select(valueLink: @props.valueLink, options)

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




ImageUploadInput = component
  onChange: (event) ->
    file = event.target.files[0]
    event.target.value = null
    return unless file.type.match('image.*')
    reader = new FileReader()
    reader.onload = @onLoad
    reader.readAsDataURL(file)

  onLoad: (event) ->
    src = event.target.result
    @props.valueLink.requestChange(src)

  clear: ->
    @props.valueLink.requestChange(null)

  render: ->
    if @props.valueLink.value
      image = img(src:@props.valueLink.value)
      clearButton = button(onClick: @clear, 'clear')

    selectFilebutton = span
      className: 'selectFilebutton'
      button(null, 'Select File')
      input
        type: 'file'
        onChange: @onChange
    div
      className: 'ImageUploadInput'
      image
      clearButton
      selectFilebutton




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
  fontStyle       = String(props.fontStyle)
  fontWeight      = String(props.fontWeight)
  fontSize        = Number(props.fontSize)
  fontFamily      = String(props.fontFamily)
  height          = Number(props.height)
  width           = Number(props.width)
  textColor       = String(props.textColor)
  backgroundColor = String(props.backgroundColor)
  backgroundImage = String(props.backgroundImage)
  textStrokeColor = String(props.textStrokeColor)
  textStrokeSize  = Number(props.textStrokeSize)
  textPadding     = Number(props.textPadding)

  canvas = document.createElement('canvas')
  canvas.height = height
  canvas.width  = width
  context = canvas.getContext("2d")


  context.fillStyle = backgroundColor
  context.fillRect(0,0,width,height)

  if backgroundImage
    context.drawImage(createImgTag(backgroundImage), 0, 0, width, height)


  context.font         = "#{fontStyle} normal #{fontWeight} #{fontSize}px #{fontFamily}"
  context.fillStyle    = textColor
  context.textBaseline = 'bottom'
  context.strokeStyle  = textStrokeColor
  context.lineWidth    = textStrokeSize

  lines = props.text.split("\n")

  switch props.textAlign[1]
    when 'l'
      context.textAlign = 'start'
      x = textPadding
    when 'c'
      context.textAlign = 'center'
      x = (width / 2)
    when 'r'
      context.textAlign = 'end'
      x = width - textPadding

  switch props.textAlign[0]
    when 't'
      y = fontSize + textPadding
    when 'm'
      y = (height / 2) - (fontSize / 2)
    when 'b'
      y = height - (fontSize*(lines.length-1)) - textPadding

  lines.forEach (line) ->
    context.fillText(line, x, y)
    context.strokeText(line, x, y) if textStrokeSize > 0

    y += fontSize



  window.DEBUG_CANVAS = canvas
  window.DEBUG_CANVAS_CONTEXT = context

  return canvas.toDataURL("image/png")


createImgTag = (src) ->
  x = document.createElement('img')
  x.src = src
  x
