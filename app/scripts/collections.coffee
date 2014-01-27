exports = window.module "track", "Collections"

class Tracker extends Backbone.Model
  #route
  internal: false

class ShuttleRoute extends Backbone.Model
  isActive: =>
    today = moment()
    today.isAfter(@startDate) and today.isBefore(@endDate)

  prettyDate: (which) =>
    moment(@get(which)).format("MMMM Do YYYY")


class ShuttleStop extends Backbone.Model
  #route

class Section extends Backbone.Model


class exports.Trackers extends Backbone.Collection
  model: Tracker

class exports.ShuttleRoutes extends Backbone.Collection
  model: ShuttleRoute

class exports.ShuttleStops extends Backbone.Collection
  model: ShuttleStop

class exports.Sections extends Backbone.Collection
  model: Section

