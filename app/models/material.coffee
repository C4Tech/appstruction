Model = require "models/base"

module.exports = class MaterialModel extends Model
    defaults:
        "quantity": null
        "price": null
        "type": 1
        "tax": null

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
            type: "number"
            show: true
        ,
            placeholder: "Price"
            name: "price"
            type: "number"
            show: true
        ,
            placeholder: "Type"
            name: "type"
            type: "select"
            show: false
        ,
            text: "Tax rate"
            name: "tax"
            type: "number"
            show: true
    ]

    initialize: ->
        @help = "Materials help text"

    calculate: ->
        @cost = @attributes.quantity * @attributes.price
        console.log "material row ##{@cid}: #{@attributes.quantity}@#{@attributes.price} = #{@cost}"
        @cost
