exports = window.module "track", "Routers"

class exports.Main extends Backbone.Router
  routes:
    "":"index"
    "shuttle-route/:slug": "shuttleRoute"

  initialize: (options) =>
    @appState = options.appState

    super options

  index: => 
    # load all of the shuttles
    null

  shuttleRoute: (slug) => 
    @mapView = @appState.statefulViews.mapCanvas

    #
    # Get only the names from each stop object
    # Map the array of names so each is wrapped in a <b> tag
    # Format the array as a sentence - comma separated with "and" before last item
    #
    listStops = (stops) ->
      _.toSentence(_(_(stops).pluck('name')).map((name) -> "<b>#{name}</b>"))

    #
    # based on the right, set the right message
    #
    makeMessage = (route) ->
      routeJSON = route.toJSON()
      routeJSON.stops = (stop.toJSON() for stop in routeJSON.stops)

      if not route.isActive()
        message = "Oh nooooes! The <b>#{routeJSON.name}</b> route is only active from 
          #{route.prettyDate('startDate')} to #{route.prettyDate('endDate')} 
          #epicschedulingfail"

      else if not route.isOperating()
        message = "Bummer! The <b>#{routeJSON.name}</b> route is only active from 
          #{route.prettyTime('startTime')} to #{route.prettyTime('endTime')} 
          #sadface"

      else
        message = "You're looking at the <b>#{route.name}</b> route! It stops at 
          #{listStops(routeJSON.stops)}"


      message

    #
    # format data how we'd like it
    #
    route = @appState.store.shuttleRoutes.findWhere key: slug
    stops = @appState.store.shuttleStops.filter (stop) -> 
      stop.get("key") in route.get "stops"

    route.set "stops", stops    
    
    #
    # Show the right message above the map
    #
    message = makeMessage route
    messageType = if not route.isActive() or not route.isOperating() then "warning" else "info"

    flash = (new window.track.Views.Flash(message:message, messageType: messageType)).render()

    #
    # reposition the map based on this route's center coords
    #
    # @TODO

    #
    # Add the route overlay to the map
    #
    @mapView.setRouteOverlay route

    #
    # Add stops to the map
    #
    _(stops).each @mapView.setShuttleStop
