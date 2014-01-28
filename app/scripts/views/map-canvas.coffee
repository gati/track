exports = window.module "track", "Views"

class exports.MapCanvas extends Backbone.View
  el: "#map"

  initialize: (options) =>
    @appState = window.track.appState
    google.maps.event.addDomListener(window, 'load', @render)
    @setListeners()

    super options

  setListeners: =>
    @appState.bus.on "map:routeReady", @setRouteOverlay

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

    @$el.css("height", $(window).height())

    @getUserLocation @setUserMapLocation

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

    bounds = routeModel.get('overlayBounds')
    image = routeModel.get("image")

    swBound = new google.maps.LatLng(bounds.sw.lat, bounds.sw.lng)
    neBound = new google.maps.LatLng(bounds.ne.lat, bounds.ne.lng)
    googleBounds = new google.maps.LatLngBounds(swBound, neBound)
    
    @overlay = new window.mapOverlay(googleBounds, "/images/#{image}", @mapObj)