startCanvas =->
    #paper.install(window);
    $(document.body).append($("<canvas></canvas>").attr("id","canvas2d"))
    paper.setup("canvas2d")

    path = new paper.Path()

    path.strokeColor = 'black'
    start = new paper.Point(100, 100)

    path.moveTo(start)

    path.lineTo(start.add([ 200, -50 ]))

    paper.view.draw()

$.ready(
    startCanvas()
)