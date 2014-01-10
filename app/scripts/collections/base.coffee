module.exports = class BaseCollection extends Backbone.Collection
    name: ""
    cost: 0

    localStorage: new Backbone.LocalStorage "cole-#{@name}"

    calculate = ->
        @cost = 0
        @cost += row.calculate() for row in @models
        $$("#showcalculation#{@name}").text @cost
        console.log "#{@name} total", @cost
        @cost
