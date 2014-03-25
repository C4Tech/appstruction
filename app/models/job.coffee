BaseModel = require "models/base"
LaborModel = require "models/labor"
ConcreteModel = require "models/concrete"
MaterialModel = require "models/material"
EquipmentModel = require "models/equipment"
Collection = require "models/collection"

module.exports = class JobModel extends BaseModel
    localStorage: new Backbone.LocalStorage "cole-job"
    url: "jobs"
    jobRoutes: ['concrete', 'labor', 'materials', 'equipment']

    types: [
            id: "1"
            name: "Slab"
        ,
            id: "2"
            name: "GB- H"
        ,
            id:"3"
            name: "GB - H1A"
        ,
            id:"4"
            name: "GB - V"
        ,
            id:"5"
            name: "Piles"
        ,
            id:"6"
            name: "Truck Well"
    ]

    fields: [
            placeholder: "Job Name"
            name: "name"
            type: "text"
            show: false
        ,
            placeholder: "Type"
            name: "type"
            type: "select"
            show: true
        ,
            placeholder: "Profit Margin"
            name: "margin"
            type: "number"
            show: true
    ]

    defaults: ->
        data =
            name: null
            margin: null
            type: 1
            dirt: null

        @parse data

    parse: (data) ->
        for collection in @jobRoutes
            saved = if data[collection]? then data[collection] else false
            data[collection] = @_inflateCollection collection, saved
        data

    _inflateCollection: (modelType, data) ->
        model = switch modelType
            when "concrete" then ConcreteModel
            when "labor" then LaborModel
            when "materials" then MaterialModel
            when "equipment" then EquipmentModel
        new Collection data, {
                model: model
                modelType: modelType
            }

    calculate: ->
        @cost = @attributes.concrete.calculate() + @attributes.labor.calculate() + @attributes.materials.calculate() + @attributes.equipment.calculate()

        if @cost
            console.log "Job total: #{@attributes.equipment.cost} + #{@attributes.concrete.cost} + #{@attributes.labor.cost} + #{@attributes.materials.cost} = #{@cost}"
        @cost
