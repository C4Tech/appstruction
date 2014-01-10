Collection = require "scripts/collections/base"
MaterialModel = require "scripts/models/material"

module.exports = class MaterialCollection extends Collection
    name: "materials"
    model: MaterialModel
