exports = window.module "track", "Views"

class exports.ShuttleRoute extends Backbone.View
  initialize: (options) =>
    @appState = window.track.appState
    @mapObj = @appState.statefulViews.mapCanvas.mapObj

    super options

  render: =>
    route = @model.toJSON()
    route.stops = (stop.toJSON() for stop in route.stops)
    
    message = @makeMessage route
    messageType = if not @model.isActive() or not @model.isOperating() then "warning" else "info"

    flash = (new exports.Flash(message:message, messageType: messageType)).render()

    @appState.bus.trigger "map:routeReady", @model


  # Get only the names from each stop object
  # Map the array of names so each is wrapped in a <b> tag
  # Format the array as a sentence - comma separated with "and" before last item
  listStops: (stops) =>
    _.toSentence(_(_(stops).pluck('name')).map((name) -> "<b>#{name}</b>"))

  makeMessage: (route) =>
    if not @model.isActive()
      message = "Oh nooooes! The <b>#{route.name}</b> route is only active from 
        #{@model.prettyDate('startDate')} to #{@model.prettyDate('endDate')} 
        #epicschedulingfail"

    else if not @model.isOperating()
      message = "Bummer! The <b>#{route.name}</b> route is only active from 
        #{@model.prettyTime('startTime')} to #{@model.prettyTime('endTime')} 
        #sadface"

    else
      message = "You're looking at the <b>#{route.name}</b> route! It stops at 
        #{@listStops(route.stops)}"


    message
    