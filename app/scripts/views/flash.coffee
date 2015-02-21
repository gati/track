exports = window.module "track", "Views"

class exports.Flash extends Backbone.View
  el: "#flash"

  initialize: (options) =>
    throw new Error("Flash view requires options.message on init") unless options.message
    @message = options.message
    #@messageType = options.messageType ? "info"
    @messageType = "info"

  events: 
    "click [data-role=close]": "close"

  render: =>
    @$el.empty()
    @$el.html(window.track.Utils.getTemplate("flash")(message:@message, messageType: @messageType))

    @

  close: (evt) => @$el.empty()