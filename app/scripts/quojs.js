$$('#test').tap(function() {
    // affects "span" children/grandchildren
    alert("works");
});

$$('#concrete_quantity').tap(function() {
    var quantity=$$('#concrete_quantity').val();
    var y=5;
    var z=5;
    var answer = getSquareFeet(quantity, y, z);
    alert(answer);
    $$('#showcalculationconcrete').text(answer);
});