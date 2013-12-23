getLaborDiv = (x) -> "<div id='labor_subdiv_" + x + "' class='form subdiv'>
                <fieldset>
                    <select>
                        <option value='1'>
                            Finishers
                        </option>
                        <option value='2'>
                            Supervisors
                        </option>
                        <option value='3'>
                            Forms crp
                        </option>
                        <option value='4'>
                            Laborers
                        </option>
                        <option value='5'>
                            Driver
                        </option>
                        <option value='6'>
                            Operator
                        </option>
                    </select>
                </fieldset>
                <fieldset>
                        <input placeholder='Number'  id='labor_number_" + x +  "' type='text'></input>
                        <input placeholder='Unit' id='labor_unit_" + x +  "' type='text'></input>
                        <input placeholder='Rate' id='labor_rate_" + x +  "' type='text'></input>
                </fieldset>        
            </div>"

getMaterialsDiv = (x) -> "<div id='materials_subdiv_" + x + "' class='form subdiv'>
                <fieldset>
                    <select>

                        <option value='1'>
                            Wire(sheet)
                        </option>

                        <option value='2'>
                            Keyway (lf)
                        </option>

                        <option value='3'>
                            Stakes (ea.)
                        </option>

                        <option value='4'>
                            Cap (lf)
                        </option>

                        <option value='5'>
                            Dowells  (ea.)
                        </option>

                        <option value='6'>
                            2x8x20  (lf)
                        </option>

                        <option value='7'>
                            Misc
                        </option>
                    </select>
                </fieldset>
                <fieldset>
                    <input placeholder='Quantity' id='materials_quantity_" + x + "' type='text'></input>
                    <input placeholder='Price' 
                    id='materials_price_" + x + "' 
                    type='text'></input>
                </fieldset>
            </div>"


getEquipmentDiv = (x) ->  "<div id='equipment_subdiv_" + x + "' class='form subdiv'>
                <fieldset>

                    <select>

                        <option value='1'>
                            Dump Truck
                        </option>

                        <option value='2'>
                            Excavator
                        </option>

                        <option value='3'>
                            Bobcat
                        </option>

                        <option value='4'>
                            C pump
                        </option>

                        <option value='5'>
                            Piles
                        </option>

                        <option value='6'>
                            Trial
                        </option>

                        <option value='7'>
                            Util Truck
                        </option>

                    </select>
                </fieldset>

                <fieldset>
                    <input id='equipment_quantity_" + x + "' placeholder='Quantity'  type='text'></input>
                    <input id='equipment_rate_" + x + "' placeholder='Rate' type='text'></input>
                </fieldset>
            </div>"           