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

      ImagePostTextarea
        height:   @state.height
        width:    @state.width
        value:    @state.text
        onChange: @setText

      ImagePostRendering
        height: @state.height
        width:  @state.width
        text:   @state.text





ImagePostTextarea = component
  render: ->
    textarea
      className: "ImagePostTextarea"
      value: @props.value
      onChange: @props.onChange
      style:
          height: @props.height+'px'
          width:  @props.width+'px'

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

  context.font = '20px Georgia'
  context.fillStyle = 'black'
  context.textAlign = 'start'

  context.fillText(props.text, 0, 20)



  window.DEBUG_CANVAS = canvas
  window.DEBUG_CANVAS_CONTEXT = context

  return canvas.toDataURL("image/png")
