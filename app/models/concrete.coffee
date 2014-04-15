BaseModel = require "models/base"

module.exports = class ConcreteModel extends BaseModel
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

    fields: [
            fieldType: "number"
            name: "quantity"
            placeholder: "How many"
            show: true
        ,
            fieldType: "number"
            name: "length"
            placeholder: "How long"
            show: true
            displayBegin: true
        ,
            fieldType: "select"
            placeholder: "Unit"
            name: "length_units"
            show: true
            fieldTypeSelect: true
            optionsType: 'measurement_options'
            displayEnd: true
        ,
            fieldType: "number"
            placeholder: "How wide"
            name: "width"
            show: true
            displayBegin: true
        ,
            fieldType: "select"
            placeholder: "Unit"
            name: "width_units"
            show: true
            fieldTypeSelect: true
            optionsType: 'measurement_options'
            displayEnd: true
        ,
            fieldType: "number"
            placeholder: "How deep"
            name: "depth"
            show: true
            displayBegin: true
        ,
            fieldType: "select"
            placeholder: "Unit"
            name: "depth_units"
            show: true
            fieldTypeSelect: true
            optionsType: 'measurement_options'
            displayEnd: true
        ,
            fieldType: "number"
            placeholder: "What price"
            name: "price"
            show: true
            displayBegin: true
            displayPrepend: '$'
        ,
            fieldType: "select"
            placeholder: "Unit"
            name: "price_units"
            show: true
            fieldTypeSelect: true
            optionsType: 'price_options'
            displayEnd: true
        ,
            fieldType: "number"
            placeholder: "What tax rate"
            name: "tax"
            show: true
            displayAppend: '%'
            mask: 'percentage'
    ]

    initialize: ->
        @help = "Concrete help text"
        super

    calculate: ->
        tax = @attributes.tax ? '0%'
        tax_value = (tax.slice 0, tax.length-1) / 100

        price_units = @attributes.price_units ? 'ft'
        price_value = @attributes.price ? 0

        depth_units = @attributes.depth_units ? 'ft'
        depth_value = @attributes.depth ? 0
        depth = Qty(depth_value + ' ' + depth_units).to(price_units)

        length_units = @attributes.length_units ? 'ft'
        length_value = @attributes.length ? 0
        length = Qty(length_value + ' ' + length_units).to(price_units)

        width_units = @attributes.width_units ? 'ft'
        width_value = @attributes.width ? 0
        width = Qty(width_value + ' ' + width_units).to(price_units)

        quantity = @attributes.quantity ? 0

        @cost = depth.mul(length).mul(width).scalar
        @cost = @cost * quantity * price_value
        @cost = @cost + (@cost * tax_value)

        console.log "concrete: #{depth} (d) * #{width} (w) x #{length} (h) x #{quantity} @ $#{price_value} + #{tax} tax = #{@cost}"
        @cost
