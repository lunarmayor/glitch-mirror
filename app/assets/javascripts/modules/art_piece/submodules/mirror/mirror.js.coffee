#= require_tree ./templates
#= require_tree ./views

GlitchMirror.module 'ArtPiece.Mirror', (Mirror) ->
  GlitchMirror.ArtPiece.on 'start', ->
    @mirror = new Mirror.Canvas
    GlitchMirror.ArtPiece.layout.art.show(@mirror)