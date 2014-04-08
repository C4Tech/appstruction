BaseModel = require "models/base"

module.exports = class MaterialModel extends BaseModel
    defaults:
        "quantity": null
        "price": null
        "material_type": 1

    types: [
            id: "1"
            name: "Wire (sheet)"
        ,
            id: "2"
            name: "Keyway (lf)"
        ,
            id:"3"
            name: "Stakes (ea.)"
        ,
            id:"4"
            name: "Cap (lf)"
        ,
            id:"5"
            name: "Dowells  (ea.)"
        ,
            id:"6"
            name: "2x8x20  (lf)"
        ,
            id:"7"
            name: "Misc"
    ]

    fields: [
            placeholder: "Quantity"
            name: "quantity"
            fieldType: "number"
            show: true
        ,
            placeholder: "Price"
            name: "price"
            fieldType: "number"
            show: true
        ,
            placeholder: "Material Type"
            name: "material_type"
            fieldType: "select"
            show: false
    ]

    initialize: ->
        @help = "Materials help text"

    calculate: ->
        @cost = @attributes.quantity * @attributes.price
        console.log "material row ##{@cid}: #{@attributes.quantity}@#{@attributes.price} = #{@cost}"
        @cost
