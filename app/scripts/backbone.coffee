class AnotherModel extends Backbone.Model
    checkNumber: (value, label) ->
        result = false
        result = "You must enter a #{label}" if !value? # null or undefined
        result = "You must enter a #{label}" if value is "" # null or undefined
        result = "#{label} must be a number" if isNaN value # Not a number or empty
        result = "#{label} must be a number" if isNaN parseInt value # Not a number or empty
        result = "#{label} must be at least 1" if value < 1 # negative number
        result
