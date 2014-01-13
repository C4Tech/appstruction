View = require "views/base"

module.exports = class JobView extends View
    name: "job"
    tagName: "li"
    className: "job-list"
    templateFile: "job.list.row"
