exports = window.module "track", "Views"

class exports.Navigation extends Backbone.View
  el: "#navigation"

  events: 
    "click a": "closeNav"

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
    window.track.App.store.shuttleRoutes.filter (route) -> 
      route.get("key") in section.routes

  closeNav: => $(".off-canvas-wrap").removeClass "move-right"

