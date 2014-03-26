Model = require "models/base"

module.exports = class MaterialModel extends Model
    defaults: _.extend Model.prototype.defaults,
        "quantity": null
        "price": null
        "material_type": 1
        "tax": null

    fields: [
            type: "select"
            name: "material_type"
            placeholder: "Material Type"
            show: true
            fieldTypeSelect: true
            optionsType: 'material_types'
        ,
            type: "number"
            name: "quantity"
            placeholder: "Quantity"
            show: true
        ,
            type: "number"
            name: "price"
            placeholder: "Price"
            show: true
        ,
            type: "number"
            name: "tax"
            placeholder: "Tax rate"
            show: true
            mask: 'percentage'
    ]

    initialize: ->
        @help = "Materials help text"

        return if not @attributes.choices.attributes

        choices = @attributes.choices.attributes
        _(@fields).each (field) =>
            field.options = choices.material_type_options if field.optionsType == 'material_types'

    calculate: ->
        tax = @attributes.tax || '0%'
        tax_value = (tax.slice 0, tax.length-1) / 100

        @cost = @attributes.quantity * @attributes.price
        @cost = @cost + (@cost * tax_value)

        console.log "material row ##{@cid}: #{@attributes.quantity}@#{@attributes.price} + #{tax} tax = #{@cost}"
        @cost
