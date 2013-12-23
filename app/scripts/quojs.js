$$('#test').tap(function() {
    // affects "span" children/grandchildren
    alert("works");
});

$$(document).on('change', '#concreteForm', function() {
    var depth=$$('#concrete_depth').val();
    console.log(depth);
    var width=$$('#concrete_width').val();
    console.log(width);
    var height=$$('#concrete_length').val();
    console.log(height);
    var squareFeet = getSquareFeet(depth, width, height);
    var quantity =$$('#concrete_quantity').val();
    var answer = squareFeet * quantity;
    $$('#showcalculationconcrete').text(answer);
});

$$(document).on('change', '#equipment', function() {
    var equipQuantity =$$('#equipment_quantity_1').val();
    var equipRate =$$('#equipment_rate_1').val();
    var answer = equipQuantity * equipRate;
    $$('#showcalculationequipment').text(answer);
});