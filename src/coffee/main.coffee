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
            .range([10, height-30])

sin_to_unit_scale = d3.scale.linear()
                .domain([-1,1])
color_interpolator = d3.interpolateRgb("#EB0C40", "#4704D6")

TICK_INTERVAL = 800
ANIM_TIME = 0.8 * TICK_INTERVAL
t = 0
setInterval ->
  data.push(t: t++, x: Math.random(), y: Math.random())
  data.shift() if t > 60
  _.each data, (d) ->
    y = d.y
    dy = Math.random() * 0.2
    if y - dy < 0
      d.y = y + dy
    else if y + dy > 1
      d.y = y - dy
    else
      d.y = if Math.round(y*100) & 1 then y+dy else y-dy

  circle = svg.selectAll("circle")
    .data(data, (d) -> d.t)
  circle.transition()
    .duration(ANIM_TIME)
    .attr("cy", (d) -> y_scale d.y)
    .style("fill", (d) ->
       color_interpolator(sin_to_unit_scale(Math.sin(t*0.4 + d.x*Math.PI*2))))
  circle.enter().append("circle")
    .attr("cx", (d) -> x_scale d.x)
    .attr("cy", (d) -> y_scale d.y)
    .attr("r", 0)
    .attr("opacity", 0)
    .style("fill", (d) ->
       color_interpolator(sin_to_unit_scale(Math.sin(t*0.4 + d.x*Math.PI*2))))
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
