ChoicesModel = require "models/choices"

module.exports = class BaseModel extends Backbone.Model
    defaults:
        "help": null
        "choices": new ChoicesModel

    fields: []
    cost: 0

    check:
        number: (value, label) ->
            result = false
            result = "You must enter a #{label}" unless value? # null or undefined
            result = "You must enter a #{label}" if value is "" # null or undefined
            result = "#{label} must be a number" if isNaN value # Not a number or empty
            result = "#{label} must be a number" if isNaN parseInt value # Not a number or empty
            result = "#{label} must be at least 1" if value < 1 # negative number
            result

        text: (value, label) ->
            result = false
            result = "You must enter a #{label}" unless value? # null or undefined
            result = "You must enter a #{label}" if value is "" # null or undefined
            result

        select: (value, label) ->
            result = false
            result = "You must select a #{label}" unless value? # null or undefined
            result = "You must select a #{label}" if value is "" # null or undefined
            result = "You must select a #{label}" if value < 1 # negative number
            result

    validate: (attrs, opts) ->
        fail = false
        for field in @fields
            do (field) =>
                unless fail
                    fail = switch field.type
                        when "number", "text", "select" then @check[field.type] attrs[field.name], field.name
                        else false
                null
        fail = "" unless fail
        fail

    getFields: (showAll = false) ->
        fields = if showAll then @fields else _.where @fields, show: true
        field.value = @getValue field for field in fields
        fields

    getValue: (field) =>
        value = @attributes[field.name]

        console.log "Field is #{field.name} with value of #{value}"
        if field.name is "type" and @types?
            value =  @_setValue type, value for type in @types
        value

    _setValue: (type, value) ->
        value = if parseInt(type.id) is parseInt(value) then type.name else value
        value
