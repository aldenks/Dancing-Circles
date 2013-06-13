width = document.documentElement.clientWidth
height = document.documentElement.clientHeight
data = []
MAX = 100
MIN = 0

log = (o) -> console.log(o)

svg = d3.select("body").append("svg")
          .attr("width", width)
          .attr("height", height)

x_scale = d3.scale.linear()
            .range([10, width-10])
y_scale = d3.scale.linear()
            .range([10, height-10])

color_interpolator = d3.interpolateRgb("red", "blue")

TICK_INTERVAL = 800
ANIM_TIME = 0.8 * TICK_INTERVAL
t = 0
setInterval ->
  data.push(t: t++, x: Math.random())
  data.shift() if t > 60
  _.each data, (d) ->
    x = d.x
    dx = Math.random() * 0.2
    if x - dx < 0
      d.x = x + dx
    else if x + dx > 1
      d.x = x - dx
    else
      d.x = if Math.round(x*100) & 1 then x+dx else x-dx

  circle = svg.selectAll("circle")
    .data(data, (d) -> d.t)
  circle.transition()
    .duration(ANIM_TIME)
    .attr("cy", (d) -> y_scale d.x)
  circle.enter().append("circle")
    .attr("cx", (d) -> x_scale d.x)
    .attr("cy", (d) -> y_scale d.x)
    .style("fill", (d) -> color_interpolator(d.x))
    .attr("opacity", 0)
    .attr("r", 0)
    .transition()
      .duration(ANIM_TIME)
      .attr("r", (d) -> 30*Math.sqrt d.x)
      .attr("opacity", 1)
  circle.exit()
    .transition()
      .duration(ANIM_TIME)
      .attr("r", 0)
      .attr("opacity", 0)
    .remove()
, TICK_INTERVAL
