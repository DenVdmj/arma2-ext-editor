
if (_dsplName == "RscDisplayArcadeUnit") then {

    def(_setInfoText) = {
        _self = arg(0);
        _curSel = arg(1);
        _dspl = ctrlParent _self;
        _class = _self lbData _curSel;
        _text = _self lbText _curSel;
        _name = ctrlText (_dspl displayCtrl 118);
        if (_name != "") then { _name = _name + " - " };
        _ctrlTitle = _dspl displayCtrl 101;
        _titleText = toArray ((ctrlText _ctrlTitle) + ":");
        _index = _titleText find 58;
        if (_index >= 0) then {
            _titleText resize _index;
            _ctrlTitle ctrlSetText ((toString _titleText) + ": " + _name + _text + " - " + _class);
        };
        _ctrlText = _dspl displayCtrl 1122; //101; //122;
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
        _dspl displayCtrl 1108 ctrlSetText localize (
            if (getText (_cfgClass >> "simulation") == "soldier") then {
                "STR:DISP:ARCUNIT:HEALTH"
            } else {
                "STR:DISP:ARCUNIT:ARMOR"
            }
        );

    };

    def(_ctrlVehicleListBox) = _dspl displayCtrl 103;
    [_ctrlVehicleListBox, lbCurSel _ctrlVehicleListBox] call _setInfoText;
    _ctrlVehicleListBox ctrlSetEventHandler ["LBSelChanged", __sqf2str _setInfoText];

};
