$$('.job_load_label').tap -> 
	accounts = new JobCollection();
	myJob = accounts.fetch({ data: $.param({ id: '7a107f87-be69-5efa-107c-c045e75940cf'}) });
	console.log(myJob)

activeJob = new JobModel(
	materials: new MaterialCollection(),
	labor: new LaborCollection(),
	equipment: new EquipmentCollection(),
	name: 'Default',
	profitMargin: 1.07	
)