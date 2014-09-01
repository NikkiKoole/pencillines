{vec2} = require 'gl-matrix'
{Digraph} = require('graphlib')

#window.Digraph = Digraph



window.main =  ->
    document.body.appendChild(stats.domElement)
    document.body.appendChild(renderer.view)
    # for i in [0 .. 3]
    #     x = Math.random() * window.innerWidth
    #     y = Math.random() * window.innerHeight
    #     w = 100 + Math.random() * 200
    #     h = 100 + Math.random() * 200
    #     drawRectangle(x, y, w, h)
    g = new Digraph()
    g.addNode('A')
    console.log g
    console.log g.nodes()
    console.log "hi there"

window.onload = window.main

testGraphs = ->
    g = new Digraph()
    console.log g
    g.addNode('A')
    #g.addEdge('AB', 'A', 'B')



extend_line = (->
    t = vec2.create()
    (a, b, size=2 + Math.random()*20) ->
        ba = vec2.sub(t, b, a)
        dir = vec2.normalize(t, ba)
        ext = vec2.scale(t, dir, size)
        vec2.sub(a, a, ext)
        vec2.add(b, b, ext)
)()

stats = new Stats()
stats.setMode(0)
stats.domElement.style.position = 'absolute'
stats.domElement.style.left = '100px'
stats.domElement.style.top = '0px'


animate= ->
    stats.begin()
    requestAnimFrame(animate)
    renderer.render(stage)
    stats.end()

stage = new PIXI.Stage(0xffaaff);
#renderer = new PIXI.autoDetectRenderer(window.innerWidth, window.innerHeight, null, false, false)
renderer = new PIXI.CanvasRenderer(window.innerWidth, window.innerHeight)

requestAnimFrame(animate)

globalAlpha = 1.0

getAngleBetweenTwoPoints = (start, end) ->
    xdiff = end.x - start.x
    ydiff = end.y - start.y
    Math.atan2(ydiff, xdiff)# * (180 / Math.PI)

getMiddlePoint = (start, end) ->
    x: start.x + (end.x - start.x)/2
    y: start.y + (end.y - start.y)/2

getDistance = (start, end) ->
    xdiff = end.x - start.x
    ydiff = end.y - start.y
    Math.sqrt((xdiff * xdiff) + (ydiff * ydiff))

drawLine = (start, end) ->
    # lines actually are:  a large texture with a mask on it, in a container.
    MASK_HEIGHT = 20
    a = vec2.fromValues(start.x, start.y)
    b = vec2.fromValues(end.x,  end.y)
    extend_line(a, b)
    start.x = a[0]
    start.y = a[1]
    end.x = b[0]
    end.y = b[1]

    texture = PIXI.Sprite.fromImage("resources/pencil-stroke-narrower.png")
    container = new PIXI.DisplayObjectContainer()
    texture.position.y = -3 # to fit image vertically
    container.addChild(texture)
    mask = new PIXI.Graphics()
    mask.beginFill()
    mask.drawRect(0, -0.5 * MASK_HEIGHT, getDistance(start, end), MASK_HEIGHT)
    container.rotation = getAngleBetweenTwoPoints(start, end)
    container.addChild(mask)
    texture.mask = mask
    container.position.x = start.x
    container.position.y = start.y
    container.alpha = globalAlpha
    stage.addChild(container)

drawRectangle = (x,y,width,height) ->
    globalAlpha = Math.random()
    drawLine({x:x,y:y},{x:x+width,y:y})
    drawLine({x:x,y:y},{x:x,y:y+height})
    drawLine({x:x+width,y:y},{x:x+width,y:y+height})
    drawLine({x:x+width,y:y+height},{x:x,y:y+height})



generateList = () ->
    list = []
    for i in [0 .. 100]
        list.push
            x:Math.random() * window.innerWidth/3
            y:Math.random() * window.innerHeight/3
    list
        
drawList = (arr) ->
    for obj,i in arr
        if i > 0
            oldPos =  arr[i-1]
            drawLine({x:oldPos.x,y:oldPos.y},{x:obj.x,y:obj.y})
#drawList(generateList())
#window.onload = testGraphs
