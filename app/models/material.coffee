BaseModel = require "models/base"

module.exports = class MaterialModel extends BaseModel
    defaults:
        "quantity": null
        "price": null
        "material_type": null
        "tax": null

    fields: [
            fieldType: "select"
            name: "material_type"
            placeholder: "Material Type"
            show: true
            fieldTypeSelect: true
            optionsType: 'material_type_options'
        ,
            fieldType: "number"
            name: "quantity"
            placeholder: "How many"
            show: true
        ,
            fieldType: "number"
            name: "price"
            placeholder: "What price"
            show: true
        ,
            fieldType: "select"
            name: "material_type"
            placeholder: "What Type"
            show: false
        ,
            fieldType: "number"
            name: "tax"
            placeholder: "Tax rate"
            show: true
            mask: 'percentage'
    ]

    initialize: ->
        @help = "Materials help text"
        super

    calculate: ->
        tax = @attributes.tax ? '0%'
        tax_value = (tax.slice 0, tax.length-1) / 100

        quantity = @attributes.quantity ? 0
        price = @attributes.price ? 0

        @cost = quantity * price
        @cost = @cost + (@cost * tax_value)

        console.log "material row ##{@cid}: #{quantity}@#{price} + #{tax} tax = #{@cost}"
        @cost
