Model = require "models/base"

module.exports = class ConcreteModel extends Model
    defaults:
        "quantity": null
        "depth": null
        "depth_units": null
        "width": null
        "width_units": null
        "length": null
        "length_units": null
        "price": null
        "price_units": null
        "tax": null

    measurement_options: [
            id: 'in'
            text: 'Inches'
        ,
            id: 'ft'
            text: 'Feet'
        ,
            id:'yd'
            text: 'Yards'
        ,
            id:'cm'
            text: 'Centimeters'
        ,
            id:'m'
            text: 'Meters'
    ]

    price_options: [
            id: 'in'
            text: 'Per Cubic Inch'
        ,
            id: 'ft'
            text: 'Per Cubic Foot'
        ,
            id: 'yd'
            text: 'Per Cubic Yard'
        ,
            id: 'cm'
            text: 'Per Cubic Centimeter'
        ,
            id: 'm'
            text: 'Per Cubic Meter'
    ]

    fields: [
            type: "number"
            placeholder: "Quantity"
            name: "quantity"
            show: true
        ,
            type: "number"
            placeholder: "Length"
            name: "length"
            show: true
        ,
            type: "select"
            placeholder: "Unit"
            name: "length_units"
            show: true
            fieldTypeSelect: true
            optionsType: 'measurement_units'
        ,
            type: "number"
            placeholder: "Width"
            name: "width"
            show: true
        ,
            type: "select"
            placeholder: "Unit"
            name: "width_units"
            show: true
            fieldTypeSelect: true
            optionsType: 'measurement_units'
        ,
            type: "number"
            placeholder: "Depth"
            name: "depth"
            show: true
        ,
            type: "select"
            placeholder: "Unit"
            name: "depth_units"
            show: true
            fieldTypeSelect: true
            optionsType: 'measurement_units'
        ,
            type: "number"
            placeholder: "Price"
            name: "price"
            show: true
        ,
            type: "select"
            placeholder: "Unit"
            name: "price_units"
            show: true
            fieldTypeSelect: true
            optionsType: 'price_units'
        ,
            type: "number"
            placeholder: "Tax rate"
            name: "tax"
            show: true
            mask: 'percentage'
    ]

    initialize: ->
        @help = "Concrete help text"

        self = @
        _(@fields).each (field) =>
            field.options = self.measurement_options if field.optionsType == 'measurement_units'
            field.options = self.price_options if field.optionsType == 'price_units'

    calculate: ->
        tax = @attributes.tax || '0%'
        tax_value = (tax.slice 0, tax.length-1) / 100

        price_units = @attributes.price_units || 'ft'
        price_value = @attributes.price || 0

        depth_units = @attributes.depth_units || 'ft'
        depth_value = @attributes.depth || 0
        depth = Qty(depth_value + ' ' + depth_units).to(price_units)

        length_units = @attributes.length_units || 'ft'
        length_value = @attributes.length || 0
        length = Qty(length_value + ' ' + length_units).to(price_units)

        width_units = @attributes.width_units || 'ft'
        width_value = @attributes.width || 0
        width = Qty(width_value + ' ' + width_units).to(price_units)

        quantity = @attributes.quantity || 0

        @cost = depth.mul(length).mul(width).scalar
        @cost = @cost * quantity * price_value
        @cost = @cost + (@cost * tax_value)

        console.log "concrete: #{depth} (d) * #{width} (w) x #{length} (h) x #{quantity} @ $#{price_value} + #{tax} tax = #{@cost}"
        @cost
