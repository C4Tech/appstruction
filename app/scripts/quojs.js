$$(document).on('change', '#concreteForm', function() {
    var depth=$$('#concrete_depth').val();
    var width=$$('#concrete_width').val();
    var height=$$('#concrete_length').val();
    var quantity =$$('#concrete_quantity').val();
    var totalConcrete = depth * width * height * quantity;
    var concrete_price = $$('#concrete_price').val();
    var totalAmt = totalConcrete * concrete_price;
    $$('#showcalculationconcrete').text(totalAmt);
});

$$(document).on('change', '#equipment', function() {
    var answer = getSubTotalEquipment();
    $$('#showcalculationequipment').text(answer);
});

$$(document).on('change', '#equipment', function() {
    var answer = getSubTotalEquipment();
    $$('#showcalculationequipment').text(answer);
});

$$(document).on('change', '#makerTwo', function() {
    var answer = getGrandTotal();
    $$('#grand_total').text(answer);
});

$$(document).on('change', '#materials', function() {
    var answer = getSubTotalMaterials();
    $$('#showcalculationmaterials').text(answer);
});

$$('#add_another_labor').tap(function() {
    $$('#labor_subtotals').append(getLaborDiv(laborSubDivs)); //the parameter is used to set id="equipment_rate_equipmentSubDivs", as in id="equipment_rate_3"
    laborSubDivs = laborSubDivs + 1;

});

$$('#add_another_equipment').tap(function() {
    $$('#equipment_subtotals').append(getEquipmentDiv(equipmentSubDivs)); //the parameter is used to set id="equipment_rate_equipmentSubDivs", as in id="equipment_rate_3"
    equipmentSubDivs = equipmentSubDivs + 1;
});

$$('#add_another_materials').tap(function() {
    $$('#materials_subtotals').append(getMaterialsDiv(materialsSubDivs));
    materialsSubDivs = materialsSubDivs + 1;
});

$$('#makerTwo').ready(function() {
    resetJobMaker();
});