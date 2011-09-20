
if (_dsplName == "RscDisplayArcadeUnit") then {
    _ctrlVehicleListBox = _dspl displayCtrl 103;
    _ctrlVehicleListBox ctrlSetEventHandler ["LBSelChanged", __codeToString {
        _self = arg(0);
        _curSel = arg(1);
        _ctrlText = ctrlParent _self displayCtrl 1122; //101; //122;
        _class = _self lbData _curSel;
        _cfgClass = configFile >> "CfgVehicles" >> _class;
        _weapons = getArray (_cfgClass >> "weapons") - ["Throw", "Put"];
        _magazines = getArray (_cfgClass >> "magazines");
        _strWeapons = "";
        _getComma = { _getComma = {", "}; "" };
        {
            _strWeapons = _strWeapons + (call _getComma) + _x;
        } foreach _weapons;
        _strMagazines = "";
        _getComma = { _getComma = {", "}; "" };
        {
            _strMagazines = _strMagazines + (call _getComma) + (_x select 0) + " x " + (str (_x select 1))
        } foreach (_magazines call __uiGet(list2Set));

        _ctrlText ctrlSetText (
            "" + _class + (
                (if (count _weapons > 0) then { "; W: " + _strWeapons } else { "" }) +
                (if (count _magazines > 0) then { "; M: " + _strMagazines } else { "" })
            )
        );

    }];
};
