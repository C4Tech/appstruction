Model = require "scripts/models/base"

ConcreteCollection = require "scripts/collections/concrete"
JobCollection = require "scripts/collections/job"
LaborCollection = require "scripts/collections/labor"
MaterialCollection = require "scripts/collections/material"
EquipmentCollection = require "scripts/collections/equipment"

module.exports = class JobModel extends Model
    defaults:
        "name": "Default"
        "margin": 1.07
        "dirt": null
        "concrete": new ConcreteCollection
        "labor": new LaborCollection
        "materials": new MaterialCollection
        "equipment": new EquipmentCollection

    validateFields: [
        "name"
        "margin"
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
        if @hasChanged() and @attributes.concrete? and @attributes.labor? and @attributes.materials? and @attributes.equipment?
            @cost = @attributes.concrete.calculate() + @attributes.labor.calculate() + @attributes.materials.calculate() + @attributes.equipment.calculate()
            $$('#grand_total').text @cost
            console.log "Job total: #{@attributes.equipment.cost} + #{@attributes.concrete.cost} + #{@attributes.labor.cost} + #{@attributes.materials.cost} + #{@attributes.dirt} = #{@cost}"
        @cost
