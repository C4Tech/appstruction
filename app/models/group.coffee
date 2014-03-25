BaseModel = require "models/base"

module.exports = class GroupsModel extends BaseModel
    localStorage: new Backbone.LocalStorage "cole-groups"

    fields: [
        text: "Group Name"
        name: "group_name"
        type: "text"
        show: true
    ]
