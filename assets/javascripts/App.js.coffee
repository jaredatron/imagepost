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
    text: ''

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
        label: 'Font Family'
        FontFamilySelectInput
          valueLink: @linkState('fontFamily')


      FormGroup
        label: 'Font Size'
        input
          type:     'number'
          valueLink: @linkState('fontSize')

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
  console.log('rendering image')
  canvas = document.createElement('canvas')
  canvas.height = props.height
  canvas.width = props.width
  context = canvas.getContext("2d")

  fontSize   = Number(props.fontSize)
  fontFamily = props.fontFamily

  context.font = "#{fontSize}px #{fontFamily}"
  context.fillStyle = 'black'
  context.textAlign = 'start'

  lines = props.text.split("\n");

  top = fontSize
  lines.forEach (line) ->
    console.log('top: ', top)
    context.fillText(line, 0, top)
    top += fontSize



  window.DEBUG_CANVAS = canvas
  window.DEBUG_CANVAS_CONTEXT = context

  return canvas.toDataURL("image/png")
