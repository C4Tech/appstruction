ajax = require "ajax"

class ResourceStore
  constructor: (@resource, actions) ->
    @data = {}
    @relations = {}
    @relationsCount = {}
    @count = null

    @getById = (id) =>
      index = @createIndex {id: id}
      return @data[index] if @data[index]?

      actions.read id
      null

    return unless @resource? and actions

    @bindActions actions

  createIndex: (item) ->
    "item-#{item.id}"

  replaceItem: (item) ->
    index = @createIndex item
    @count++ unless @data[index]?
    @data[index] = item
    null

  onBrowse: (payload) ->
    request = ajax.get @resource, page: payload.page
    request.fail payload.onFail if payload.onFail?
    request.done payload.onSuccess if payload.onSuccess?
    request.done (response) =>
      return unless response.success

      @count = 0 unless @count?
      newData = response.data
      newData = [response.data] unless Array.isArray newData
      @replaceItem item for item in newData
      @emitChange()
      null
    null

  onFind: (payload) ->
    request = ajax.post "#{@resource}/find", payload.query
    request.fail payload.onFail if payload.onFail?
    request.done payload.onSuccess if payload.onSuccess?
    request.done (response) =>
      return unless response.success

      @count = 0 unless @count?
      newData = response.data
      newData = [response.data] unless Array.isArray newData
      @replaceItem item for item in newData
      @emitChange()
      null
    null

  onRead: (payload) ->
    request = ajax.get "#{@resource}/#{payload.id}"
    request.fail payload.onFail if payload.onFail?
    request.done payload.onSuccess if payload.onSuccess?
    request.done (response) =>
      return unless response.success
      @replaceItem response.data
      @emitChange()
      null
    null

  onEdit: (payload) ->
    request = ajax.patch "#{@resource}/#{payload.id}", payload.data
    request.fail payload.onFail if payload.onFail?
    request.done payload.onSuccess if payload.onSuccess?
    request.done (response) =>
      return unless response.success
      @replaceItem response.data
      @emitChange()
      null
    null

  onAdd: (payload) ->
    request = ajax.post "#{@resource}", payload.data
    request.fail payload.onFail if payload.onFail?
    request.done payload.onSuccess if payload.onSuccess?
    request.done (response) =>
      return unless response.success
      @replaceItem response.data
      @emitChange()
      null
    null

  onDelete: (payload) ->
    request = ajax.delete "#{@resource}/#{payload.id}"
    request.fail payload.onFail if payload.onFail?
    request.done payload.onSuccess if payload.onSuccess?
    request.done (response) =>
      return unless response.success
      index = @createIndex response.data
      @count-- if @data[index]?
      delete @data[index] if @data[index]?
      @emitChange()
      null
    null

  onGetRelation: (payload) ->
    request = ajax.get "#{@resource}/#{payload.id}/#{payload.relation}"
    request.fail payload.onFail if payload.onFail?
    request.done payload.onSuccess if payload.onSuccess?
    request.done (response) =>
      return unless response.success

      newData = response.data
      newData = [response.data] unless Array.isArray newData
      @relations[payload.relation] = newData
      @relationsCount[payload.relation] = newData.length or 0
      @emitChange()
      null
    null

  onAddRelation: (payload) ->
    endpoint = "#{@resource}/#{payload.id}/#{payload.relation}"
    request = ajax.post endpoint, payload.data
    request.fail payload.onFail if payload.onFail?
    request.done payload.onSuccess if payload.onSuccess?
    request.done (response) =>
      return unless response.success
      @emitChange()
      null
    null

  onDeleteRelation: (payload) ->
    endpoint = "#{@resource}/#{payload.id}/#{payload.relation}"
    endpoint += "/#{payload.relationId}"
    request = ajax.delete endpoint, payload.data
    request.fail payload.onFail if payload.onFail?
    request.done payload.onSuccess if payload.onSuccess?
    request.done (response) =>
      return unless response.success
      @emitChange()
      null
    null

module.exports = ResourceStore
