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

  setupInitialViews: =>
    sections = @store.sections
    @statefulViews.navigation = (new track.Views.Navigation(collection:sections, appState:@)).render()

    message = "<b>Film</b> shuttles are in blue, <b>Interactive</b> shuttles 
      are in green. Use the Routes menu to find a shuttle stopping 
      at your location."

    flash = (new track.Views.Flash(message:message)).render()

    @statefulViews.mapCanvas = (new track.Views.MapCanvas(appState:@)).render()

  appReady: => 
    @setupInitialViews()
    Backbone.history.start()

  init: =>
    _.mixin(_.str.exports())

    @router = new track.Routers.Main(appState: @)
    @bus = _.extend {}, Backbone.Events

    @on "app:ready", @appReady

    bootstrapData = @getBootstrapData()
    bootstrapData.then @setupStore
    bootstrapData.then () => @trigger "app:ready"   

$ ->
  'use strict'
  (new track.App()).init()
