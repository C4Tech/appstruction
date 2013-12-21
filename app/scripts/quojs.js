$$('#test').tap(function() {
    // affects "span" children/grandchildren
    alert("works");
});

$$('#concrete input[type=text]').tap(function() {
    var x=5;
    var y=5;
    var z=5;
    var answer = getSquareFeet(x, y, z);
    $$('div.showcalculation').text(answer);
});