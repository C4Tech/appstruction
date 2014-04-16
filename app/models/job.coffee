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

    fields: [
            fieldType: "text"
            name: "name"
            placeholder: "Job Name"
            show: true
        ,
            fieldType: "hidden"
            name: "job_type"
            placeholder: "What type of job"
            optionsType: 'job_type_options'
            show: true
            append: '<br />'
        ,
            fieldType: "number"
            name: "margin"
            placeholder: "Profit Margin"
            show: false
            required: false
    ]

    initialize: ->
        super

    defaults: ->
        data =
            name: null
            margin: null
            job_type: null

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
