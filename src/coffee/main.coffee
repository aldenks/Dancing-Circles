WIDTH = document.documentElement.clientWidth
HEIGHT = document.documentElement.clientHeight

TICK_INTERVAL = 800
ANIM_TIME = 0.8 * TICK_INTERVAL
VERTICAL_MOVEMENT = 0.2
t = 0
data = []

x_scale = d3.scale.linear()
            .range([10, WIDTH-10])
y_scale = d3.scale.linear()
            .range([10, HEIGHT-30])

sin_to_unit_scale = d3.scale.linear()
                      .domain([-1,1])
color_interpolator = d3.interpolateRgb("#EB0C40", "#4704D6") #reds to blues

svg = d3.select("body").append("svg")
          .attr("width", WIDTH)
          .attr("height", HEIGHT)

# adds or subtracts a random amount from the .y member of each datapoint
randomize_y = (data) ->
  _.each data, (d) ->
    y = d.y
    rand_y = Math.random() * VERTICAL_MOVEMENT
    # attempt to keep the values within [0, 1], else move randomly
    if y - rand_y < 0
      d.y = y + rand_y
    else if y + rand_y > 1
      d.y = y - rand_y
    else
      d.y = if Math.round(y*100) & 1 then y+rand_y else y-rand_y

# takes timestep t and returns a function that takes datapoint d
# and returns its color at time t
color_at_time = (t) -> (d) ->
  color_interpolator(sin_to_unit_scale(Math.sin(t*0.4 + d.x*Math.PI*2)))

tick = ->
  data.push(t: ++t, x: Math.random(), y: Math.random())
  data.shift() if t > 60
  randomize_y(data)

  circle = svg.selectAll("circle")
    .data(data, (d) -> d.t)
  circle.transition()
    .duration(ANIM_TIME)
    .attr("cy", (d) -> y_scale d.y)
    .style("fill", color_at_time(t))

  circle.enter().append("circle")
    .attr("cx", (d) -> x_scale d.x)
    .attr("cy", (d) -> y_scale d.y)
    .attr("r", 0)
    .attr("opacity", 0)
    .style("fill", color_at_time(t))
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

# start the show
setInterval tick, TICK_INTERVAL
