BaseModel = require "models/base"
ChoicesSingleton = require "models/choices"

module.exports = class MaterialModel extends BaseModel
    defaults:
        "quantity": null
        "price": null
        "material_type": null
        "tax": null

    fields: [
            fieldType: "hidden"
            label: "Material Type"
            name: "material_type"
            show: true
            optionsType: 'material_type_options'
            append: '<br />'
            fieldHelp: true
            fieldHelpValue: ChoicesSingleton.getHelp('dynamicDropdown')
        ,
            fieldType: "number"
            name: "quantity"
            label: "How many"
            show: true
        ,
            fieldType: "number"
            name: "price"
            label: "What price"
            show: true
        ,
            fieldType: "select"
            name: "material_type"
            label: "What Type"
            show: false
        ,
            fieldType: "number"
            name: "tax"
            label: "What tax rate"
            show: true
            displayAppend: '%'
            inputGroup: true
            inputGroupAppend: true
            inputGroupValue: '%'
    ]

    initialize: ->
        super

    calculate: ->
        material_type = @attributes.material_type ? ''

        tax = @attributes.tax ? 0
        tax_value = tax / 100

        quantity = @attributes.quantity ? 0
        price = @attributes.price ? 0

        @cost = quantity * price
        @cost = @cost + (@cost * tax_value)

        console.log "material row (#{material_type}) ##{@cid}: #{quantity}@#{price} + #{tax} tax = #{@cost}"
        @cost

    overview: ->
        no_material = ['No material']
        material_type_display = ChoicesSingleton.get 'material_type_options_display'

        material_type_key = @attributes.material_type ? 'wire'

        quantity = parseFloat(@attributes.quantity) ? 0
        price = parseFloat(@attributes.price) ? 0

        if isNaN(quantity) or quantity == 0
            return no_material
        if isNaN(price) or price == 0
            return no_material

        # round values to no more than 2 decimals
        quantity = Math.round(quantity * 100) / 100
        price = Math.round(price * 100) / 100

        noun_type = 'singular'
        if quantity > 1
            noun_type = 'plural'
        material_type = material_type_display[noun_type][material_type_key]

        price_type = material_type_display['singular'][material_type_key]

        material_item = "#{quantity} #{material_type} @ $#{price}/#{price_type}"

        return [
            material_item,
        ]
