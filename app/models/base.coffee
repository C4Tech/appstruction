ChoicesSingleton = require "models/choices"

module.exports = class BaseModel extends Backbone.Model
    fields: []
    cost: 0

    check:
        number: (value, label, required) ->
            result = false

            # add double quotes around label
            label = "\"#{label}\""

            if required
                result = "You must enter a #{label}" unless value? # null or undefined
                result = "You must enter a #{label}" if value is "" # null or undefined

            if value?
                result = "#{label} must be a number" if isNaN value # Not a number or empty
                result = "#{label} must be a number" if isNaN parseInt value # Not a number or empty
                result = "#{label} must be at least 0" if value < 0 # negative number
            result

        text: (value, label, required) ->
            result = false
            if required
                result = "You must enter a #{label}" unless value? # null or undefined
                result = "You must enter a #{label}" if value is "" # null or undefined
            result

        select: (value, label, required) ->
            result = false
            if required
                result = "You must select a #{label}" unless value? # null or undefined
                result = "You must select a #{label}" if value is "" # null or undefined

            if value?
                result = "You must select a #{label}" if value < 0 # negative number
            result

    initialize: ->
        _(@fields).each (field) =>
            field.displayLabel = field.label ? field.placeholder
            field.options = ChoicesSingleton.get field.optionsType

    validate: (attrs, opts) ->
        fail = false
        for field in @fields
            required = field.required ? true
            label = field.label ? field.placeholder
            do (field) =>
                unless fail
                    fail = switch field.fieldType
                        when "number", "text", "select" then @check[field.fieldType] attrs[field.name], label, required
                        else false
                null
        fail = "" unless fail
        fail

    getField: (name) ->
        found = _.where @fields, {name: name}
        return found[0] ? null

    getFields: (showAll = false) ->
        fields = if showAll then @fields else _.where @fields, show: true
        field.value = @getValue field for field in fields
        fields

    getValue: (field) =>
        value = @attributes[field.name]

        console.log "Field is #{field.name} with value of #{value}"
        if field.options?
            value = @_setValue item, value for item in field.options
        value

    _setValue: (item, value) ->
        value = if parseInt(item.id) is parseInt(value) then item.text else value
        value
