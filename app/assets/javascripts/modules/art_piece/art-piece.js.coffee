#= require_tree ./templates
#= require_tree ./layouts
#= require_self

GlitchMirror.module('ArtPiece', (ArtPiece) ->
  ArtPiece.addInitializer =>
    @layout = new ArtPiece.Layout
    @layout.render()
)

$ ->
  if $('#main').length
    GlitchMirror.start()