Collection = require "collections/base"
MaterialModel = require "models/material"

module.exports = class MaterialCollection extends Collection
    name: "materials"
    model: MaterialModel
