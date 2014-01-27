exports = window.module "track", "Views"

class exports.Flash extends Backbone.View
  el: "#flash"

  initialize: (options) =>
    throw new Error("Flash view requires options.message on init") unless options.message
    @message = options.message

  events: 
    "click [data-role=close]": "close"

  render: =>
    @$el.empty()
    @$el.html(window.track.Utils.getTemplate("flash")(message:@message))

    @

  close: (evt) => @$el.empty()