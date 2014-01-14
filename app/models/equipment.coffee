Model = require "models/base"

module.exports = class EquipmentModel extends Model
    defaults:
        "type": null
        "quantity": null
        "rate": null

    validateFields: [
        "quantity": "number"
        "rate": "number"
        "type": "select"
    ]

    calculate: ->
        if @hasChanged()
            @cost = @attributes.quantity * @attributes.rate
            console.log "equipment row ##{@cid}: #{@attributes.quantity}@$#{@attributes.rate} = #{@cost}"
        @cost
