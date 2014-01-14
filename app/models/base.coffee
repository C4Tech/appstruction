module.exports = class BaseModel extends Backbone.Model
    validateFields: []
    cost: 0

    checkNumber: (value, label) ->
        result = false
        result = "You must enter a #{label}" unless value? # null or undefined
        result = "You must enter a #{label}" if value is "" # null or undefined
        result = "#{label} must be a number" if isNaN value # Not a number or empty
        result = "#{label} must be a number" if isNaN parseInt value # Not a number or empty
        result = "#{label} must be at least 1" if value < 1 # negative number
        result

    checkText: (value, label) ->
        result = false
        result = "You must enter a #{label}" unless value? # null or undefined
        result = "You must enter a #{label}" if value is "" # null or undefined
        result

    checkSelect: (value, label) ->
        result = false
        result = "You must select a #{label}" unless value? # null or undefined
        result = "You must select a #{label}" if value is "" # null or undefined
        result = "You must select a #{label}" if value < 1 # negative number
        result

    validate: (attrs, opts) ->
        fail = false
        for field, type in @validateFields
            do (field, type) =>
                unless fail
                    fail = switch type
                        when "number" then @checkNumber attrs[field], field
                        when "text" then @checkText attrs[field], field
                        when "select" then @checkSelect attrs[field], field
                        else "This may be wrong but I can't tell why"
                null
        fail = "" unless fail
        fail
