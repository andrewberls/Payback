Payback.Charts = {}

# Bar chart of amounts loaned vs borrowed
Payback.Charts.drawUserLoanBorrow = (gid) ->
  $.getJSON '/stats/type_proportions', gid: gid, (json) ->
    data = json.stats
    amts = data.map (e) -> e.amt # Map amounts for d3.max()

    # Dimensions
    w    = 250
    h    = 150

    # Scale functions
    xScale = d3.scale.ordinal()
               .domain(d3.range(data.length))
               .rangeRoundBands([0, w], 0.05)

    yScale = d3.scale.linear()
               .domain([0, d3.max(amts)])
               .range([0, (h-22)]) # Hack to move bottom up

    # Create SVG element
    svg = d3.select('.user-loan-borrow')
            .append('svg')
            .attr('width', w)
            .attr('height', h)

    # Create bars
    svg.selectAll('rect')
       .data(data)
       .enter()
       .append('rect')
       .attr({
         x : (d, i) -> xScale(i)
         y : (d, i) -> (h-22) - yScale(d.amt) # Leave room for bottom labels
         width  : xScale.rangeBand()
         height : (d) -> yScale(d.amt)
         class  : (d) -> d.type
       })
       .append('title')
       .text((d) -> d.type)

     # Create labels
     svg.selectAll('text.label-amount')
       .data(data)
       .enter()
       .append('text')
       .text((d) -> "$#{d.amt}")
       .attr({
         x: (d, i) -> xScale(i) + xScale.rangeBand() / 2
         y: (d, i) -> ((h) - yScale(d.amt)) #+ 25
         class: 'label-amount'
       })

     labelFor = (type) ->
       if type == 'debt' then "Borrowed" else "Loaned"

     svg.selectAll('text.label-type')
       .data(data)
       .enter()
       .append('text')
       .text((d) -> labelFor(d.type))
       .attr({
         x: (d, i) -> xScale(i) + xScale.rangeBand() / 2
         y: (d, i) -> h
         class: 'label-type'
       })


# Draw pie chart of who you loan money to
Payback.Charts.drawCreditSegments = (gid) ->
    @drawSegments('.user-credit-segments', gid: gid, type: 'credits')


# Draw pie chart of who you borrow money from
Payback.Charts.drawDebtSegments = (gid) ->
    @drawSegments('.user-debt-segments', gid: gid, type: 'debts')


# Internal: Draw a pie chart mapping users to amount loaned/borrowed
#
#   containerClass - String class of DOM container
#
#   opts - Hash of options
#     gid:  String gid of the group to render stats for
#     type: String 'debts' or 'credits'
#
Payback.Charts.drawSegments = (containerClass, opts) ->
  $.getJSON '/stats/segments', opts, (json) ->
    data = json.stats
    # Sort in order descending amount
    data = data.sort((a,b) -> b.amt - a.amt)

    # Dimensions
    w = h = 150

    ringThickness = 30
    outerRadius   = w / 2
    innerRadius   = outerRadius - ringThickness

    # Function that takes in dataset and returns dataset annotated with arc angles, etc
    pie = d3.layout.pie()
            .value((d) -> d.amt)

    color = d3.scale.category20()

    # Arc drawing function
    arc = d3.svg.arc()
            .innerRadius(innerRadius)
            .outerRadius(outerRadius)

    # Create svg element
    svg = d3.select("#{containerClass} svg")
            .attr('width', w)
            .attr('height', h)

    # Set up groups
    arcs = svg.selectAll("g.arc")
              .data(pie(data))
              .enter()
              .append('g')
              .attr('class', 'arc')
              .attr('transform', "translate(#{outerRadius},#{outerRadius})")

    # Draw arc paths
    # A path's path description is defined in the d attribute
    # so we call the arc generator, which generates the path information
    # based on the data already bound to this group
    arcs.append('path')
        .attr('fill', (d, i) -> color(i))
        .attr('d', arc)

    # Draw legend w/ labels
    segmentLabelFor = (d, i) ->
      return if d.amt == 0
      """
        <span class='swatch' style="background-color: #{color(i)}"></span>
        #{d.name} <span class='percent'>($#{d.amt})</span>
      """

    d3.select("#{containerClass} .legend")
      .selectAll('li')
      .data(data)
      .enter()
      .append('li')
      .html((d, i) -> segmentLabelFor(d, i))
