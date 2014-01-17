module.exports = class Collection extends Backbone.Collection
    initialize: (models, opts) ->
        @cost = 0
        @type = opts.type
        @url = opts.url if opts.url?
        @localStorage = new Backbone.LocalStorage "cole-#{@type}"
        null

    calculate: ->
        @cost = 0
        @cost += row.calculate() for row in @models
        console.log "#{@type} total", @cost
        @cost
