exports = window.module "track", "Views"

class exports.MapCanvas extends Backbone.View
  el: "#map"

  initialize: (options) =>
    @appState = options.appState
    #google.maps.event.addDomListener(window, 'load', @render)
    @setListeners()

    @markers = []
    @trackers = []

    super options

  setListeners: =>
    #@appState.bus.on "map:routeReady", @setRouteOverlay
    @appState.store.trackers.on "add", (trackerModel) =>
      if @currentRoute? and trackerModel.get("device_id").toString() in @currentRoute.get("shuttles")
        @setTracker trackerModel

  render: =>
    google.maps.visualRefresh = true
    mapOptions =
      center: new google.maps.LatLng(30.264887, -97.746649)
      zoom: 15
      mapTypeId: google.maps.MapTypeId.ROADMAP
      disableDefaultUI:true
      streetViewControl: false
      draggable: true
      navigationControl: false
      scalControl: false
      panControl: false
      zoomControl: false
      scaleControl: false
      scrollwheel: false
      
    @mapObj = new google.maps.Map(@$el[0], mapOptions)

    # force the map to fill the screen
    @$el.css("height", $(window).height())
    
    # no zoom for you!
    google.maps.event.addDomListener @mapObj, 'zoom_changed', () =>
      @mapObj.setZoom(15) unless @mapObj.getZoom() is 15

    google.maps.event.addDomListener @mapObj, "click", (e) =>
      console.log('"lat":'+e.latLng.lat().toFixed(6)+","+'"lng":'+e.latLng.lng().toFixed(6))

    # drop the a pin on the map for the current user
    # @getUserLocation @setUserMapLocation

    @


  getUserLocation: (callback) =>
    navigator.geolocation.getCurrentPosition callback

  
  setUserMapLocation: (userLocation) =>
    position = new google.maps.LatLng userLocation.coords.latitude, 
      userLocation.coords.longitude
    
    marker = new google.maps.Marker 
      position: position,
      map: @mapObj

    infoWindow = new google.maps.InfoWindow()

    google.maps.event.addDomListener marker, "click", () =>
      infoWindow.setContent("You are here. Hello!")
      infoWindow.open(@mapObj, marker)

  
  setRouteOverlay: (routeModel) =>
    @overlay.setMap(null) if @overlay

    center = routeModel.get("mapCenter")
    bounds = routeModel.get('overlayBounds')
    image = routeModel.get("image")

    @mapObj.panTo new google.maps.LatLng(center.lat, center.lng)

    swBound = new google.maps.LatLng(bounds.sw.lat, bounds.sw.lng)
    neBound = new google.maps.LatLng(bounds.ne.lat, bounds.ne.lng)
    googleBounds = new google.maps.LatLngBounds(swBound, neBound)
    
    @overlay = new window.mapOverlay(googleBounds, "/images/#{image}", @mapObj)


  clearMarkers: (arr) =>
    arr ||= @markers
    _(arr).each (marker) => 
      marker.marker.setMap null
      @stopListening marker.model

  clearTrackers: => @clearMarkers(@trackers)

  setShuttleStop: (stopModel) =>
    coords = stopModel.get("location")
    image = stopModel.get("image") ? "transparent-map-icon.png"
    position = new google.maps.LatLng(coords.lat, coords.lng)
    marker = new RichMarker
      position: position
      content: '<div class="markerContainer"><img src="images/'+image+'"/></div>'
      map: @mapObj
      shadow: "images/transparent-map-icon.png"

    @markers.push model: stopModel, marker: marker

    #infoWindow = new google.maps.InfoWindow()

    #google.maps.event.addDomListener marker, "click", () =>
    #  infoWindow.setContent(stopModel.get("name"))
    #  infoWindow.open(@mapObj, marker)

  setTracker: (trackerModel) =>
    image = "trackers/darkbus.png"
    position = new google.maps.LatLng(trackerModel.get("lat"), trackerModel.get("lng"))
    tracker = new RichMarker
      position: position
      content: '<div class="markerContainer"><img src="images/'+image+'"/></div>'
      map: @mapObj
      shadow: "images/transparent-map-icon.png"

    @trackers.push model: trackerModel, marker: tracker

    @listenTo trackerModel, "change", () -> 
      position = new google.maps.LatLng(trackerModel.get("lat"), trackerModel.get("lng"))
      tracker.setPosition(position);
