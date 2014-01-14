Model = require "models/base"

ConcreteCollection = require "collections/concrete"
JobCollection = require "collections/job"
LaborCollection = require "collections/labor"
MaterialCollection = require "collections/material"
EquipmentCollection = require "collections/equipment"

module.exports = class JobModel extends Model
    defaults:
        "name": "Default"
        "margin": 1.07
        "dirt": null
        "type": null
        "concrete": new ConcreteCollection
        "labor": new LaborCollection
        "materials": new MaterialCollection
        "equipment": new EquipmentCollection

    validateFields: [
        "margin": "number"
        "name": "text"
        "type": "select"
    ]

    parse: (data) ->
        concrete = labor = materials = equipment = {}
        concrete = data.concrete if data.concrete?
        data.concrete = new ConcreteCollection concrete

        labor = data.labor if data.labor?
        data.labor = new LaborCollection labor

        materials = data.materials if data.materials?
        data.materials = new MaterialCollection materials

        equipment = data.equipment if data.equipment?
        data.equipment = new EquipmentCollection equipment

        data


    calculate: ->
        @cost = @attributes.concrete.calculate() + @attributes.labor.calculate() + @attributes.materials.calculate() + @attributes.equipment.calculate()

        if @cost
            console.log "Job total: #{@attributes.equipment.cost} + #{@attributes.concrete.cost} + #{@attributes.labor.cost} + #{@attributes.materials.cost} = #{@cost}"
        @cost
