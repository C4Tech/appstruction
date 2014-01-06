class ConcreteModel extends AnotherModel
    validate: (attrs, options) ->
        pass = false
        self = this
        for field in ["quantity", "depth", "width", "length", "price"]
            do (field) ->
                pass = self.checkNumber attrs[field], field unless pass
                null
        pass = "" unless pass
        pass

    calculate: ->
        cost = @attributes.depth * @attributes.width * @attributes.length * @attributes.quantity * @attributes.price
        console.log "#{@attributes.depth}d x #{@attributes.width}w x #{@attributes.length}h x #{@attributes.quantity} @ $#{@attributes.price} = #{cost}"
        cost

getConcreteObject = ->
    new ConcreteModel
        depth: $$("#concrete_depth").val()
        width: $$("#concrete_width").val()
        length: $$("#concrete_length").val()
        quantity: $$("#concrete_quantity").val()
        price: $$("#concrete_price").val()

calculateConcrete = ->
    concrete = getConcreteObject()
    concrete.calculate()

setConcreteTotal = ->
    $$('#showcalculationconcrete').text calculateConcrete()
    true

$$(document).on 'change', '#concreteForm', ->
    setConcreteTotal()
    true
