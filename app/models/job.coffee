BaseModel = require "models/base"
LaborModel = require "models/labor"
ConcreteModel = require "models/concrete"
MaterialModel = require "models/material"
EquipmentModel = require "models/equipment"
Collection = require "models/collection"

module.exports = class JobModel extends BaseModel
    localStorage: new Backbone.LocalStorage "cole-job"
    url: "jobs"

    job_type_options: [
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

    group_name_options: [
            id: "1"
            text: "G1"
        ,
            id: "2"
            text: "G2"
        ,
            id:"3"
            text: "G3"
    ]

    fields: [
            name: 'group_name'
            type: 'select'
            label: 'Group Name'
            fieldTypeSelect: true
            optionsType: 'group_name'
            show: true
        ,
            name: "job_name"
            type: "text"
            label: 'Job Name'
            show: true
        ,
            name: "job_type"
            type: "select"
            label: 'Select a job type'
            fieldTypeSelect: true
            optionsType: 'job_type'
            show: true
        ,
            name: "profit_margin"
            type: "number"
            label: 'Profit Margin'
            show: false
    ]

    initialize: ->
        self = @
        _(@fields).each (field) =>
            field.options = self.job_type_options if field.optionsType == 'job_type'
            field.options = self.group_name_options if field.optionsType == 'group_name'

    defaults: ->
        data =
            name: null
            margin: null
            type: 1

        @parse data

    parse: (data) ->
        collections = ["concrete", "labor", "materials", "equipment"]
        for collection in collections
            saved = if data[collection]? then data[collection] else false
            data[collection] = @_inflateCollection collection, saved
        data

    _inflateCollection: (type, data) ->
        model = switch type
            when "concrete" then ConcreteModel
            when "labor" then LaborModel
            when "materials" then MaterialModel
            when "equipment" then EquipmentModel
        new Collection data, {
                model: model
                type: type
            }

    calculate: ->
        @cost = @attributes.concrete.calculate() + @attributes.labor.calculate() + @attributes.materials.calculate() + @attributes.equipment.calculate()

        if @cost
            console.log "Job total: #{@attributes.equipment.cost} + #{@attributes.concrete.cost} + #{@attributes.labor.cost} + #{@attributes.materials.cost} = #{@cost}"
        @cost
