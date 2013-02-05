// call compile preprocessFileLineNumbers "XGUI-ExtendedGUI\isPosOnBuilding.sqf"
#define __project_name XGUI/XGUI.v0.1
#include "\XGUI-ExtendedGUI\css\css"

private [
    "_objectsList", "_onDblClickWorldPosition",
    "_position", "_positionX", "_positionY",
    "_bb", "_bbMin", "_bbMax", "_isOnPerimeter"
];

_onDblClickWorldPosition = __uiGet(onDblClickWorldPosition);
_objectsList = nearestObjects [_onDblClickWorldPosition, ["static"], 20];

{
    _position = _x worldToModel _onDblClickWorldPosition;
    _positionX = x(_position);
    _positionY = y(_position);
    _bb = boundingBox _x;
    _bbMin = _bb select 0;
    _bbMax = _bb select 1;
    _isOnPerimeter = call {
        if !(x(_bbMin) < _positionX) exitwith {false};
        if !(y(_bbMin) < _positionY) exitwith {false};
        if !(x(_bbMax) > _positionX) exitwith {false};
        if !(y(_bbMax) > _positionY) exitwith {false};
        true
    };
    if (_isOnPerimeter) exitwith { _x };
    objNull;
} foreach _objectsList;
