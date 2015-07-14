triggerAction = (object, payload = {}, onSuccess = null, onFail = null) ->
  payload.onSuccess = onSuccess if onSuccess?
  payload.onFail = onFail if onFail?
  object.dispatch payload

module.exports = class ResourceActions
  browse: (page = 1, onSuccess, onFail) ->
    triggerAction @, {page: page}, onSuccess, onFail

  find: (query, onSuccess, onFail) ->
    return unless query?
    triggerAction @, {query: query}, onSuccess, onFail

  read: (id, onSuccess, onFail) ->
    triggerAction @, {id: id}, onSuccess, onFail

  edit: (id, data, onSuccess, onFail) ->
    triggerAction @, {id: id, data: data}, onSuccess, onFail

  add: (data, onSuccess, onFail) ->
    triggerAction @, {data: data}, onSuccess, onFail

  delete: (id, onSuccess, onFail) ->
    triggerAction @, {id: id}, onSuccess, onFail

  getRelation: (relation, id, onSuccess = null, onFail = null) ->
    triggerAction @, {id: id, relation: relation}, onSuccess, onFail

  addRelation: (relation, id, data, onSuccess = null, onFail = null) ->
    payload =
      id: id
      relation: relation
      data: data

    triggerAction @, payload, onSuccess, onFail

  deleteRelation: (relation, id, relationId, data, onSuccess, onFail) ->
    payload =
      id: id
      relation: relation
      relationId: relationId
      data: data

    triggerAction @, payload, onSuccess, onFail
