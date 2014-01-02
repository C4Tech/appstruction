calculateConcrete = ->
    depth = $$('#concrete_depth').val()
    width = $$('#concrete_width').val()
    height = $$('#concrete_length').val()
    quantity = $$('#concrete_quantity').val()
    price = $$('#concrete_price').val()
    cost = depth * width * height * quantity * price
    console.log "concrete #{width}x#{height}x#{depth} (#{quantity}) @ #{price} = #{cost}"
    cost

setConcreteTotal = ->
    $$('#showcalculationconcrete').text calculateConcrete()
    true

$$(document).on 'change', '#concreteForm', ->
    setConcreteTotal()
    true
