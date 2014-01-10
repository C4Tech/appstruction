Model = require "scripts/models/base"

module.exports = class LaborModel extends Model
    defaults: 
        "type": null
        "number": null
        "unit": null
        "rate": null

    validateFields: [
        "number"
        "unit"
        "rate"
    ]

    calculate: ->
        if @hasChanged()
            @cost = @attributes.quantity * @attributes.rate * @attributes.unit
            console.log "labor row ##{@cid}: #{@attributes.quantity} x #{@attributes.unit}u @ $#{@attributes.rate} = #{@cost}"
        @cost
