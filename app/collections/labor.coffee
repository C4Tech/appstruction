Collection = require "collections/base"
LaborModel = require "models/labor"

module.exports = class LaborCollection extends Collection
    name: "labor"
    model: LaborModel
