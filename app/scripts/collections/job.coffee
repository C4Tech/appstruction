Collection = require "scripts/collections/base"
JobModel = require "scripts/models/job"

module.exports = class JobCollection extends Backbone.Collection
    name: "job"
    url: "jobs"
    model: JobModel
