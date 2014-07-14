BaseModel = require "models/base"
ChoicesSingleton = require "models/choices"

module.exports = class ConcreteModel extends BaseModel
    defaults:
        "concrete_type": null
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

    volume: 0

    fields: [
            fieldType: "hidden"
            label: "What item"
            name: "concrete_type"
            show: true
            optionsType: 'concrete_type_options'
            append: '<hr />'
        ,
            fieldType: "number"
            name: "quantity"
            label: 'How many'
            show: true
        ,
            fieldType: "number"
            name: "length"
            label: "How long"
            show: true
            displayBegin: true
            hasSiblingField: true
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
            label: "How wide"
            name: "width"
            show: true
            displayBegin: true
            hasSiblingField: true
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
            label: "How deep"
            name: "depth"
            show: true
            displayBegin: true
            hasSiblingField: true
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
            label: "What price"
            name: "price"
            show: true
            displayBegin: true
            displayPrepend: '$'
            hasSiblingField: true
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
            label: "What tax rate"
            name: "tax"
            show: true
            displayAppend: '%'
            inputGroup: true
            inputGroupAppend: true
            inputGroupValue: '%'
    ]

    initialize: ->
        super

    calculate: ->
        concrete_type = @attributes.concrete_type ? ''
        tax = @attributes.tax ? 0
        tax_value = tax / 100

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

        @volume = depth.mul(length).mul(width).scalar
        @volume = @volume * quantity
        @cost = @volume * price_value
        @cost = @cost + (@cost * tax_value)

        console.log "concrete row (#{concrete_type}) ##{@cid}: #{depth} (d) * #{width} (w) x #{length} (h) x #{quantity} @ $#{price_value} + #{tax} tax = #{@cost}"
        @cost

    overview: ->
        no_concrete = ['No concrete']
        price_options_display = ChoicesSingleton.get 'price_options_display'
        concrete_type_display = ChoicesSingleton.get 'concrete_type_options_display'
        price_units_key = @attributes.price_units ? 'ft'
        concrete_type_key = @attributes.concrete_type ? '1'
        quantity = @attributes.quantity ? 0

        price_value = parseFloat(@attributes.price) ? 0

        if isNaN(@volume) or @volume == 0
            return no_concrete
        else if isNaN(price_value) or price_value == 0
            return no_concrete

        noun_type = 'singular'
        if @volume > 1
            noun_type = 'plural'
        price_units = price_options_display[noun_type][price_units_key]

        noun_type = 'singular'
        if quantity > 1
            noun_type = 'plural'
        concrete_type = concrete_type_display[noun_type][concrete_type_key]
        unless concrete_type?
            concrete_type = ChoicesSingleton.getTextById('concrete_type_options', concrete_type_key).toLowerCase()

        concrete_item = "Items: #{quantity} #{concrete_type}"

        volume_rounded = Math.round(@volume * 100) / 100
        volume_item = "#{volume_rounded} #{price_units} of concrete"

        price_units = price_options_display.singular[price_units_key]
        price_item = "$#{price_value.toFixed(2)} per #{price_units}"

        total_item = "Total price: $#{@cost.toFixed(2)}"

        return [
            concrete_item,
            volume_item,
            price_item,
            total_item
        ]
