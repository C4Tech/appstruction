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
            mask: 'percentage'
    ]

    initialize: ->
        @help = "Concrete help text"

    calculate: ->
        tax = @attributes.tax || '0%'
        tax_value = (tax.slice 0, tax.length-1) / 100

        @cost = @attributes.depth * @attributes.width * @attributes.length * @attributes.quantity * @attributes.price
        @cost = @cost + (@cost * tax_value)
        console.log "concrete: #{@attributes.depth}d x #{@attributes.width}w x #{@attributes.length}h x #{@attributes.quantity} @ $#{@attributes.price} + #{tax} tax = #{@cost}"
        @cost
