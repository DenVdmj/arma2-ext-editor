
if (_dsplName == "RscDisplayArcadeMap") then {

    private ["_ehKeyDown", "_ehMouseButtonDblClick", "_ehDraw", "_ehMouseMoving"];

    _disableMapHint __uiSet(displayArcadeMap.disableMapHint);
    false __uiSet(displayArcadeMap.IDShowModeOn);
    diag_tickTime __uiSet(prevNearestObjects.time);
    [0,0,0] __uiSet(prevNearestObjects.mouseWorldPosition);
    [objNull] __uiSet(prevNearestObjects.staticObjects);

    [0,0,0] __uiSet(onDblClickMouseMapPosition);
    [0,0,0] __uiSet(onDblClickWorldPosition);

    _ehKeyDown = {
        if ((arg(1) == DIK_C || arg(1) == DIK_INSERT) && arg(3)) then {
            copyToClipboard str __uiGet(mouseWorldPosition);
        };
    };

    _ehMouseButtonDblClick = {
        _self = arg(0);
        _mouseMapPosition = [arg(2), arg(3)];
        _mouseWorldPosition = _self ctrlMapScreenToWorld _mouseMapPosition;
        //diag_log parseText format [">>> _mouseMapPosition: %1", _mouseMapPosition];
        //diag_log parseText format [">>> _mouseWorldPosition: %1", _mouseWorldPosition];
        _mouseMapPosition __uiSet(onDblClickMouseMapPosition);
        _mouseWorldPosition __uiSet(onDblClickWorldPosition);
    };

    _ehDraw = {

        _self = arg(0);

        if (__uiGet(pressedKey) == DIK_F) then {

            _mouseMapPosition = __uiGet(mouseMapPosition);

            _startPos = __uiGet(onKeyDownMouseWorldPosition);
            _endPos = __uiGet(mouseWorldPosition);

            _strXML = parseText format [
                "<t size='1' shadow='false' color='#FFFFFF' font='Zeppelin32' align='center'>from %1 to %2 = %3</t>",
                _startPos, _endPos, _startPos distance _endPos
            ];

            _strLen = count toArray str _strXML;

            _ctrlHintX = x(_mouseMapPosition) + .005;
            _ctrlHintY = y(_mouseMapPosition) + .0054;
            _ctrlHintW = _strLen * .013;
            _ctrlHintH = .041;

            if (_ctrlHintX + _ctrlHintW > safeZoneX + safeZoneW) then {
                _ctrlHintX = safeZoneX + safeZoneW - .002 - _ctrlHintW
            };

            if (_ctrlHintY + _ctrlHintH > safeZoneY + safeZoneH) then {
                _ctrlHintY = safeZoneY + safeZoneH - .002 - _ctrlHintH
            };

            _ctrlHint = ctrlParent _self displayCtrl 98232;
            _ctrlHint ctrlShow true;
            _ctrlHint ctrlSetPosition [_ctrlHintX, _ctrlHintY, _ctrlHintW, _ctrlHintH];
            _ctrlHint ctrlSetBackgroundColor [.45,0,0,.95];
            //_ctrlHint ctrlSetBackgroundColor [1,1,1,.4];
            _ctrlHint ctrlCommit 0;
            _ctrlHint ctrlSetStructuredText _strXML;

            _self drawLine [_startPos, _endPos, [.5,0,0,1]];
        };
    };

    _ehMouseMoving = {

        _self = arg(0);
        _mouseMapPosition = [arg(1), arg(2)];
        _mouseWorldPosition = _self ctrlMapScreenToWorld _mouseMapPosition;

        _mouseMapPosition __uiSet(mouseMapPosition);
        _mouseWorldPosition __uiSet(mouseWorldPosition);

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
                    __push(_list, _x);
                };
            } foreach nearestObjects [_mouseWorldPosition, [], __nearestObjectsRadius];

            diag_tickTime __uiSet(prevNearestObjects.time);
            _mouseWorldPosition __uiSet(prevNearestObjects.mouseWorldPosition);
            _list __uiSet(prevNearestObjects.staticObjects);
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
            _strWidth = (_strLen * .0137) + (7 * .0137);

            _ctrlHint ctrlShow true;
            _ctrlHint ctrlSetPosition [x(_mouseMapPosition) + .01, y(_mouseMapPosition) + .01, _strWidth, .082];
            _ctrlHint ctrlSetBackgroundColor [.45,0,0,.8];
            _ctrlHint ctrlCommit 0;
            _ctrlHint ctrlSetStructuredText parseText format [
                '<t size="1" font="Zeppelin32" shadow="true" color="#FFFFFF" align="left">ID: %1<br />Model: %2<br />%3</t>',
                _objectID,
                _objectModel
            ];
            _object setVehicleVarName _vehicleVarName;
        } else {
            _ctrlHint ctrlShow false;
        };
    };

    _ehKeyDown __uiSet(displayArcadeMap.ehKeyDown);
    _ehMouseButtonDblClick __uiSet(displayArcadeMap.ehMouseButtonDblClick);
    _ehMouseMoving __uiSet(displayArcadeMap.ehMouseMoving);
    _ehDraw __uiSet(displayArcadeMap.ehDraw);

    //#define mapIDC 51

    _ctrlBISMap = _dspl displayCtrl 51;
    _ctrlMyMap = _dspl displayCtrl 1000;

    _ctrlMap = if (_enableExperimentalMap && !isNull _ctrlMyMap) then {
        _ctrlBISMap ctrlEnable false;
        _ctrlBISMap ctrlShow false;
        _ctrlMyMap ctrlShow true;
        _ctrlMyMap ctrlSetPosition [SafeZoneX, SafeZoneY, SafeZoneW, SafeZoneH];
        _ctrlMyMap ctrlCommit 0;
        _ctrlMyMap;
    } else {
        _ctrlMyMap ctrlEnable false;
        _ctrlMyMap ctrlShow false;
        _ctrlBISMap;
    };

    _dspl displayCtrl 111 buttonSetAction '(!__uiGet(displayArcadeMap.IDShowModeOn)) __uiSet(displayArcadeMap.IDShowModeOn)';
    _dspl displayCtrl 111 ctrlAddEventHandler ['ToolBoxSelChanged', ''];
    _dspl displayAddEventHandler ['KeyDown', 'call __uiGet(displayArcadeMap.ehKeyDown)'];
    _ctrlMap ctrlAddEventHandler ['MouseButtonDblClick', 'call __uiGet(displayArcadeMap.ehMouseButtonDblClick)'];
    _ctrlMap ctrlAddEventHandler ['Draw', 'call __uiGet(displayArcadeMap.ehDraw)'];
    _ctrlMap ctrlAddEventHandler ['MouseMoving', 'call __uiGet(displayArcadeMap.ehMouseMoving)'];

};
