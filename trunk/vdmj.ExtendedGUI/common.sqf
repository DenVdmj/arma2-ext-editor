// SQF
//
// common macros
// Copyright (c) 2009-2010 Denis Usenko (DenVdmj)
// MIT-style license
//


#define __vdmj_prefix vdmj

#define __vdmj_var_prefix __vdmj_prefix##_var_
#define __vdmj_func_prefix __vdmj_prefix##_func_

#define __quoted(str) #str
#define __uiSet(name, value) uiNamespace setVariable [__quoted(/__vdmj_prefix/name), value]
#define __uiGet(name) (uiNamespace getVariable __quoted(/__vdmj_prefix/name))

#define var(varname) __vdmj_var_prefix##varname
#define func(funcname) __vdmj_func_prefix##funcname
#define invoke(funcname) call func(funcname)

//
//
//

#define preprocessFile preprocessFileLineNumbers
#define currentLangAbbr (localize "STR:VDMJ:CURRENT_LANG_ABBR")
#define currentLang (localize "STR:VDMJ:CURRENT_LANG")

//
// Arguments macro
//

#define arg(x)            (_this select (x))
#define argIf(x)          if(count _this > (x))
#define argIfType(x,t)    if(argIf(x)then{typeName arg(x) == (t)}else{false})
#define argSafe(x)        argIf(x)then{arg(x)}
#define argSafeType(x,t)  argIfType(x,t)then{arg(x)}
#define argOr(x,v)        (argSafe(x)else{v})

//
// Array macro
//

#define item(a,v)  ((a)select(((v)min(count(a)-1))max 0))
#define itemr(a,v) (item((a),if((v)<0)then{count(a)+(v)}else{v}))
#define push(a,v)  (a)set[count(a),(v)]
#define pushTo(a)  call{(a)set[count(a),_this]}
#define top(a)     ((a)select((count(a)-1)max 0))
#define pop(a)     (0 call{_this=top(a);a resize((count(a)-1)max 0);_this})
#define selectRnd(a) (a select floor random count a)

//
// Position macro
//

#define x(a) ((a) select 0)
#define y(a) ((a) select 1)
#define z(a) ((a) select 2)
#define w(a) ((a) select 2)
#define h(a) ((a) select 3)

//
// Other macro
//

#define logN(power,number) ((log number)/(log power))
#define log2(number) ((log number)/.3010299956639812)
#define getBit(num,bit) (floor((num / (2^bit)) % 2))
#define checkBit(num,bit) (getBit(num,bit) == 1)
#define xor(a,b) (!(a && b) && (a || b))
#define inc(n) (call { n = n + 1; n })
#define dec(n) (call { n = n - 1; n })
#define _(v)   _##v = _##v
#define strsqf "call" + str

//
// for, map, grep
//

#define forConf(list) call { private "___n"; ___n = list; for "_i" from 0 to count ___n -1 do { private "_x"; _x = ___n select _i; private "___n"; _x call _this; }; }
#define mapArray(list) call { private "___r"; ___r = []; { ___r set [count ___r, call { private "___r"; _x call _this }] } foreach (list); ___r; }
#define grepArray(list) call { private "___r"; ___r = []; { if( call { private "___r"; _x call _this } ) then { push(___r, _x) } } foreach (list); ___r; }
#define map(list) call { private ["___r", "___n"]; ___r = []; ___n = list; for "_i" from 0 to count ___n -1 do { private "_x"; _x = ___n select _i; ___r set [count ___r, call { private ["___r", "___n"]; call _this }] }; ___r; }
#define grep(list) call { private ["___r", "___n"]; ___r = []; ___n = list; for "_i" from 0 to count ___n -1 do { private "_x"; _x = ___n select _i; if( call { private ["___r", "___n"]; _x call _this } ) then { push(___r, _x) } }; ___r; }

//
// Type of expression
//

#define isCode(v) (typeName(v) == "CODE")
#define isNum(v)  (typeName(v) == "SCALAR")
#define isHNDL(v) (typeName(v) == "SCRIPT")
#define isSide(v) (typeName(v) == "SIDE")
#define isSTML(v) (typeName(v) == "TEXT")

#define isArr(v)  (typeName(v) == "ARRAY")
#define isBool(v) (typeName(v) == "BOOL")
#define isConf(v) (typeName(v) == "CONFIG")
#define isCtrl(v) (typeName(v) == "CONTROL")
#define isDspl(v) (typeName(v) == "DISPLAY")
#define isGrp(v)  (typeName(v) == "GROUP")
#define isObj(v)  (typeName(v) == "OBJECT")
#define isStr(v)  (typeName(v) == "STRING")


#define __ManPosLyingBinoc  2
#define __ManPosStandBinoc 14
#define __ManPosDead        0
#define __ManPosLyingRfl    4
#define __ManPosKneelBinoc 13
#define __ManPosLyingHnd    5
#define __ManPosKneelRfl    6
#define __ManPosStandRfl    8
#define __ManPosStand      10
#define __ManPosSwimming   11
#define __ManPosWeapon      1
#define __ManPosKneelHnd    7
#define __ManPosStandHnd    9
#define __ManPosLyingCivil  3
#define __ManPosStandCivil 12

#define __WeaponNoSlot            0
#define __WeaponSlotPrimary       1
#define __WeaponSlotHandGun       2
#define __WeaponSlotSecondary     4
#define __WeaponSlotMashinegun    5
#define __WeaponSlotHandGunMag   16
#define __WeaponSlotHandGunMag2  32
#define __WeaponSlotHandGunMag3  48
#define __WeaponSlotHandGunMag4  64
#define __WeaponSlotHandGunMag5  80
#define __WeaponSlotHandGunMag6  96
#define __WeaponSlotHandGunMag7 112
#define __WeaponSlotHandGunMag8 128
#define __WeaponSlotMag         256
#define __WeaponSlotMag2        512
#define __WeaponSlotMag3        768
#define __WeaponSlotMag4       1024
#define __WeaponSlotGoggle     4096
#define __WeaponHardMounted   65536
#define __WeaponSlotItem     131072

#define __TEast        0
#define __TWest        1
#define __TGuerrila    2
#define __TCivilian    3
#define __TSideUnknown 4
#define __TEnemy       5
#define __TFriendly    6
#define __TLogic       7
#define __private      0
#define __protected    1
#define __public       2

#define __prflrInit _profilerOutput_ = [];
#define __prflrStart _profilerStartTime_ = diag_ticktime;
#define __prflrEnd(text) _profilerOutput_ set [count _profilerOutput_, text + ": " + str (diag_ticktime - _profilerStartTime_)];
#define __prflrOut call { private ["_s1", "_s2", "_n"]; _n = toString [0x0D, 0x0A]; _s1 = ""; _s2 = ""; { _s1 = _s1 + _x + "\n"; _s2 = _s2 + _x + _n } foreach _profilerOutput_; hint _s1; copyToClipboard _s2; _profilerOutput_ };

