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
