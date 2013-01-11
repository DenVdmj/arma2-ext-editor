// call compile preprocessFileLineNumbers "vdmj.ExtendedGUI\init.sqf"
#define __project_name vdmj/XGUI.v0.1
#include "\vdmj.ExtendedGUI\css\css"
#include "\vdmj.ExtendedGUI\css\dik-codes.macro"

#define __nearestObjectsTimeout 1
#define __nearestObjectsRadius 30
#define __nearestObjectsDistanceStep 10
#define __minimalHintTriggerDistance .02
#define __maximalHintTriggerMapScale .19

private [
    "_protectedVariables",
    // Имена переменных, которые можно портить внешним скриптам (файлу настроек, другим юзерским файлам)
    // Эти переменные не защищаем, оставляем возможность их изменения в подключаемом файле настроек
    "_disableAutoFocus",
    "_disableMapHint",
    "_enableExperimentalMap"
];

// Имена защищаемых переменных
_protectedVariables = [
    "_protectedVariables",
    "_dspl",
    "_dsplName",
    "_dsplConf",
    "_dsplControls",
    "_configByControlKeys",
    "_configByControlValues",
    "_ctrlByTypeListKeys",
    "_ctrlByTypeListValues",
    "_allControlList",
    "_getCtrlByType",
    "_getConfigByControl",
    "_funcList2Set",
    "_comboboxList",
    "_sliderList",
    "_textInputList",
    "_textInputMouseZEH",
    "_target",
    "_ctrlValueSide"
];

// имена защищаемых переменных
private _protectedVariables;

// прочитать настройки
call {
    // отдельный scope, защищаем переменные скрипта
    private _protectedVariables;
    // значения по умолачнию
    _disableAutoFocus = false;
    _disableMapHint = false;
    _enableExperimentalMap = false;
    // подключаем настройки из папки "%UserProfile%\<Personal>\<ArmaUserPrifile>\scripts\vdmj.ExtendedGUI\"
    call compile preprocessFile "vdmj.ExtendedGUI\settings";
};

_dspl = arg(0);
_dsplName = arg(1);
_dsplConf = configFile >> _dsplName;
_dsplControls = _dsplConf >> "controls";

// table
_configByControlKeys = [];
_configByControlValues = [];

// table
_ctrlByTypeListKeys = [];
_ctrlByTypeListValues = [];

_allControlList = [];

call {
    // init tables
    private ["_class", "_idc", "_type", "_control", "_key"];

    for "_i" from 0 to count _dsplControls -1 do {

        _class = _dsplControls select _i;

        if (isClass _class) then {

            _idc = getNumber(_class >> "idc");
            _type = getNumber(_class >> "type");
            _control = _dspl displayCtrl _idc;

            __push(_configByControlKeys, _control);
            __push(_configByControlValues, _class);

            _key = _ctrlByTypeListKeys find _type;

            if (_key < 0) then {
                _key = count _ctrlByTypeListKeys;
                __push(_ctrlByTypeListKeys, _type);
                __push(_ctrlByTypeListValues, []);
            };

            __push(_ctrlByTypeListValues select _key, _control);
            __push(_allControlList, _control);
        };
    };
};

// возвращает все контролы с указаннымым типом
_getCtrlByType = {
    (_ctrlByTypeListKeys find _this) call {
        if (_this >= 0) then {
            _ctrlByTypeListValues select _this
        };
    };
};

_getConfigByControl = {
    (__uiGet(configByControlKeys) find _this) call {
        if (_this >= 0) then {
            __uiGet(configByControlValues) select _this
        };
    };
};

_funcList2Set = {
    private ["_col", "_rem"];
    _col = [];
    while { count _this != 0 } do {
        _rem = _this - [_this select 0];
        _col set [count _col, [_this select 0, count _this - count _rem]];
        _this = _rem;
    };
    _col
};

_parseModelName = {
    _this = toArray _this;
    _i = _this find 32;
    if (_i < 0) exitwith { "" };
    _this set [_i, 62];
    str parseText ("< " + toString _this);
};

_parseObjectID = {
    private "_letters";
    _letters = toArray _this;
    if (35 in _letters) then {
        for "_i" from 0 to count _letters - 1 do {
            if (_letters select _i == 35 ) exitwith {
                _letters set [_i, 62];
                parseNumber str parseText ("< " + toString _letters);
            };
        };
    } else {
        parseNumber _this
    };
};

// Set global variables
// access function
_dsplControls           __uiSet(dsplControls);
_configByControlKeys    __uiSet(configByControlKeys);
_configByControlValues  __uiSet(configByControlValues);
_getConfigByControl     __uiSet(getConfigByControl);
_parseModelName         __uiSet(parseModelName);
_parseObjectID          __uiSet(parseObjectID);
_funcList2Set           __uiSet(list2Set);

// user input state
controlNull __uiSet(focused);
0 __uiSet(pressedKey);
false __uiSet(pressedShift);
false __uiSet(pressedCtrl);
false __uiSet(pressedAlt);
[0,0,0] __uiSet(mouseMapPosition);
[0,0,0] __uiSet(mouseWorldPosition);
[0,0,0] __uiSet(onKeyDownMouseMapPosition);
[0,0,0] __uiSet(onKeyDownMouseWorldPosition);

