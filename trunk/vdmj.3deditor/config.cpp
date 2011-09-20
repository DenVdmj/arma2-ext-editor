// ARMA2

class CfgPatches {
    class vdmj_3deditor {
        units[] = {};
        weapons[] = {};
        requiredVersion = 0.1;
        requiredAddons[] = {"CAFonts", "CAUI"};
    };
};

class RscTitle;
class RscEdit;
class RscToolbox;
class RscListBox;
class RscCombo;
class RscText;
class RscFrame;
class RscHTML;
class RscButton;
class RscPicture;
class RscStandardDisplay;
class RscDisplayEmpty;
class RscMapControl;
class RscMap {
    class controls;
};
class RscShortcutButton;
class RscIGUIListBox;
class RscIGText;
class RscIGProgress;
class RscPictureKeepAspect;
class CA_Back;
class CA_Mainback;
class CA_Title;
class CA_Title_Back;
class CA_Black_Back;
class RscStructuredText {
    class Attributes;
};

class RscControlsGroup {
    style = 0x10;
    class ScrollBar {
        color[] = {1, 1, 1, 0.6};
        colorActive[] = {1, 1, 1, 1};
        colorDisabled[] = {1, 1, 1, 0.3};
        thumb = "\ca\ui\data\igui_scrollbar_thumb_ca.paa";
        arrowFull = "\ca\ui\data\igui_arrow_top_active_ca.paa";
        arrowEmpty = "\ca\ui\data\igui_arrow_top_ca.paa";
        border = "\ca\ui\data\igui_border_scroll_ca.paa";
    };
};

class RscDisplayArcadeMap {
    class controlsBackground {
        class vdmj_3deditor_map : RscMapControl {
            idc = 1000;
            x = SafeZoneX-1;
            y = SafeZoneY-1;
            w = 0;
            h = 0;
            type = 101;
            style = 48;
            colorBackground[] = {1, 1, 1, 1};
            colorOutside[] = {0, 0, 0, 1};
            colorText[] = {0, 0, 0, 1};
            font = "TahomaB";
            sizeEx = 0.04;
            moveOnEdges = 1;

            // что-то типа коэффициента к масштабу, начиная с которого начинает отображаться та или иная графическая информация
            ptsPerSquareSea = 8; // море
            ptsPerSquareTxt = 10; // текстуры
            ptsPerSquareCLn = 1000;
            ptsPerSquareExp = 1000;
            ptsPerSquareCost = 1000;
            ptsPerSquareFor = 1000; // леса (векторные)
            ptsPerSquareForEdge = 1000; // граница леса (векторные)
            ptsPerSquareRoad = 1000; // дороги (векторные)
            ptsPerSquareObj = 15;

            showCountourInterval = false;

            maxSatelliteAlpha = 1;
            alphaFadeStartScale = 1;
            alphaFadeEndScale = 2;

            fontLabel = "Zeppelin32"; sizeExLabel = 0.034;
            fontGrid = "Zeppelin32";  sizeExGrid = 0.03;
            fontUnits = "Zeppelin32"; sizeExUnits = 0.034;
            fontNames = "Zeppelin32"; sizeExNames = 0.056;
            fontInfo = "Zeppelin32";  sizeExInfo = 0.034;
            fontLevel = "Zeppelin32"; sizeExLevel = 0.024;

            text = "\ca\ui\data\map_background2_co.paa";

            colorSea[] = {0.1, 0.24, 0.35, 0.8};
            colorForest[] = {0.45, 0.64, 0.33, 0.5};
            colorRocks[] = {0, 0, 0, 0.3};
            colorCountlines[] = {0.85, 0.8, 0.65, .1};
            colorMainCountlines[] = {0.45, 0.4, 0.25, .1};
            colorCountlinesWater[] = {0.25, 0.4, 0.5, 0.1};
            colorMainCountlinesWater[] = {0.25, 0.4, 0.5, 0};
            colorForestBorder[] = {0, 0, 0, 0};
            colorRocksBorder[] = {0, 0, 0, 0};
            colorPowerLines[] = {0.1, 0.1, 0.1, .1};
            colorRailWay[] = {0.8, 0.2, 0, .1};
            colorNames[] = {0.1, 0.1, 0.1, 0.5};
            colorInactive[] = {1, 1, 1, 0.5};
            colorLevels[] = {0.65, 0.5, 0.45, .1};
        };
    };
};
