Collection = require "scripts/collections/base"
LaborModel = require "scripts/models/labor"

module.exports = class LaborCollection extends Collection
    name: "labor"
    model: LaborModel
