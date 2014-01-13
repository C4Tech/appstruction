Collection = require "collections/base"
EquipmentModel = require "models/equipment"

module.exports = class EquipmentCollection extends Collection
    name: "equipment"
    model: EquipmentModel
