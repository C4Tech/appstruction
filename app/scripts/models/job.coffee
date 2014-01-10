Model = require "scripts/models/base"

ConcreteModel = require "scripts/models/concrete"
JobCollection = require "scripts/collections/job"
LaborCollection = require "scripts/collections/labor"
MaterialCollection = require "scripts/collections/material"
EquipmentCollection = require "scripts/collections/equipment"

module.exports = class JobModel extends Model
    defaults:
        "name": null
        "margin": 1.07
        "dirt": null
        "concrete": null
        "labor": null
        "materials": null
        "equipment": null

    validateFields: [
        "name"
        "margin"
    ]
    
    initialize: ->
        @parse {}


    parse: (data) ->
        concrete = data.concrete if data.concrete? else {}
        data.concrete = new ConcreteModel concrete
        
        labor = data.labor if data.labor? else {}
        data.labor = new LaborCollection labor

        materials = data.materials if data.materials? else {}
        data.materials = new MaterialCollection materials

        equipment = data.equipment if data.equipment? else {}
        data.equipment = new EquipmentCollection equipment

        data


    calculate: ->
        if @hasChanged() and @attributes.concrete? and @attributes.labor? and @attributes.materials? and @attributes.equipment?
            @cost = @attributes.concrete.calculate() + @attributes.labor.calculate() + @attributes.materials.calculate() + @attributes.equipment.calculate()
            $$('#grand_total').text @cost
            console.log "Job total: #{@attributes.equipment.cost} + #{@attributes.concrete.cost} + #{@attributes.labor.cost} + #{@attributes.materials.cost} + #{@attributes.dirt} = #{@cost}"
        @cost
