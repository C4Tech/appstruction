Model = require "models/base"

module.exports = class ConcreteModel extends Model
    defaults:
        "quantity": null
        "depth": null
        "width": null
        "length": null
        "price": null
        "tax": null

    validateFields: [
        "quantity"
        "depth"
        "width"
        "length"
        "price"
    ]

    calculate: ->
        if @hasChanged()
            @cost = @attributes.depth * @attributes.width * @attributes.length * @attributes.quantity * @attributes.price
            console.log "concrete: #{@attributes.depth}d x #{@attributes.width}w x #{@attributes.length}h x #{@attributes.quantity} @ $#{@attributes.price} = #{@cost}"
        @cost
