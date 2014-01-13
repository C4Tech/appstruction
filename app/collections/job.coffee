Collection = require "collections/base"
JobModel = require "models/job"

module.exports = class JobCollection extends Backbone.Collection
    name: "job"
    url: "jobs"
    model: JobModel
