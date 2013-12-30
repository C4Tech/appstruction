var EquipmentSubtotal = Backbone.Model.extend({
  validate: function(attrs, options) {
    if (attrs.quantity){
    	 if (isNaN(attrs.quantity)){
      		return "Quantity can't be less than 0";
    	}
    	if (attrs.quantity < 0) {
      		return "Quantity can't be less than 0";
    	}
	}
	else{
		return "You must enter a quantity";
	}
	if (attrs.rate){
    	 if (isNaN(attrs.rate)){
      		return "Rate can't be less than 0";
    	}
    	if (attrs.rate < 0) {
      		return "Rate can't be less than 0";
    	}
	}
	else{
		return "You must enter a rate";
	}
  }
});

function getEquipmentSubDivObject(equipmentSubDivs)
{
  var subDivRate = $$('#equipment_rate_' + equipmentSubDivs).val();
  var subDivQuantity = $$('#equipment_quantity_' + equipmentSubDivs).val();
  var one = new EquipmentSubtotal({
      rate : subDivRate,
      quantity: subDivQuantity
  });

  return one;

}

    