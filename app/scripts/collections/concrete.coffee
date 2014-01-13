Collection = require "scripts/collections/base"
ConcreteModel = require "scripts/models/concrete"

module.exports = class ConcreteCollection extends Collection
    name: "concrete"
    model: ConcreteModel
