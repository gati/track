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
    @navigate('shuttle-route/all', true);

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
      if route.get "message"
        return route.get "message"

      routeJSON = route.toJSON()
      routeJSON.stopModels = (stop.toJSON() for stop in routeJSON.stopModels)

      routeName = if route.get("key") is "all" then "Shuttle routes are" else "The <b>#{routeJSON.name}</b> route is"

      #if not route.isActive()
      #  message = "Oh nooooes! #{routeName} only active from 
      #    #{route.prettyDate('startDate')} to #{route.prettyDate('endDate')} 
      #    #ilovewalking"

      #if not route.isOperating()
      #  message = "Bummer! #{routeName} only active from 
      #    #{route.prettyTime('startTime')} to #{route.prettyTime('endTime')} 
          #sadface"

      #else
      message = "You're looking at the <b>#{routeJSON.name}</b> route! It stops at 
        #{listStops(routeJSON.stopModels)}"


      message

    #
    # format data how we'd like it
    #
    route = @appState.store.shuttleRoutes.findWhere key: slug

    @mapView.currentRoute = route
    
    stops = @appState.store.shuttleStops.filter (stop) -> 
      stop.get("key") in route.get "stops"

    trackers = @appState.store.trackers.filter (tracker) ->
      tracker.get('device_id') in route.get "shuttles"

    route.set "stopModels", stops    
    
    #
    # Show the right message above the map
    #
    if route.get "message"
      message = makeMessage route
      messageType = if not route.isActive() or not route.isOperating() then "warning" else "info"
      flash = (new window.track.Views.Flash(message:message, messageType: messageType)).render()
    else
      $("#flash").empty()

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
    @mapView.clearMarkers()
    _(stops).each @mapView.setShuttleStop

    #
    # Add shuttles to the map
    #
    @mapView.clearTrackers()
    _(trackers).each @mapView.setTracker
