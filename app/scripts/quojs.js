$$('#test').tap(function() {
    // affects "span" children/grandchildren
    alert("works");
});

$$('#concrete_quantity').tap(function() {
    var depth=$$('#concrete_depth').val();
    console.log(depth);
    var width=$$('#concrete_width').val();
    console.log(width);
    var height=$$('#concrete_length').val();
    console.log(height);
    var answer = getSquareFeet(depth, width, height);
    
    $$('#showcalculationconcrete').text(answer);
});