ComponentView = require "views/component"

module.exports = class ComponentListView extends ComponentView
    initialize: (opts) ->
        super opts

        # Set template
        @templateFile = "templates/#{@type}.list"
        @template = require @templateFile
        
        # Add attributes
        @className = "#{@type} #{@type}-list #{@type}-list-item"

        # Return nothing
        null
