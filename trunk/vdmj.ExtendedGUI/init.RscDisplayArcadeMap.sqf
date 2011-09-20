
if (_dsplName == "RscDisplayArcadeMap") then {

    private ["_ehKeyDown", "_ehDraw", "_ehMouseMoving"];

    __uiSet(displayArcadeMap.disableMapHint, _disableMapHint);
    __uiSet(displayArcadeMap.IDShowModeOn, false);
    __uiSet(prevNearestObjects.time, diag_tickTime);
    __uiSet(prevNearestObjects.mouseWorldPosition, getPosATL objNull);
    __uiSet(prevNearestObjects.staticObjects, [objNull]);
    

    _ehKeyDown = {
        if ((arg(1) == DIK_C || arg(1) == DIK_INSERT) && arg(3)) then {
            copyToClipboard str __uiGet(mouseWorldPosition);
        };
    };

    _ehDraw = {

        _self = arg(0);

        if (__uiGet(pressedKey) == DIK_F) then {

            _mouseMapPosition = __uiGet(mouseMapPosition);

            _startPos = __uiGet(onKeyDownMouseWorldPosition);
            _endPos = __uiGet(mouseWorldPosition);

            _strXML = parseText format [
                "<t size='.9' shadow='false' color='#FFFFFF' align='center'>from %1 to %2 = %3</t>",
                _startPos, _endPos, _startPos distance _endPos
            ];

            _strLen = count toArray str _strXML;

            _ctrlHintX = x(_mouseMapPosition) + .005;
            _ctrlHintY = y(_mouseMapPosition) + .0054;
            _ctrlHintW = _strLen * .0105;
            _ctrlHintH = .04;

            if (_ctrlHintX + _ctrlHintW > safeZoneX + safeZoneW) then {
                _ctrlHintX = safeZoneX + safeZoneW - .002 - _ctrlHintW
            };

            if (_ctrlHintY + _ctrlHintH > safeZoneY + safeZoneH) then {
                _ctrlHintY = safeZoneY + safeZoneH - .002 - _ctrlHintH
            };

            _ctrlHint = ctrlParent _self displayCtrl 98232;
            _ctrlHint ctrlShow true;
            _ctrlHint ctrlSetPosition [_ctrlHintX, _ctrlHintY, _ctrlHintW, _ctrlHintH];
            _ctrlHint ctrlSetBackgroundColor [.5,0,0,.7];
            _ctrlHint ctrlCommit 0;
            _ctrlHint ctrlSetStructuredText _strXML;

            _self drawLine [_startPos, _endPos, [.5,0,0,1]];
        };
    };

    _ehMouseMoving = {

        _self = arg(0);
        _mouseMapPosition = [arg(1), arg(2)];
        _mouseWorldPosition = _self ctrlMapScreenToWorld _mouseMapPosition;

        __uiSet(mouseMapPosition, _mouseMapPosition);
        __uiSet(mouseWorldPosition, _mouseWorldPosition);

        _dspl = ctrlParent _self;

        _ctrlHint = _dspl displayCtrl 98232;
        _ctrlHintBackground = _dspl displayCtrl 98233;

        if (
            __uiGet(displayArcadeMap.disableMapHint) ||
            !__uiGet(displayArcadeMap.IDShowModeOn) ||
            ctrlMapScale _self > __maximalHintTriggerMapScale
        ) exitwith {
            _ctrlHint ctrlShow false;
        };

        _staticObjects = call {
            if (__uiGet(prevNearestObjects.mouseWorldPosition) distance _mouseWorldPosition < __nearestObjectsDistanceStep ) exitwith {
                __uiGet(prevNearestObjects.staticObjects)
            };
            _list = [];
            {
                if (_x isKindOf "static" || _x isKindOf "StreetLamp" || typeof _x == "") then {
                    push(_list, _x);
                };
            } foreach nearestObjects [_mouseWorldPosition, [], __nearestObjectsRadius];

            __uiSet(prevNearestObjects.time, diag_tickTime);
            __uiSet(prevNearestObjects.mouseWorldPosition, _mouseWorldPosition);
            __uiSet(prevNearestObjects.staticObjects, _list);
            _list;
        };

        _object = objNull;
        _minDist = __minimalHintTriggerDistance * 10000;
        {
            _dist = (_self ctrlMapWorldToScreen getPosATL _x) distance _mouseMapPosition;
            if (_dist < _minDist) then {
                _minDist = _dist;
                _object = _x;
            };
        } foreach _staticObjects;

        if (((_self ctrlMapWorldToScreen getPosATL _object) distance _mouseMapPosition) < __minimalHintTriggerDistance) then {
            _vehicleVarName = vehicleVarName _object;
            _object setVehicleVarName "";

            _objectID = str _object call __uiGet(parseObjectID);
            _objectModel = str _object call __uiGet(parseModelName);

            _strLen = count toArray _objectModel;
            _strWidth = (_strLen * .0105) + (6 * .01);

            _ctrlHint ctrlShow true;
            _ctrlHint ctrlSetPosition [x(_mouseMapPosition) + .01, y(_mouseMapPosition) + .01, _strWidth, .063];
            _ctrlHint ctrlSetBackgroundColor [0,.2,0,.8];
            _ctrlHint ctrlCommit 0;
            _ctrlHint ctrlSetStructuredText parseText format [
                "<t size='.7' shadow='false' color='#FFFFFF' align='left'>ID: %1<br />Model: %2<br />%3</t>",
                _objectID,
                _objectModel
            ];
            _object setVehicleVarName _vehicleVarName;
        } else {
            _ctrlHint ctrlShow false;
        };
    };

    __uiSet(displayArcadeMap.ehKeyDown, _ehKeyDown);
    __uiSet(displayArcadeMap.ehMouseMoving, _ehMouseMoving);
    __uiSet(displayArcadeMap.ehDraw, _ehDraw);

    //#define mapIDC 51

    _ctrlBISMap = _dspl displayCtrl 51;
    _ctrlMyMap = _dspl displayCtrl 1000;

    _ctrlMap = if true then {
        _ctrlMyMap ctrlEnable false;
        _ctrlMyMap ctrlShow false;
        _ctrlBISMap;
    } else {
        _ctrlBISMap ctrlEnable false;
        _ctrlBISMap ctrlShow false;
        _ctrlMyMap ctrlShow true;
        _ctrlMyMap ctrlSetPosition [SafeZoneX, SafeZoneY, SafeZoneW, SafeZoneH];
        _ctrlMyMap ctrlCommit 0;
        _ctrlMyMap;
    };

    _dspl displayAddEventHandler ['KeyDown', 'call __uiGet(displayArcadeMap.ehKeyDown)'];
    _ctrlMap ctrlAddEventHandler ['Draw', 'call __uiGet(displayArcadeMap.ehDraw)'];
    _ctrlMap ctrlAddEventHandler ['MouseMoving', 'call __uiGet(displayArcadeMap.ehMouseMoving)'];
    _dspl displayCtrl 111 buttonSetAction '__uiSet(displayArcadeMap.IDShowModeOn, !__uiGet(displayArcadeMap.IDShowModeOn))';
    _dspl displayCtrl 111 ctrlAddEventHandler ['ToolBoxSelChanged', '']

};

