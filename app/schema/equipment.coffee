module.exports =
  fields: [
      fieldType: "hidden"
      label: "Equipment Type"
      name: "equipmentType"
      show: true
      optionsType: "equipmentTypeOptions"
      append: "<br />"
      fieldHelp: true
      fieldHelpValue: Choices.getHelp "dynamicDropdown"
    ,
      fieldType: "number"
      label: "How many"
      name: "quantity"
      show: true
    ,
      fieldType: "number"
      label: "How long"
      name: "equipmentTime"
      show: true
    ,
      fieldType: "number"
      label: "What rate"
      name: "rate"
      show: true
      hasSiblingField: true
    ,
      fieldType: "select"
      placeholder: "Unit"
      name: "rateUnits"
      show: true
      fieldTypeSelect: true
      optionsType: "timePerOptions"
  ]

  calculate: ->
    type = attributes.equipmentType ? ""

    time = convert.toHours attributes.equipmentTime, attributes.rateUnits
    rate = convert.toPerHour attributes.rate, attributes.rateUnits
    quantity = attributes.quantity ? 0
    @cost = time * rate * quantity

    log.trace "equipment row (#{type}) ##{@cid}:
      #{time} (#{attributes.rateUnits}) x #{quantity} (quantity)
      @ $#{rate} (#{attributes.rateUnits}) = #{@cost}"

    @cost

  overview: ->
    quantity = parseFloat attributes.quantity
    time = parseFloat attributes.equipmentTime
    rate = parseFloat attributes.rate

    ["No equipment"] unless @numberValid quantity, time, rate

    quantity = @round quantity
    time = @round time
    rate = @round rate

    typeKey = attributes.equipmentType ? "dump truck"
    type = Choices.getLabelFor typeKey, quantity, "equipmentTypeOptions"

    rateKey = attributes.rateUnits ? "hour"
    timeUnit = Choices.getLabelFor rateKey, quantity, "timeOptions"
    rateUnit = Choices.getLabelFor rateKey, 1, "timeOptions"

    ["#{quantity} #{type} for #{time} #{timeUnit} @ $#{rate}/#{rateUnit}"]
