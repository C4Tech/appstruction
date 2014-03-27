BaseModel = require "models/base"
LaborModel = require "models/labor"
ConcreteModel = require "models/concrete"
MaterialModel = require "models/material"
EquipmentModel = require "models/equipment"
JobCollection = require "models/job-collection"

module.exports = class JobModel extends BaseModel
    localStorage: new Backbone.LocalStorage "cole-job"
    url: "jobs"
    jobRoutes: ['concrete', 'labor', 'materials', 'equipment']

    types: [
            id: "1"
            text: "Slab"
        ,
            id: "2"
            text: "GB- H"
        ,
            id:"3"
            text: "GB - H1A"
        ,
            id:"4"
            text: "GB - V"
        ,
            id:"5"
            text: "Piles"
        ,
            id:"6"
            text: "Truck Well"
    ]

    fields: [
            placeholder: "Job Name"
            name: "name"
            fieldType: "text"
            show: false
        ,
            placeholder: "Job Type"
            name: "job_type"
            fieldType: "select"
            show: true
        ,
            placeholder: "Profit Margin"
            name: "margin"
            fieldType: "number"
            show: true
    ]

    defaults: ->
        data =
            name: null
            margin: null
            job_type: 1
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
        new JobCollection data, {
                model: model
                modelType: modelType
            }

    calculate: ->
        @cost = @attributes.concrete.calculate() + @attributes.labor.calculate() + @attributes.materials.calculate() + @attributes.equipment.calculate()

        if @cost
            console.log "Job total: #{@attributes.equipment.cost} + #{@attributes.concrete.cost} + #{@attributes.labor.cost} + #{@attributes.materials.cost} = #{@cost}"
        @cost
