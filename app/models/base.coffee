module.exports = class BaseModel extends Backbone.Model
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
        field.value = @attributes[field.name] for field in fields
        fields
