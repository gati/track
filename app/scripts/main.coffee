exports = window.module "track"

class exports.App 
  store: 
    shuttleRoutes: new track.Collections.ShuttleRoutes()
    shuttleStops: new track.Collections.ShuttleStops()
    sections: new track.Collections.Sections()

  statefulViews: 
    navigation: null
    mapCanvas: null

  constructor: -> _.extend @, Backbone.Events

  getBootstrapData: => $.getJSON("data.json")

  setupStore: (json) => 
    setupCollection = (key) => @store[key].add item for item in json[key]
    setupCollection(key) for key in _(@store).keys()

    @store.trackers = new track.Collections.Trackers()

  setupInitialViews: =>
    sections = @store.sections
    @statefulViews.navigation = (new track.Views.Navigation(collection:sections, appState:@)).render()

    message = "<b>Film</b> shuttles are in blue, <b>Interactive</b> shuttles 
      are in green. Use the Routes menu to find a shuttle stopping 
      at your location."

    #flash = (new track.Views.Flash(message:message)).render()

    @statefulViews.mapCanvas = (new track.Views.MapCanvas(appState:@)).render()

  updateTrackerModels: (data) =>
    keys = _(data).keys()
    _(data).each (item) =>
      trackerData = item
      model = @store.trackers.findWhere device_id: trackerData.device_id
      if model
        model.set 'lat', trackerData.lat, silent:true
        model.set 'lng', trackerData.lng, silent:true
        model.trigger 'change'

      else
        model = @store.trackers.add(trackerData)

  appReady: => 
    @setupInitialViews()
    Backbone.history.start()

    #socket = io.connect('http://198.61.171.237:8085')
    #socket.on 'shuttle-positions', @updateTrackerModels
    pusher = new Pusher(window.track.config.pusher.key)
    channel = pusher.subscribe('sxsw')
    channel.bind 'shuttle:location', @updateTrackerModels


  init: =>
    _.mixin(_.str.exports())

    @router = new track.Routers.Main(appState: @)
    @bus = _.extend {}, Backbone.Events

    #@on "app:ready", @appReady

    bootstrapData = @getBootstrapData()
    bootstrapData.then @setupStore
    bootstrapData.then () => @appReady()

$ ->
  'use strict'
  (new track.App()).init()
