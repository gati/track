window.module = (namespaces...) -> 
  _.reduce namespaces, ((memo, name) -> memo[name] ?= {}), window

exports = window.module "track", "Utils"

exports.getTemplate = (templateName) -> 
  JST["app/scripts/templates/#{templateName}.ejs"]