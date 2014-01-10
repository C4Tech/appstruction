Collection = require "scripts/collections/base"
EquipmentModel = require "scripts/models/equipment"

module.exports = class EquipmentCollection extends Collection
    name: "equipment"
    model: EquipmentModel
