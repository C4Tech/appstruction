module.exports = class Collection extends Backbone.Collection
    initialize: (models, opts) ->
        @cost = 0
        @modelType = opts.modelType
        @url = opts.url if opts.url?
        @localStorage = new Backbone.LocalStorage "cole-#{@modelType}"
        null

    calculate: ->
        @cost = 0
        @cost += row.calculate() for row in @models
        console.log "#{@modelType} total", @cost
        @cost
