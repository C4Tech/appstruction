View = require "scripts/views/base"

module.exports = class ConcreteView extends View
    templateFile: "concrete.row"
    self: ConcreteView
    container: ".concrete-items"
