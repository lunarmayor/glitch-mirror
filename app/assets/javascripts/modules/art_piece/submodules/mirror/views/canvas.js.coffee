#= require modules/art_piece/submodules/mirror/templates/canvas

GlitchMirror.module 'ArtPiece.Mirror', (Mirror)->
  ###
  # mirror
  ###
  class Mirror.Canvas extends Marionette.ItemView

    initialize: ->
      window.thing = this
      console.log('mirror on')

    template: JST['modules/art_piece/submodules/mirror/templates/canvas']

    onRender: ->
      @setupElements()
      window.requestAnimationFrame = window.requestAnimationFrame || window.mozRequestAnimationFrame || window.webkitRequestAnimationFrame
      @manipulation = 'displace'
      @setAnimationParameters()

    setAnimationParameters: ->
      @fps = 30
      @interval = 1000/ @fps
      @then = Date.now()

    setupElements: ->
      @canvas = @el.querySelector('canvas')
      @context = @canvas.getContext('2d')
      @backCanvas = document.createElement('canvas')
      @backContext = @backCanvas.getContext('2d')
      @video = @el.querySelector('video')
      @setSizes()

      @getVideoStream()

    setSizes: ->
      #video dimensions
      [@clientWidth, @clientHeight] = [@video.width, @video.height]
      #set video dimensions to canavas
      [@canvas.width, @canvas.height] = [@clientWidth,  @clientHeight]
      [@backCanvas.width, @backCanvas.height] = [@clientWidth,  @clientHeight]

    getVideoStream: ->
      failure = -> console.log('i failed')
      #if supported supported
      if navigator.getUserMedia
        navigator.getUserMedia({video: true}, (stream) ->
          arlert('hey')
          @video.src = stream
          @video.play()
        , failure)
      else if navigator.webkitGetUserMedia
        navigator.webkitGetUserMedia({video: true}, (stream) ->
          alert('jel')
          @video.src = window.webkitURL.createObjectURL(stream)
          @video.play()
        , failure)
      else
        console.log('doesn\'t work')


      requestAnimationFrame(@draw)

    draw: =>
      now = Date.now()
      delta = now - @then
      if delta > @interval
        @manipulate(@video, @context, @backContext, @clientWidth, @clientHeight, @manipulation)
        @then = now - (delta % @interval)
      window.requestAnimationFrame(@draw)

    manipulate: (v, c, bc, cw, ch, method) ->
        #draw video frame on back canvas

      bc.drawImage v, 0, 0, 320, 320
      #grab pixeldata
      imageData = bc.getImageData(0, 0, 320, 320)
      @pixelData = imageData.data

      #manipulate pixel
      for i in [0..(@pixelData.length - 1)] by 4
        [@pixelData[i], @pixelData[i + 1], @pixelData[i + 2]] = @[method](i)

      c.putImageData imageData, 0, 0


    #pixel manipulations
    grayScale: (i) ->
      brightness = @calculateBrightness(@pixelData, i)
      [brightness + Math.random() * 30 - 15,
       brightness  + Math.random() * 30 - 15,
       brightness + Math.random() * 30 - 15]

    grayScaleRandom: (i) ->
      brightness = @calculateBrightness(@pixelData, i)
      [brightness, brightness, brightness]

    randomDark: (i) ->
      if @calculateBrightness(@pixelData, i) < 100
        [Math.random() * 200,
         Math.random() * 50,
         Math.random() * 20]
      else
        [200, 100, 0]

    sinOrange: (i) ->
      if @calculateBrightness(@pixelData, i) < 90
        [Math.sin(@then/200) * 200,
        Math.random() * 50,
        Math.random() * 20]
      else
        [Math.sin(@then/ 20) * 200 + 100, Math.sin(@then/ 20 ) * 2, 20]

    whiteDots: (i) ->
      if @calculateBrightness(@pixelData, i) < 30
        [Math.random() * 200,
         Math.random() * 50,
         Math.random() * 20]

        times = Math.floor(Math.random() *30)
        for t in [1..times]
          @pixelData[i + @clientWidth * 4 * t] = 200
      else
        [0, 0, 0]

    sinStrech: (i) ->
      if @calculateBrightness(@pixelData, i) < 50
        [Math.random() * 200,
         Math.random() * 50,
         Math.random() * 20]

        times = Math.floor(Math.sin(@then/ 200) *35)
        for t in [1..times]
          @pixelData[i + @clientWidth * 4 * t] = 200
      else
        [0, 0, 0]

    displace: (i) ->
      if @calculateBrightness(@pixelData, i) < 100
        [Math.random() * 200,
         Math.random() * 50,
         Math.random() * 20]

        times = Math.floor(Math.random() * 5)
        for t in [1..times]
          @pixelData[i + @clientWidth * 4 * t] = Math.random() * 200
      else
        [200, 200, 300]

    displace: (i) ->
      brightness = @calculateBrightness(@pixelData, i)
      if brightness < 100
        [0,0,0]

      else if @calculateBelowBrightness(@pixelData, i) < brightness
        [200, Math.sin(@then/ 3999) * 100, Math.cos(@then/ 999) * 100]

      else
        @pixel(i)



    calculateBrightness: (data, i) ->
      0.34 * data[i] + 0.5 * data[i + 1] + 0.16 * data[i + 2]

    calculateBelowBrightness: (data, i) ->
      d = @clientWidth * 4
      0.34 * data[i + d] + 0.5 * data[i + 1 + d] + 0.16 * data[i + 2 + d]

    pixel: (i) ->
      [@pixelData[i] + 200,
       @pixelData[i + 1]+200,
       @pixelData[i + 2]]



