Model = require "models/base"

module.exports = class MaterialModel extends Model
    defaults:
        "quantity": null
        "price": null
        "type": 1

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
            placeholder: "How many"
            name: "quantity"
            type: "number"
            show: true
        ,
            placeholder: "What price"
            name: "price"
            type: "number"
            show: true
        ,
            placeholder: "What type"
            name: "type"
            type: "select"
            show: false
    ]

    initialize: ->
        @help = "Materials help text"

    calculate: ->
        @cost = @attributes.quantity * @attributes.price
        console.log "material row ##{@cid}: #{@attributes.quantity}@#{@attributes.price} = #{@cost}"
        @cost
