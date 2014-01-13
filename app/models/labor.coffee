Model = require "models/base"

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
            @cost = @attributes.number * @attributes.rate * @attributes.unit
            console.log "labor row ##{@cid}: #{@attributes.number} x #{@attributes.unit}u @ $#{@attributes.rate} = #{@cost}"
        @cost
