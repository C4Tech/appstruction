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
    cid: null

    fields: [
            fieldType: 'hidden'
            name: 'group_id'
            label: 'Group Name'
            optionsType: 'group_name_options'
            show: true
            append: '<br />'
        ,
            fieldType: "text"
            name: 'job_name'
            label: 'Job Name'
            show: true
        ,
            fieldType: "hidden"
            name: "job_type"
            label: "What type of job"
            optionsType: 'job_type_options'
            show: true
            append: '<br />'
        ,
            fieldType: "number"
            name: "profit_margin"
            label: "Profit Margin"
            show: false
            required: false
    ]

    initialize: ->
        @attributes.cid = @cid
        super

    defaults: ->
        data =
            job_name: null
            profit_margin: null
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
