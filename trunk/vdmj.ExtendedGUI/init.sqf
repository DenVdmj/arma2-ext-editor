// call compile preprocessFileLineNumbers "vdmj.ExtendedGUI\init.sqf"

#include "\vdmj.ExtendedGUI\common.sqf"
#include "\vdmj.ExtendedGUI\dik-codes.sqf"

#define __nearestObjectsTimeout 1
#define __nearestObjectsRadius 30
#define __nearestObjectsDistanceStep 10
#define __minimalHintTriggerDistance .02
#define __maximalHintTriggerMapScale .19

#define def(varname) private #varname; varname
#define __codeToString "call" + str

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

            push(_configByControlKeys, _control);
            push(_configByControlValues, _class);

            _key = _ctrlByTypeListKeys find _type;

            if (_key < 0) then {
                _key = count _ctrlByTypeListKeys;
                push(_ctrlByTypeListKeys, _type);
                push(_ctrlByTypeListValues, []);
            };

            push(_ctrlByTypeListValues select _key, _control);
            push(_allControlList, _control);
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
__uiSet(dsplControls, _dsplControls);
__uiSet(configByControlKeys, _configByControlKeys);
__uiSet(configByControlValues, _configByControlValues);
__uiSet(getConfigByControl, _getConfigByControl);
__uiSet(parseModelName, _parseModelName);
__uiSet(parseObjectID, _parseObjectID);
__uiSet(list2Set, _funcList2Set);

// user input state
__uiSet(focused, controlNull);
__uiSet(pressedKey, 0);
__uiSet(pressedShift, false);
__uiSet(pressedCtrl, false);
__uiSet(pressedAlt, false);
__uiSet(mouseMapPosition, getPosATL objNull);
__uiSet(mouseWorldPosition, getPosATL objNull);
__uiSet(onKeyDownMouseMapPosition, getPosATL objNull);
__uiSet(onKeyDownMouseWorldPosition, getPosATL objNull);

_comboboxList = 4 call _getCtrlByType;
_sliderList = 43 call _getCtrlByType;
_textInputList = 2 call _getCtrlByType;

_dspl displayAddEventHandler ["KeyDown", __codeToString {
    if (__uiGet(pressedKey) <= 1) then {
        __uiSet(onKeyDownMouseMapPosition, __uiGet(mouseMapPosition));
        __uiSet(onKeyDownMouseWorldPosition, __uiGet(mouseWorldPosition));
    };
    __uiSet(pressedKey, arg(1));
    __uiSet(pressedShift, arg(2));
    __uiSet(pressedCtrl, arg(3));
    __uiSet(pressedAlt, arg(4));
    false;
}];

_dspl displayAddEventHandler ["KeyUp", __codeToString {
    _code = arg(1);
    __uiSet(pressedKey, 1);
    _resetShift = { __uiSet(pressedShift, false); };
    _resetCtrl = { __uiSet(pressedCtrl, false); };
    _resetAlt = { __uiSet(pressedAlt, false); };
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
            _x ctrlAddEventHandler ["MouseHolding", __codeToString {
                ctrlSetFocus arg(0)
            }];
        } foreach _x;
    } foreach [_textInputList, _comboboxList, _sliderList];
};

// Прокрутка комбобоксов колесом мыши
{
    //_x ctrlEnable true;
    _x ctrlAddEventHandler ["MouseZChanged", __codeToString {
        _self = arg(0);
        _mouseZ = arg(1);
        _k = if (_mouseZ > 0) then { -1 } else { 1 };
        _self lbSetCurSel ((0 max (_k + lbCurSel _self)) min (lbSize _self));
    }];
} foreach _comboboxList;

// Управление слайдерами колесом мыши
{
    _x ctrlAddEventHandler ["MouseZChanged", __codeToString {
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

_textInputMouseZEH = __codeToString {

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

