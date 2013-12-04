$$('div').tap(function() {
    // affects "span" children/grandchildren
    $$('div', this).style('color', 'red');
});