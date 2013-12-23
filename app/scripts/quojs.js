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

$$(document).on('load', '#labor_subtotals', function() {
    alert("hi there");
});

$$(document).on('change', '#equipment', function() {
    var equipQuantity =$$('#equipment_quantity_1').val();
    var equipRate =$$('#equipment_rate_1').val();
    var answer = equipQuantity * equipRate;
    $$('#showcalculationequipment').text(answer);
});

$$(document).on('change', '#materials', function() {
    var materials_quantity =$$('#materials_quantity').val();
    console.log(materials_quantity);
    var materials_price =$$('#materials_price').val();
    console.log(materials_price);
    var answer = materials_quantity * materials_price;
    $$('#showcalculationmaterials').text(answer);
});

$$('#add_another_labor').tap(function() {
    var html = $$('#labor_subtotals').html();
    $$('#labor_subtotals').html(html + getLaborDiv(1));
});