View = require "scripts/views/base"

module.exports = class MaterialView extends View
    templateFile: "material.row"
    self: MaterialView
    container: ".materials-items"
