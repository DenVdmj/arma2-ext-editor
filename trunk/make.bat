@echo off
rem ----------------------------------------------------------------------------------------------
rem Relative (by Arma2 folder) path to mod folder
set RelativeModDir=@\$vdmj\ext-editor
rem Addons directories list, may be a mask, as %~dp0/*
set DirList="%~dp0XGUI-ExtendedGUI"
rem Requires binarize
set Binarize=on
rem Requires signing
set Sign=on
rem Set any value in MakeDistrib for make distrib
set MakeDistrib=
rem Mask of added files (separated with ;), set void (as set Mask=) for use native filemask
set Mask=settings;css;*.macro;*.xml
rem Current path
set ThisPath=%~dp0
rem ----------------------------------------------------------------------------------------------

call "make-pbos.bat"