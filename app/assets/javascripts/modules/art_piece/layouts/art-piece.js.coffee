#= require modules/art_piece/templates/art-piece

GlitchMirror.module 'ArtPiece', (ArtPiece)->
  ###
  # Layout
  # @class Layout
  ###
  class ArtPiece.Layout extends Marionette.LayoutView
    el: '#main'

    template: JST['modules/art_piece/templates/art-piece']


    regions:
      nav: '#nav'
      art: '#art'

