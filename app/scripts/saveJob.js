$$('#savejobbutton').tap(function() {
    activeJob = getActiveJob();
    activeJob.save().done(function(res) {
        var jobs;
        console.log("done", res);
        jobs = new JobCollection;
        return allJobs = jobs.fetch().done(function(res) {
            return console.log("all", res);
        });
    });
    return true;
});

function getActiveJob() {
    var materialsCollection = getActiveMaterialsCollection();
    var equipmentCollection = getActiveEquipmentCollection();
    var laborCollection = getActiveLaborCollection();
    var name = $$('#job_name_field').val();
    var profitMargin = $$('#profit_margin_field').val();
    activeJob = new JobModel({
        materials: materialsCollection,
        labor: laborCollection,
        equipment: equipmentCollection,
        name: name,
        profitMargin: profitMargin
    });
    return activeJob;
}

function getActiveMaterialsCollection() {
    var output = new MaterialCollection();
    for (var i = 2; i < materialsSubDivs; i++) {
        var materialsObj = getMaterialObject(i);
        output.add(materialsObj);
    }
    return output;
}

function getActiveEquipmentCollection() {
    var output = new EquipmentCollection();
    for (var i = 2; i < equipmentSubDivs; i++) {
        var equipmentObject = getEquipmentObject(i);
        output.add(equipmentObject);
    }
    return output;
}

function getActiveLaborCollection() {
    var output = new LaborCollection();
    for (var i = 2; i < laborSubDivs; i++) {
        var laborObject = getLaborObject(i);
        output.add(laborObject);
    }
    return output;
}