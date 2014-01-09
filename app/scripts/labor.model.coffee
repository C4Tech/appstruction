AnotherModel = require "scripts/backbone"

module.exports = class LaborModel extends AnotherModel
    validateFields: ["number", "unit", "rate"]
