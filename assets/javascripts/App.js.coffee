component = React.component
{div, span, textarea, img} = React.DOM

@App = component
  render: ->
    div
      className: "page"
      ImagePost()

ImagePost = component

  getInitialState: ->
    height: 100
    width: 100
    text: ''

  setText: (event) ->
    @setState text: event.target.value

  render: ->
    div
      className: "ImagePost",

      ImagePostTextInput
        height:   @state.height
        width:    @state.width
        value:    @state.text
        onChange: @setText

      ImagePostRendering
        height: @state.height
        width:  @state.width
        text:   @state.text





ImagePostTextInput = component
  render: ->
    div
      className: "ImagePostTextInput"
      value: @props.value
      onChange: @props.onChange
      style:
          height: @props.height+'px'
          width:  @props.width+'px'
      textarea()

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

  fontSize = 20
  fontFamily = 'Georgia'

  context.font = "#{fontSize}px #{fontFamily}"
  context.fillStyle = 'black'
  context.textAlign = 'start'

  lines = props.text.split("\n");

  top = fontSize
  lines.forEach (line) ->
    context.fillText(line, 0, top)
    top += fontSize



  window.DEBUG_CANVAS = canvas
  window.DEBUG_CANVAS_CONTEXT = context

  return canvas.toDataURL("image/png")
