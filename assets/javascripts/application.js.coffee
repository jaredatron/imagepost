#= require 'react-with-addons'
#= require 'react-component'
#= require 'App'
#= require_self


React.render(App(), document.body.children[0])

addEventListener 'beforeunload', ->
  document.body.innerHTML = ''
  undefined
