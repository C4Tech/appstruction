Collection = require "collections/base"
ConcreteModel = require "models/concrete"

module.exports = class ConcreteCollection extends Collection
    name: "concrete"
    model: ConcreteModel
