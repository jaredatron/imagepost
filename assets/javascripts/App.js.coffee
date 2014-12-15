component = React.component
{div, span, textarea, canvas} = React.DOM

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
        value:    @state.text
        onChange: @setText

      ImagePostRendering
        text: @state.text





ImagePostTextarea = component
  render: ->
    textarea
      className: "ImagePostTextarea"
      value: @props.value
      onChange: @props.onChange

ImagePostRendering = component
  render: ->
    # `<canvas className="ImagePostRendering" />`
    div
      className: "ImagePostRendering"
      @props.text
