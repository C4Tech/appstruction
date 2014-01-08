window.onload = function() {
    var allJobs = new JobCollection;
    allJobs.fetch();
    allJobs.forEach(function(entry) {
        console.log(entry.attributes.name);
        Backbone.sync("delete", entry);
    });
};