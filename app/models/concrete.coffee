Model = require "models/base"

module.exports = class ConcreteModel extends Model
    defaults:
        "quantity": null
        "depth": null
        "depth_units": null
        "width": null
        "length": null
        "price": null
        "tax": null

    types: [
            id: "1"
            name: "Inches"
        ,
            id: "2"
            name: "Feet"
        ,
            id:"3"
            name: "Yards"
        ,
            id:"4"
            name: "Centimeters"
        ,
            id:"5"
            name: "Meters"
    ]

    fields: [
            type: "number"
            text: "Quantity"
            name: "quantity"
            show: true
        ,
            type: "number"
            text: "Depth"
            name: "depth"
            show: true
        ,
            type: "select"
            text: "Units"
            name: "depth_units"
            show: true
        ,
            type: "number"
            text: "Width"
            name: "width"
            show: true
        ,
            type: "number"
            text: "Length"
            name: "length"
            show: true
        ,
            type: "number"
            text: "Price"
            name: "price"
            show: true
        ,
            type: "number"
            text: "Tax rate"
            name: "tax"
            show: true
    ]

    calculate: ->
        @cost = @attributes.depth * @attributes.width * @attributes.length * @attributes.quantity * @attributes.price
        console.log "concrete: #{@attributes.depth}d x #{@attributes.width}w x #{@attributes.length}h x #{@attributes.quantity} @ $#{@attributes.price} = #{@cost}"
        @cost
