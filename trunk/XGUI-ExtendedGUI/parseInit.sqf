// call compile preprocessFileLineNumbers "XGUI-ExtendedGUI\parseInit.sqf"
// "call{'@!~';{for''from(1)to((_x)select(1))do{(_this)addMagazine((_x)select(0))}}foreach[['15Rnd_W1866_Pellet',3],['15Rnd_W1866_Slug',5]];{(_this)addWeapon(_x)}foreach['ItemKnife','ItemHatchet','ItemMatchbox','ItemFlashlight']};" call compile preprocessFileLineNumbers "XGUI-ExtendedGUI\parseInit.sqf"

_string = toArray _this;
_lastIndex = count _string -1;
_signSize = 0;

_data = [];
_deep = 0;
_totalNum = 0;
_totalArr = 0;

for "_i" from 0 to _lastIndex do {
    _char = _string select _i;
    call {
        if (_totalArr < 2) then {
            if (_char == 91) exitwith {
                _totalArr = _totalArr + 1;
                _currentArray = [];
                for "_j" from _i to _lastIndex do {
                    _char = _string select _j;
                    _currentArray set [count _currentArray, _char];
                    _string set [_j, 0];
                    if (_char == 91) then { _deep = _deep+1 };
                    if (_char == 93) then { _deep = _deep-1 };
                    if (_deep == 0) exitwith {
                        _data set [count _data, toString _currentArray];
                        if (_totalArr == 2) then {
                            if (_j + 2 <= _lastIndex) then {
                                _signSize = _j + 2;
                            };
                        };
                    };
                };
            };
        };
    };
};

_string = _string - [0];
_string resize _signSize;
_sign = toString _string;
_isMatchSign = _sign == "call{'@!~';{for''from(1)to((_x)select(1))do{(_this)addMagazine((_x)select(0))}}foreach;{(_this)addWeapon(_x)}foreach};";
if (_isMatchSign) then {};
[_data, _isMatchSign, _sign];

/* 
call{'@!~';{for''from(*)to((_x)select(1))do{(_this)addMagazine((_x)select(0))}}foreach[['15Rnd_W1866_Pellet',3],['15Rnd_W1866_Slug',5]];{(_this)addWeapon(_x)}foreach['ItemKnife','ItemHatchet','ItemMatchbox','ItemFlashlight']};
*/
