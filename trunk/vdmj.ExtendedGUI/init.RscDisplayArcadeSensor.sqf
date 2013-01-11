//102 103
//105

if (_dsplName == "RscDisplayArcadeSensor") then {

    diag_log "RscDisplayArcadeSensor";

    "50" __uiSet(displayArcadeSensor.axisX);
    "50" __uiSet(displayArcadeSensor.axisY);

    def(_ehLBSelChanged) = {
        diag_log _this;
        _self = arg(0);
        _cursel = arg(1);
        if (_cursel >= 7 && _cursel <= 16) then {
            ctrlParent _self displayCtrl 102 ctrlSetText "0";
            ctrlParent _self displayCtrl 103 ctrlSetText "0";
        } else {
            ctrlParent _self displayCtrl 102 ctrlSetText __uiGet(displayArcadeSensor.axisX);
            ctrlParent _self displayCtrl 103 ctrlSetText __uiGet(displayArcadeSensor.axisY);
        };
    };

    _ehLBSelChanged __uiSet(displayArcadeSensor.ehLBSelChanged);

    //(parseNumber ctrlText arg(0)) __uiSet(displayArcadeSensor.axisX)
    //(parseNumber ctrlText arg(0)) __uiSet(displayArcadeSensor.axisY)

    (_dspl displayCtrl 102) ctrlAddEventHandler ['KeyDown', '(ctrlText arg(0)) __uiSet(displayArcadeSensor.axisX)'];
    (_dspl displayCtrl 103) ctrlAddEventHandler ['KeyDown', '(ctrlText arg(0)) __uiSet(displayArcadeSensor.axisY)'];

    (_dspl displayCtrl 105) ctrlAddEventHandler ['LBSelChanged', 'call __uiGet(displayArcadeSensor.ehLBSelChanged)'];

};