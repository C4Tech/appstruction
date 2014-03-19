Model = require "models/base"

module.exports = class ConcreteModel extends Model
    defaults:
        "quantity": null
        "depth": null
        "width": null
        "length": null
        "price": null
        "tax": null

    fields: [
            text: "Quantity"
            name: "quantity"
            type: "number"
            show: true
        ,
            text: "Depth"
            name: "depth"
            type: "number"
            show: true
        ,
            text: "Width"
            name: "width"
            type: "number"
            show: true
        ,
            text: "Length"
            name: "length"
            type: "number"
            show: true
        ,
            text: "Price"
            name: "price"
            type: "number"
            show: true
        ,
            text: "Tax rate"
            name: "tax"
            type: "number"
            show: true
    ]

    initialize: ->
        @help = "Concrete help text"

    calculate: ->
        @cost = @attributes.depth * @attributes.width * @attributes.length * @attributes.quantity * @attributes.price
        console.log "concrete: #{@attributes.depth}d x #{@attributes.width}w x #{@attributes.length}h x #{@attributes.quantity} @ $#{@attributes.price} = #{@cost}"
        @cost
