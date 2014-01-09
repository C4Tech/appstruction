LaborModel = require "scripts/labor.model"

module.exports = class LaborCollection extends Backbone.Collection
    model: LaborModel
    localStorage: new Backbone.LocalStorage("cole-labor")
