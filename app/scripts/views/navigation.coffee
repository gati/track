exports = window.module "track", "Views"

class exports.Navigation extends Backbone.View
  el: "#navigation"

  events: 
    "click a": "closeNav"

  initialize: (options) =>
    @appState = options.appState

    super options

  render: =>
    @$el.empty()
    @$el.html(window.track.Utils.getTemplate("navigation"))
    _(@collection.map(@makeSection)).each @addSectionElement

    @

  makeSection: (section) =>
    sectionJSON = section.toJSON()
    sectionJSON.routes = (route.toJSON() for route in @getRoutes(sectionJSON))

    window.track.Utils.getTemplate("navigation-item")(sectionJSON)

  addSectionElement: (sectionElement) =>
    @$el.find("ul").append sectionElement

  getRoutes: (section) =>
    @appState.store.shuttleRoutes.filter (route) -> 
      route.get("key") in section.routes

  closeNav: => $(".off-canvas-wrap").removeClass "move-right"

