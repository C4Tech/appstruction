# @todo: convert to a View method
$$('#add_another_materials').tap ->
    # @todo: make dynamic
    lastRow = materialsSubDivs

    row = getMaterialObject lastRow
    if (!row.isValid())
        alert row.validationError
        resetMaterialRow lastRow
        setMaterialSubtotal()
    else
        activeJob.get('materials').add(row)
        materialsDivs.add row
        lastRow++
        # @todo: make dynamic
        materialsSubDivs++
        # the parameter is used to set id="materials_rate_{{ rowNumber }}", as in id="materials_rate_3"
        $$('#materials_subtotals').append getMaterialsDiv lastRow

    true