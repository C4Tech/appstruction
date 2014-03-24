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

    measurement_options: [
            id: "1"
            text: "Inches"
        ,
            id: "2"
            text: "Feet"
        ,
            id:"3"
            text: "Yards"
        ,
            id:"4"
            text: "Centimeters"
        ,
            id:"5"
            text: "Meters"
    ]

    fields: [
            type: "number"
            text: "Quantity"
            name: "quantity"
            show: true
        ,
            type: "number"
            text: "Length"
            name: "length"
            show: true
        ,
            type: "select"
            text: "Units"
            name: "length_units"
            show: true
            fieldTypeSelect: true
            optionsType: 'measurements'
        ,
            type: "number"
            text: "Width"
            name: "width"
            show: true
        ,
            type: "select"
            text: "Units"
            name: "width_units"
            show: true
            fieldTypeSelect: true
            optionsType: 'measurements'
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
            fieldTypeSelect: true
            optionsType: 'measurements'
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

    initialize: ->
        @help = "Concrete help text"

        self = @
        _(@fields).each (child) =>
            child.options = self.measurement_options if child.optionsType == 'measurements'

    calculate: ->
        @cost = @attributes.depth * @attributes.width * @attributes.length * @attributes.quantity * @attributes.price
        console.log "concrete: #{@attributes.depth}d x #{@attributes.width}w x #{@attributes.length}h x #{@attributes.quantity} @ $#{@attributes.price} = #{@cost}"
        @cost
