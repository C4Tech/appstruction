function getMaterialSubDivCost(subDivNumber)
{
	var materials_quantity =$$('#materials_quantity_' + subDivNumber).val();
    var materials_price =$$('#materials_price_' + subDivNumber).val();
    return materials_quantity * materials_price;
}

function getSubTotalMaterials()
{
	runningTotal = 0;
	for (var i=1;i<=materialsSubDivs;i++){
		var materials_quantity =$$('#materials_quantity_' + i).val();
    	var materials_price =$$('#materials_price_' + i).val();
		runningTotal = runningTotal + (materials_quantity * materials_price);
	}

    return runningTotal;
}

var equipmentSubDivs=1;
var laborSubDivs=1;
var materialsSubDivs=1;