/*
with uiNamespace do {
    // Set global variables
    // access function
    p(dsplControls) = _dsplControls;
    p(configByControlKeys) = _configByControlKeys;
    p(configByControlValues) = _configByControlValues;
    p(getConfigByControl) = _getConfigByControl;
    p(parseModelName) = _parseModelName;
    p(parseObjectID) = _parseObjectID;
    p(list2Set) = _funcList2Set;

    // user input state
    p(focused) = controlNull;
    p(pressedKey) = 0;
    p(pressedShift) = false;
    p(pressedCtrl) = false;
    p(pressedAlt) = false;
    p(mouseMapPosition) = [0,0,0];
    p(mouseWorldPosition) = [0,0,0];
    p(onKeyDownMouseMapPosition) = [0,0,0];
    p(onKeyDownMouseWorldPosition) = [0,0,0];
};
*/

_comboboxList = 4 call _getCtrlByType;
_sliderList = 43 call _getCtrlByType;
_textInputList = 2 call _getCtrlByType;

_dspl displayAddEventHandler ["KeyDown", __sqf2str {
    if (__uiGet(pressedKey) <= 1) then {
        __uiGet(mouseMapPosition) __uiSet(onKeyDownMouseMapPosition);
        __uiGet(mouseWorldPosition) __uiSet(onKeyDownMouseWorldPosition);
    };
    arg(1) __uiSet(pressedKey);
    arg(2) __uiSet(pressedShift);
    arg(3) __uiSet(pressedCtrl);
    arg(4) __uiSet(pressedAlt);
    false;
}];

_dspl displayAddEventHandler ["KeyUp", __sqf2str {
    _code = arg(1);
    1 __uiSet(pressedKey);
    _resetShift = { false __uiSet(pressedShift) };
    _resetCtrl = { false __uiSet(pressedCtrl) };
    _resetAlt = { false __uiSet(pressedAlt) };
    switch (_code) do {
        case  42: _resetShift;
        case  54: _resetShift;
        case  29: _resetCtrl;
        case 157: _resetCtrl;
        case  56: _resetAlt;
        case 184: _resetAlt;
    };
    false;
}];

// Авто-передача фокуса текстовым полям, комбобоксам и слайдерам
if (!_disableAutoFocus) then {
    {
        {
            _x ctrlAddEventHandler ["MouseHolding", __sqf2str {
                ctrlSetFocus arg(0)
            }];
        } foreach _x;
    } foreach [_textInputList, _comboboxList, _sliderList];
};

// Прокрутка комбобоксов колесом мыши
{
    //_x ctrlEnable true;
    _x ctrlAddEventHandler ["MouseZChanged", __sqf2str {
        _self = arg(0);
        _mouseZ = arg(1);
        _k = if (_mouseZ > 0) then { -1 } else { 1 };
        _index = ((0 max (_k + lbCurSel _self)) min (lbSize _self));
        _self lbSetCurSel _index;
    }];
} foreach _comboboxList;

// Управление слайдерами колесом мыши
{
    _x ctrlAddEventHandler ["MouseZChanged", __sqf2str {
        _self = arg(0);
        _mouseZ = arg(1);
        _k = if (_mouseZ > 0) then { -.1 } else { .1 };
        _sliderRange = sliderRange _self;
        _self sliderSetPosition ((0 max (
            (
                (
                    (_sliderRange select 1) -
                    (_sliderRange select 0)
                ) * _k
            ) + sliderPosition _self
        )) min 1);
    }];
} foreach _sliderList;

_textInputMouseZEH = __sqf2str {

    _ctrl = arg(0);

    _confMouseZ = (_ctrl call __uiGet(getConfigByControl)) >> "MouseZ";

    if (!isClass _confMouseZ ) exitwith {};

    _href = getText(_confMouseZ >> "reflectEvent");

    if (_href != "") then {
        _conf = __uiGet(dsplControls) >> _href;
        _ctrl = ctrlParent _ctrl displayCtrl (getNumber(_conf >> "idc"));
        _confMouseZ = _conf >> "MouseZ";
    };

    _mouseZ = arg(1);

    _acc = getArray(_confMouseZ >> "acceleration");
    _period = getNumber(_confMouseZ >> "period");
    _unsigned = getNumber(_confMouseZ >> "unsigned") == 1;

    _k = if (_mouseZ > 0) then { -1 } else { 1 };

    if (count _acc == 4) then {
        _k = _k * (_acc select 0);
        if (__uiGet(pressedShift)) then { _k = _k * (_acc select 1); };
        if (__uiGet(pressedCtrl)) then { _k = _k * (_acc select 2); };
        if (__uiGet(pressedAlt)) then { _k = _k * (_acc select 3); };
    };

    _value = _k + parseNumber ctrlText _ctrl;

    if (_period != 0) then {
        _value = ((_period + _value) % _period);
    };

    if (_unsigned) then {
        _value = 0 max _value;
    };

    _ctrl ctrlSetText str _value;
};

{
    _x ctrlAddEventHandler ["MouseZChanged", _textInputMouseZEH];
} foreach _textInputList;

{
    _target = _dsplControls >> getText((_x call _getConfigByControl) >> "MouseZ" >> "reflectEvent");
    if (isClass _target) then {
        //(_dspl displayCtrl getNumber(_target >> "idc")) ctrlAddEventHandler ["MouseZChanged", _textInputMouseZEH];
        _x ctrlAddEventHandler ["MouseZChanged", _textInputMouseZEH];
    };
} foreach _allControlList;

#include "init.RscDisplayArcadeUnit.sqf"
#include "init.RscDisplayArcadeMap.sqf"
#include "init.RscDisplayArcadeModules.sqf"
#include "init.RscDisplayArcadeSensor.sqf"
