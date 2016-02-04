
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

        _ctrlValueDescription = _dspl displayCtrl 1122;
        _cfgClass = configFile >> "CfgVehicles" >> _class;
        _weapons = getArray (_cfgClass >> "weapons") - ["Throw", "Put"];
        _magazines = getArray (_cfgClass >> "magazines");
        _strWeapons = "";
        _getCommaSource = { _getComma = {", "}; "" };
        _getComma = _getCommaSource;

        {
            _strWeapons = _strWeapons + (call _getComma) + _x;
        } foreach _weapons;

        _strMagazines = "";
        _getComma = _getCommaSource;

        {
            _strMagazines = _strMagazines + (call _getComma) + (_x select 0) + " x " + (str (_x select 1))
        } foreach (_magazines call __uiGet(list2Set));

        _ctrlValueDescription ctrlSetText (
            "" + _class + (
                (if (count _weapons > 0) then { "; W: " + _strWeapons } else { "" }) +
                (if (count _magazines > 0) then { "; M: " + _strMagazines } else { "" })
            )
        );

        _animEnable = {
            {
                _x ctrlEnable arg(1);
                _x ctrlSetFade ([.8, 0] select arg(1));
                _x ctrlCommit .2;
            } foreach arg(0);
        };

        _ctrlTextHealth = _dspl displayCtrl 1108;
        _ctrlTextFuel   = _dspl displayCtrl 1109;
        _ctrlValueFuel  = _dspl displayCtrl  109;
      //_ctrlTextAmmo   = _dspl displayCtrl 1110;
      //_ctrlValueAmmo  = _dspl displayCtrl  110;

        if (getText (_cfgClass >> "simulation") == "soldier") then {
            _ctrlTextHealth ctrlSetText localize "STR:DISP:ARCUNIT:HEALTH";
            [[_ctrlTextFuel, _ctrlValueFuel/*, _ctrlTextAmmo, _ctrlValueAmmo*/], false] call _animEnable;
        } else {
            _ctrlTextHealth ctrlSetText localize "STR:DISP:ARCUNIT:ARMOR";
            [[_ctrlTextFuel, _ctrlValueFuel/*, _ctrlTextAmmo, _ctrlValueAmmo*/], true] call _animEnable;
        };

    };

    def(_ctrlVehicleListBox) = _dspl displayCtrl 103;
    [_ctrlVehicleListBox, lbCurSel _ctrlVehicleListBox] call _setInfoText;
    _ctrlVehicleListBox ctrlSetEventHandler ["LBSelChanged", __sqf2str _setInfoText];

};
