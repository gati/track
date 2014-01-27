exports = window.module "track", "Views"

class exports.ShuttleRoute extends Backbone.View
  initialize: (options) =>
    super options

  render: =>
    route = @model.toJSON()
    route.stops = (stop.toJSON() for stop in route.stops)
    
    message = @makeMessage route

    flash = (new exports.Flash(message:message)).render() 

    # draw the routes
    # add the stops
    # if active...
      # add the trackers
    # show the stops and active times in an alert

  # Get only the names from each stop object
  # Map the array of names so each is wrapped in a <b> tag
  # Format the array as a sentence - comma separated with "and" before last item
  listStops: (stops) =>
    _.toSentence(_(_(stops).pluck('name')).map((name) -> "<b>#{name}</b>"))

  makeMessage: (route) =>
    if @model.isActive()
      message = "You're looking at the <b>#{route.name}</b> route! It stops at 
        #{@listStops(route.stops)}"

    else
      message = "Oh nooooes! The <b>#{route.name}</b> route is only active from 
        #{@model.prettyDate('startDate')} to #{@model.prettyDate('endDate')} 
        #epicshuttlefail"

    message