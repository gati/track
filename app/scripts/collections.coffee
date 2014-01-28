exports = window.module "track", "Collections"

class Tracker extends Backbone.Model
  #route
  internal: false

class ShuttleRoute extends Backbone.Model
  isActive: =>
    today = moment()
    today.isAfter(@startDate) and today.isBefore(@endDate)

  isOperating: =>
    now = moment()
    todayString = now.format("MM DD YYYY")
    now.isAfter("#{todayString} #{@get('startTime')}") and now.isBefore("#{todayString} #{@get('endTime')}")    

  prettyDate: (which) => @prettyDateTime(@get(which), "MMMM Do YYYY")

  prettyTime: (which) => @prettyDateTime("#{moment().format("YYYY MM DD")} #{@get(which)}", "hA")

  prettyDateTime: (dateString, format) => moment(dateString).format(format)


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

