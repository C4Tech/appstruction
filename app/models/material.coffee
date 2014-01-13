Model = require "models/base"

module.exports = class MaterialModel extends Model
    defaults:
        "quantity": null
        "price": null
        "type": null

    validateFields: [
        "quantity"
        "price"
    ]

    calculate: ->
        if @hasChanged()
            @cost = @attributes.quantity * @attributes.price
            console.log "material row ##{@cid}: #{@attributes.quantity}@#{@attributes.price} = #{@cost}"
        @cost
