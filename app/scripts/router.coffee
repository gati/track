exports = window.module "track", "Routers"

class exports.Main extends Backbone.Router
  routes:
    "":"index"
    "shuttle-route/:slug": "shuttleRoute"

  index: => 
    # load all of the shuttles
    null

  shuttleRoute: (slug) => 
    route = window.track.appState.store.shuttleRoutes.findWhere key: slug
    stops = window.track.appState.store.shuttleStops.filter (stop) -> 
      stop.get("key") in route.get "stops"

    route.set "stops", stops

    # filter the shuttles
    (new track.Views.ShuttleRoute(model:route)).render()
    null