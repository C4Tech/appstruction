View = require "scripts/views/base"

module.exports = class EquipmentView extends View
    templateFile: "equipment.row"
    self: EquipmentView
    container: ".equipment-items"
