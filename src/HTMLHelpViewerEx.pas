unit HTMLHelpViewerEx;

{$ALIGN ON}
{$MINENUMSIZE 4}
{$R-}

{$DEFINE UNKNOWN_COMPILER_VERSION}

{$IFDEF VER80} // Delphi 1
  {$DEFINE COMPILER1}
  {$DEFINE OverrideOnHelp}
  {$DEFINE LongintGetHandle}
  {$DEFINE CPUX86}
  {$UNDEF UNKNOWN_COMPILER_VERSION}
{$ENDIF}

{$IFDEF VER90} // Delphi 2
  {$DEFINE COMPILER2}
  {$DEFINE OverrideOnHelp}
  {$DEFINE LongintGetHandle}
  {$DEFINE CPUX86}
  {$UNDEF UNKNOWN_COMPILER_VERSION}
{$ENDIF}

{$IFDEF VER93} // C++ Builder
  {$DEFINE COMPILER2}
  {$DEFINE OverrideOnHelp}
  {$DEFINE LongintGetHandle}
  {$DEFINE CPUX86}
  {$UNDEF UNKNOWN_COMPILER_VERSION}
{$ENDIF}

{$IFDEF VER100} // Delphi 3
  {$DEFINE COMPILER3}
  {$DEFINE OverrideOnHelp}
  {$DEFINE LongintGetHandle}
  {$DEFINE CPUX86}
  {$UNDEF UNKNOWN_COMPILER_VERSION}
{$ENDIF}

{$IFDEF VER110} // C++ Builder
  {$DEFINE COMPILER3}
  {$DEFINE OverrideOnHelp}
  {$DEFINE LongintGetHandle}
  {$DEFINE CPUX86}
  {$UNDEF UNKNOWN_COMPILER_VERSION}
{$ENDIF}

{$IFDEF VER120} // Delphi 4
  {$DEFINE COMPILER4}
  {$DEFINE OverrideOnHelp}
  {$DEFINE LongintGetHandle}
  {$DEFINE CPUX86}
  {$UNDEF UNKNOWN_COMPILER_VERSION}
{$ENDIF}

{$IFDEF VER125} // C++ Builder
  {$DEFINE COMPILER4}
  {$DEFINE OverrideOnHelp}
  {$DEFINE LongintGetHandle}
  {$DEFINE CPUX86}
  {$UNDEF UNKNOWN_COMPILER_VERSION}
{$ENDIF}

{$IFDEF VER130} // Delphi 5
  {$DEFINE COMPILER5}
  {$DEFINE OverrideOnHelp}
  {$DEFINE LongintGetHandle}
  {$DEFINE CPUX86}
  {$UNDEF UNKNOWN_COMPILER_VERSION}
{$ENDIF}

{$IFDEF VER140} // Delphi 6
  {$DEFINE COMPILER6}
  {$DEFINE HasWinHelpViewer}
  {$DEFINE HasHelpIntfs}
  {$DEFINE DisableWinHelp}
  {$DEFINE LongintGetHandle}
  {$DEFINE OverrideOnHelp} // Delphi 6 bug: not all WinHelp commands are passed to Viewer
  {$DEFINE CPUX86}
  {$WARN UNIT_PLATFORM OFF}
  {$WARN SYMBOL_PLATFORM OFF}
  {$UNDEF UNKNOWN_COMPILER_VERSION}
{$ENDIF}

{$IFDEF VER150} // Delphi 7
  {$DEFINE COMPILER7}
  {$DEFINE HasWinHelpViewer}
  {$DEFINE HasHelpIntfs}
  {$DEFINE HasISpecialWinHelpViewer}
  {$DEFINE HasGet8087CW}
  {$DEFINE DisableWinHelp}
  {$DEFINE LongintGetHandle}
  {$DEFINE OverrideOnHelp} // Delphi 7 bug: not all WinHelp commands are passed to Viewer
  {$DEFINE CPUX86}
  {$WARN UNSAFE_CAST OFF}
  {$WARN UNSAFE_CODE OFF}
  {$WARN UNSAFE_TYPE OFF}
  {$WARN UNIT_PLATFORM OFF}
  {$WARN SYMBOL_PLATFORM OFF}
  {$UNDEF UNKNOWN_COMPILER_VERSION}
{$ENDIF}

{$IFDEF VER160} // Delphi 8
  {$DEFINE COMPILER8}
  {$DEFINE HasWinHelpViewer}
  {$DEFINE HasHelpIntfs}
  {$DEFINE HasISpecialWinHelpViewer}
  {$DEFINE HasGet8087CW}
  {$DEFINE LongintGetHandle}
  {$DEFINE CPUX86}
  {$WARN UNSAFE_CAST OFF}
  {$WARN UNSAFE_CODE OFF}
  {$WARN UNSAFE_TYPE OFF}
  {$WARN UNIT_PLATFORM OFF}
  {$WARN SYMBOL_PLATFORM OFF}
  {$UNDEF UNKNOWN_COMPILER_VERSION}
{$ENDIF}

{$IFDEF VER170} // Delphi 2005
  {$DEFINE COMPILER9}
  {$DEFINE HasWinHelpViewer}
  {$DEFINE HasHelpIntfs}
  {$DEFINE HasISpecialWinHelpViewer}
  {$DEFINE HasGet8087CW}
  {$DEFINE LongintGetHandle}
  {$DEFINE CPUX86}
  {$WARN UNSAFE_CAST OFF}
  {$WARN UNSAFE_CODE OFF}
  {$WARN UNSAFE_TYPE OFF}
  {$WARN UNIT_PLATFORM OFF}
  {$WARN SYMBOL_PLATFORM OFF}
  {$UNDEF UNKNOWN_COMPILER_VERSION}
{$ENDIF}

{$IFDEF VER180} // Delphi 2006/2007
  {$IFDEF VER185}
    {$DEFINE COMPILER11}
  {$ELSE}
    {$DEFINE COMPILER10}
  {$ENDIF}
  {$DEFINE HasWinHelpViewer}
  {$DEFINE HasHelpIntfs}
  {$DEFINE HasISpecialWinHelpViewer}
  {$DEFINE HasGet8087CW}
  {$DEFINE LongintGetHandle}
  {$DEFINE CPUX86}
  {$WARN UNSAFE_CAST OFF}
  {$WARN UNSAFE_CODE OFF}
  {$WARN UNSAFE_TYPE OFF}
  {$WARN UNIT_PLATFORM OFF}
  {$WARN SYMBOL_PLATFORM OFF}
  {$UNDEF UNKNOWN_COMPILER_VERSION}
{$ENDIF}

{$IFDEF VER190} // Delphi 2007 for .NET
  {$DEFINE COMPILER11}
  {$DEFINE HasWinHelpViewer}
  {$DEFINE HasHelpIntfs}
  {$DEFINE HasISpecialWinHelpViewer}
  {$DEFINE HasGet8087CW}
  {$DEFINE LongintGetHandle}
  {$DEFINE CPUX86}
  {$WARN UNSAFE_CAST OFF}
  {$WARN UNSAFE_CODE OFF}
  {$WARN UNSAFE_TYPE OFF}
  {$WARN UNIT_PLATFORM OFF}
  {$WARN SYMBOL_PLATFORM OFF}
  {$UNDEF UNKNOWN_COMPILER_VERSION}
{$ENDIF}

{$IFDEF VER200} // RAD Studio 2009
  {$DEFINE COMPILER12}
  {$DEFINE HasWinHelpViewer}
  {$DEFINE HasHelpIntfs}
  {$DEFINE HasISpecialWinHelpViewer}
  {$DEFINE HasIExtendedHelpViewer2}
  {$DEFINE HasGet8087CW}
  {$DEFINE LongintGetHandle}
  {$DEFINE CPUX86}
  {$WARN UNSAFE_CAST OFF}
  {$WARN UNSAFE_CODE OFF}
  {$WARN UNSAFE_TYPE OFF}
  {$WARN UNIT_PLATFORM OFF}
  {$WARN SYMBOL_PLATFORM OFF}
  {$UNDEF UNKNOWN_COMPILER_VERSION}
{$ENDIF}

{$IFDEF VER210} // RAD Studio 2010
  {$DEFINE COMPILER14}
  {$DEFINE HasWinHelpViewer}
  {$DEFINE HasHelpIntfs}
  {$DEFINE HasISpecialWinHelpViewer}
  {$DEFINE HasIExtendedHelpViewer2}
  {$DEFINE HasGet8087CW}
  {$DEFINE LongintGetHandle}
  {$DEFINE CPUX86}
  {$WARN UNSAFE_CAST OFF}
  {$WARN UNSAFE_CODE OFF}
  {$WARN UNSAFE_TYPE OFF}
  {$WARN UNIT_PLATFORM OFF}
  {$WARN SYMBOL_PLATFORM OFF}
  {$UNDEF UNKNOWN_COMPILER_VERSION}
{$ENDIF}

{$IFDEF VER220} // RAD Studio XE
  {$DEFINE COMPILER15}
  {$DEFINE HasWinHelpViewer}
  {$DEFINE HasHelpIntfs}
  {$DEFINE HasISpecialWinHelpViewer}
  {$DEFINE HasIExtendedHelpViewer2}
  {$DEFINE HasGet8087CW}
  {$DEFINE LongintGetHandle}
  {$DEFINE CPUX86}
  {$WARN UNSAFE_CAST OFF}
  {$WARN UNSAFE_CODE OFF}
  {$WARN UNSAFE_TYPE OFF}
  {$WARN UNIT_PLATFORM OFF}
  {$WARN SYMBOL_PLATFORM OFF}
  {$UNDEF UNKNOWN_COMPILER_VERSION}
{$ENDIF}

{$IFDEF VER230} // RAD Studio XE 2
  {$DEFINE COMPILER16}
  {$DEFINE HasWinHelpViewer}
  {$DEFINE HasHelpIntfs}
  {$DEFINE HasISpecialWinHelpViewer}
  {$DEFINE HasIExtendedHelpViewer2}
  {$DEFINE HasGet8087CW}
  {$WARN UNSAFE_CAST OFF}
  {$WARN UNSAFE_CODE OFF}
  {$WARN UNSAFE_TYPE OFF}
  {$WARN UNIT_PLATFORM OFF}
  {$WARN SYMBOL_PLATFORM OFF}
  {$UNDEF UNKNOWN_COMPILER_VERSION}
{$ENDIF}

{$IFDEF VER240} // RAD Studio XE 3
  {$DEFINE COMPILER17}
  {$DEFINE HasWinHelpViewer}
  {$DEFINE HasHelpIntfs}
  {$DEFINE HasISpecialWinHelpViewer}
  {$DEFINE HasIExtendedHelpViewer2}
  {$DEFINE HasGet8087CW}
  {$WARN UNSAFE_CAST OFF}
  {$WARN UNSAFE_CODE OFF}
  {$WARN UNSAFE_TYPE OFF}
  {$WARN UNIT_PLATFORM OFF}
  {$WARN SYMBOL_PLATFORM OFF}
  {$UNDEF UNKNOWN_COMPILER_VERSION}
{$ENDIF}

{$IFDEF VER250} // RAD Studio XE 4
  {$DEFINE COMPILER18}
  {$DEFINE HasWinHelpViewer}
  {$DEFINE HasHelpIntfs}
  {$DEFINE HasISpecialWinHelpViewer}
  {$DEFINE HasIExtendedHelpViewer2}
  {$DEFINE HasGet8087CW}
  {$WARN UNSAFE_CAST OFF}
  {$WARN UNSAFE_CODE OFF}
  {$WARN UNSAFE_TYPE OFF}
  {$WARN UNIT_PLATFORM OFF}
  {$WARN SYMBOL_PLATFORM OFF}
  {$UNDEF UNKNOWN_COMPILER_VERSION}
{$ENDIF}

{$IFDEF VER260} // RAD Studio XE 5
  {$DEFINE COMPILER19}
  {$DEFINE HasWinHelpViewer}
  {$DEFINE HasHelpIntfs}
  {$DEFINE HasISpecialWinHelpViewer}
  {$DEFINE HasIExtendedHelpViewer2}
  {$DEFINE HasGet8087CW}
  {$WARN UNSAFE_CAST OFF}
  {$WARN UNSAFE_CODE OFF}
  {$WARN UNSAFE_TYPE OFF}
  {$WARN UNIT_PLATFORM OFF}
  {$WARN SYMBOL_PLATFORM OFF}
  {$UNDEF UNKNOWN_COMPILER_VERSION}
{$ENDIF}

{$IFDEF VER270} // RAD Studio XE 6
  {$DEFINE COMPILER20}
  {$DEFINE HasWinHelpViewer}
  {$DEFINE HasHelpIntfs}
  {$DEFINE HasISpecialWinHelpViewer}
  {$DEFINE HasIExtendedHelpViewer2}
  {$DEFINE HasGet8087CW}
  {$WARN UNSAFE_CAST OFF}
  {$WARN UNSAFE_CODE OFF}
  {$WARN UNSAFE_TYPE OFF}
  {$WARN UNIT_PLATFORM OFF}
  {$WARN SYMBOL_PLATFORM OFF}
  {$UNDEF UNKNOWN_COMPILER_VERSION}
{$ENDIF}

{$IFDEF VER280} // RAD Studio XE 7
  {$DEFINE COMPILER21}
  {$DEFINE HasWinHelpViewer}
  {$DEFINE HasHelpIntfs}
  {$DEFINE HasISpecialWinHelpViewer}
  {$DEFINE HasIExtendedHelpViewer2}
  {$DEFINE HasGet8087CW}
  {$WARN UNSAFE_CAST OFF}
  {$WARN UNSAFE_CODE OFF}
  {$WARN UNSAFE_TYPE OFF}
  {$WARN UNIT_PLATFORM OFF}
  {$WARN SYMBOL_PLATFORM OFF}
  {$UNDEF UNKNOWN_COMPILER_VERSION}
{$ENDIF}

{$IFDEF VER290} // RAD Studio XE 8
  {$DEFINE COMPILER22}
  {$DEFINE HasWinHelpViewer}
  {$DEFINE HasHelpIntfs}
  {$DEFINE HasISpecialWinHelpViewer}
  {$DEFINE HasIExtendedHelpViewer2}
  {$DEFINE HasGet8087CW}
  {$WARN UNSAFE_CAST OFF}
  {$WARN UNSAFE_CODE OFF}
  {$WARN UNSAFE_TYPE OFF}
  {$WARN UNIT_PLATFORM OFF}
  {$WARN SYMBOL_PLATFORM OFF}
  {$UNDEF UNKNOWN_COMPILER_VERSION}
{$ENDIF}

{$IFDEF VER300} // RAD Studio 10 Seatle
  {$DEFINE COMPILER23}
  {$DEFINE HasWinHelpViewer}
  {$DEFINE HasHelpIntfs}
  {$DEFINE HasISpecialWinHelpViewer}
  {$DEFINE HasIExtendedHelpViewer2}
  {$DEFINE HasGet8087CW}
  {$WARN UNSAFE_CAST OFF}
  {$WARN UNSAFE_CODE OFF}
  {$WARN UNSAFE_TYPE OFF}
  {$WARN UNIT_PLATFORM OFF}
  {$WARN SYMBOL_PLATFORM OFF}
  {$UNDEF UNKNOWN_COMPILER_VERSION}
{$ENDIF}

{$IFDEF VER310} // RAD Studio 10.1 Berlin
  {$DEFINE COMPILER24}
  {$DEFINE HasWinHelpViewer}
  {$DEFINE HasHelpIntfs}
  {$DEFINE HasISpecialWinHelpViewer}
  {$DEFINE HasIExtendedHelpViewer2}
  {$DEFINE HasGet8087CW}
  {$WARN UNSAFE_CAST OFF}
  {$WARN UNSAFE_CODE OFF}
  {$WARN UNSAFE_TYPE OFF}
  {$WARN UNIT_PLATFORM OFF}
  {$WARN SYMBOL_PLATFORM OFF}
  {$UNDEF UNKNOWN_COMPILER_VERSION}
{$ENDIF}

{$IFDEF UNKNOWN_COMPILER_VERSION} // Future versions
  {$DEFINE COMPILER24}
  {$DEFINE HasWinHelpViewer}
  {$DEFINE HasHelpIntfs}
  {$DEFINE HasISpecialWinHelpViewer}
  {$DEFINE HasIExtendedHelpViewer2}
  {$DEFINE HasGet8087CW}
  {$WARN UNSAFE_CAST OFF}
  {$WARN UNSAFE_CODE OFF}
  {$WARN UNSAFE_TYPE OFF}
  {$WARN UNIT_PLATFORM OFF}
  {$WARN SYMBOL_PLATFORM OFF}
  {$UNDEF UNKNOWN_COMPILER_VERSION}
{$ENDIF}

interface

uses
  Windows,
  Classes;

{$IFDEF CPUX86}
type
  DWORD_PTR = Cardinal;
{$ENDIF}

type
  IHtmlHelpTester = interface(IUnknown)
  ['{0DA4AB85-6F7A-489B-8D1D-FBA387BD8342}']
    function CanShowALink(const ALink, FileName: string): Boolean;
    function CanShowTopic(const Topic, FileName: string): Boolean;
    function CanShowContext(const Context: Integer; const FileName: string): Boolean;
    function GetHelpStrings(const ALink: string): TStringList;
    function GetHelpPath: string;
    function GetDefaultHelpFile: string;
    function ConvertWinHelp(var Command: Word; var Data: DWORD_PTR): Boolean;
  end;

var
// Because HtmlHelp is uncooperative about responding to queries along the
// lines of 'do you support this', the HtmlHelp viewer in essence needs to
// hack a response to that. This interface is a hook by which user applications
// can override the HtmlHelp viewer's default answer.
  HtmlHelpTester: IHtmlHelpTester;

// ViewerName returns a string that the Help Manager can use to identify
// this Viewer in a UI element asking users to choose among Viewers.
  ViewerName: string;

const
  HELP_TAB = 15;

  HH_DISPLAY_TOPIC       =    0;
  HH_HELP_FINDER         =    0;
  HH_DISPLAY_TOC         =    1;
  HH_DISPLAY_INDEX       =    2;
  HH_DISPLAY_SEARCH      =    3;
  HH_SET_WIN_TYPE        =    4;
  HH_GET_WIN_TYPE        =    5;
  HH_GET_WIN_HANDLE      =    6;
  HH_ENUM_INFO_TYPE      =    7;
  HH_SET_INFO_TYPE       =    8;
  HH_SYNC                =    9;
  HH_KEYWORD_LOOKUP      =   $d;
  HH_DISPLAY_TEXT_POPUP  =   $e;
  HH_HELP_CONTEXT        =   $f;
  HH_TP_HELP_CONTEXTMENU =  $10;
  HH_TP_HELP_WM_HELP     =  $11;
  HH_CLOSE_ALL           =  $12;
  HH_ALINK_LOOKUP        =  $13;
  HH_GET_LAST_ERROR      =  $14;
  HH_ENUM_CATEGORY       =  $15;
  HH_ENUM_CATEGORY_IT    =  $16;
  HH_RESET_IT_FILTER     =  $17;
  HH_SET_INCLUSIVE_FILTER = $18;
  HH_SET_EXCLUSIVE_FILTER = $19;
  HH_INITIALIZE          =  $1c;
  HH_UNINITIALIZE        =  $1d;
  HH_SET_QUERYSERVICE    =  $1e;
  HH_PRETRANSLATEMESSAGE =  $fd;
  HH_GLOBALPROPERTY      =  $fc;

  HHWIN_PROP_TAB_AUTOHIDESHOW = 1 shl  0;
  HHWIN_PROP_ONTOP            = 1 shl  1;
  HHWIN_PROP_NOTITLEBAR       = 1 shl  2;
  HHWIN_PROP_NODEF_STYLES     = 1 shl  3;
  HHWIN_PROP_NODEF_EXSTYLES   = 1 shl  4;
  HHWIN_PROP_TRI_PANE         = 1 shl  5;
  HHWIN_PROP_NOTB_TEXT        = 1 shl  6;
  HHWIN_PROP_POST_QUIT        = 1 shl  7;
  HHWIN_PROP_AUTO_SYNC        = 1 shl  8;
  HHWIN_PROP_TRACKING         = 1 shl  9;
  HHWIN_PROP_TAB_SEARCH       = 1 shl 10;
  HHWIN_PROP_TAB_HISTORY      = 1 shl 11;
  HHWIN_PROP_TAB_FAVORITES    = 1 shl 12;
  HHWIN_PROP_CHANGE_TITLE     = 1 shl 13;
  HHWIN_PROP_NAV_ONLY_WIN     = 1 shl 14;
  HHWIN_PROP_NO_TOOLBAR       = 1 shl 15;
  HHWIN_PROP_MENU             = 1 shl 16;
  HHWIN_PROP_TAB_ADVSEARCH    = 1 shl 17;
  HHWIN_PROP_USER_POS         = 1 shl 18;
  HHWIN_PROP_TAB_CUSTOM1      = 1 shl 19;
  HHWIN_PROP_TAB_CUSTOM2      = 1 shl 20;
  HHWIN_PROP_TAB_CUSTOM3      = 1 shl 21;
  HHWIN_PROP_TAB_CUSTOM4      = 1 shl 22;
  HHWIN_PROP_TAB_CUSTOM5      = 1 shl 23;
  HHWIN_PROP_TAB_CUSTOM6      = 1 shl 24;
  HHWIN_PROP_TAB_CUSTOM7      = 1 shl 25;
  HHWIN_PROP_TAB_CUSTOM8      = 1 shl 26;
  HHWIN_PROP_TAB_CUSTOM9      = 1 shl 27;
  HHWIN_PROP_TB_MARGIN        = 1 shl 28;

  HHWIN_PARAM_PROPERTIES      = 1 shl  1;
  HHWIN_PARAM_STYLES          = 1 shl  2;
  HHWIN_PARAM_EXSTYLES        = 1 shl  3;
  HHWIN_PARAM_RECT            = 1 shl  4;
  HHWIN_PARAM_NAV_WIDTH       = 1 shl  5;
  HHWIN_PARAM_SHOWSTATE       = 1 shl  6;
  HHWIN_PARAM_INFOTYPES       = 1 shl  7;
  HHWIN_PARAM_TB_FLAGS        = 1 shl  8;
  HHWIN_PARAM_EXPANSION       = 1 shl  9;
  HHWIN_PARAM_TABPOS          = 1 shl 10;
  HHWIN_PARAM_TABORDER        = 1 shl 11;
  HHWIN_PARAM_HISTORY_COUNT   = 1 shl 12;
  HHWIN_PARAM_CUR_TAB         = 1 shl 13;

  HHWIN_BUTTON_EXPAND         = 1 shl  1;
  HHWIN_BUTTON_BACK           = 1 shl  2;
  HHWIN_BUTTON_FORWARD        = 1 shl  3;
  HHWIN_BUTTON_STOP           = 1 shl  4;
  HHWIN_BUTTON_REFRESH        = 1 shl  5;
  HHWIN_BUTTON_HOME           = 1 shl  6;
  HHWIN_BUTTON_BROWSE_FWD     = 1 shl  7;
  HHWIN_BUTTON_BROWSE_BCK     = 1 shl  8;
  HHWIN_BUTTON_NOTES          = 1 shl  9;
  HHWIN_BUTTON_CONTENTS       = 1 shl 10;
  HHWIN_BUTTON_SYNC           = 1 shl 11;
  HHWIN_BUTTON_OPTIONS        = 1 shl 12;
  HHWIN_BUTTON_PRINT          = 1 shl 13;
  HHWIN_BUTTON_INDEX          = 1 shl 14;
  HHWIN_BUTTON_SEARCH         = 1 shl 15;
  HHWIN_BUTTON_HISTORY        = 1 shl 16;
  HHWIN_BUTTON_FAVORITES      = 1 shl 17;
  HHWIN_BUTTON_JUMP1          = 1 shl 18;
  HHWIN_BUTTON_JUMP2          = 1 shl 19;
  HHWIN_BUTTON_ZOOM           = 1 shl 20;
  HHWIN_BUTTON_TOC_NEXT       = 1 shl 21;
  HHWIN_BUTTON_TOC_PREV       = 1 shl 22;

  HHWIN_DEF_BUTTONS = HHWIN_BUTTON_EXPAND or HHWIN_BUTTON_BACK or HHWIN_BUTTON_OPTIONS or HHWIN_BUTTON_PRINT;

  IDTB_EXPAND      = 200;
  IDTB_CONTRACT    = 201;
  IDTB_STOP        = 202;
  IDTB_REFRESH     = 203;
  IDTB_BACK        = 204;
  IDTB_HOME        = 205;
  IDTB_SYNC        = 206;
  IDTB_PRINT       = 207;
  IDTB_OPTIONS     = 208;
  IDTB_FORWARD     = 209;
  IDTB_NOTES       = 210;
  IDTB_BROWSE_FWD  = 211;
  IDTB_BROWSE_BACK = 212;
  IDTB_CONTENTS    = 213;
  IDTB_INDEX       = 214;
  IDTB_SEARCH      = 215;
  IDTB_HISTORY     = 216;
  IDTB_FAVORITES   = 217;
  IDTB_JUMP1       = 218;
  IDTB_JUMP2       = 219;
  IDTB_CUSTOMIZE   = 221;
  IDTB_ZOOM        = 222;
  IDTB_TOC_NEXT    = 223;
  IDTB_TOC_PREV    = 224;

  HHN_FIRST         =       0 - 860;
  HHN_LAST          =       0 - 879;
  HHN_NACVOMPLITE   = HHN_FIRST - 0;
  HHN_TRACK         = HHN_FIRST - 1;
  HHN_WINDOW_CREATE = HHN_FIRST - 2;

type
  PHHN_Notify = ^THHN_Notify;

  _HHN_NOTIFY = packed record
    hdr: TNMHDR;
    pszUrl: PAnsiChar;
  end;

  THHN_Notify = _HHN_NOTIFY;
  HHN_NOTIFY = _HHN_NOTIFY;

  PHH_POPUP = ^THH_Popup;

  _HH_POPUP = record
    cbStruct: Integer;
    hInst: HINST;
    idString: UINT;
    pszText : LPCTSTR;
    pt : TPoint;
    clrForeground: TColorRef;
    clrBackground: TColorRef;
    rcMargins: TRect;
    pszFont: LPCTSTR;
  end;

  THH_Popup = _HH_POPUP;
  HH_POPUP = _HH_POPUP;

  PHH_AKLINK = ^THH_AKLink;

  _HH_AKLINK = record
    cbStruct: Integer;
    fReserved: BOOL; { must be FALSE }
    pszKeywords: LPCTSTR;
    pszUrl: LPCTSTR;
    pszMsgText: LPCTSTR;
    pszMsgTitle: LPCTSTR;
    pszWindow: LPCTSTR;
    fIndexOnFail: BOOL;
  end;

  THH_AKLink = _HH_AKLINK;
  HH_AKLINK = _HH_AKLINK;

  PHH_Enum_It = ^THH_Enum_It;

  _HH_ENUM_IT = packed record
    cbStruct: Integer;
    iType: Integer;
    pszCatName: PAnsiChar;
    pszITName: PAnsiChar;
    pszItDescription: PAnsiChar;
  end;

  THH_Enum_it = _HH_ENUM_IT;
  HH_ENUM_IT = _HH_ENUM_IT;

  PHH_Enum_Cat = ^THH_Enum_Cat;

  _HH_ENUM_CAT = packed record
    cbStruct: Integer;
    pszCatName: PAnsiChar;
    pszCatDescription: PAnsiChar;
  end;

  THH_Enum_Cat = _HH_ENUM_CAT;
  HH_ENUM_CAT = _HH_ENUM_CAT;

  PHH_Set_Infotype = ^THH_Set_Infotype;

  _HH_SET_INFOTYPE = packed record
    cbStruct: Integer;
    pszCatName: PAnsiChar;
    pszInfoTypeName: PAnsiChar;
  end;

  THH_Set_Infotype = _HH_SET_INFOTYPE;
  HH_SET_INFOTYPE = _HH_SET_INFOTYPE;

  PHH_Infotype = ^THH_Infotype;
  THH_Infotype = Dword;
  HH_INFOTYPE = THH_Infotype;

  PHH_Fts_QueryA = ^THH_Fts_QueryA;
  PHH_Fts_QueryW = ^THH_Fts_QueryW;
  {$IFNDEF UNICODE}
  PHH_Fts_Query = PHH_Fts_QueryA;
  {$ELSE}
  PHH_Fts_Query = PHH_Fts_QueryW;
  {$ENDIF}

  _HH_FTS_QUERYA = record
    cbStruct: Integer;
    fUniCodeStrings: BOOL;
    pszSearchQuery: PAnsiChar;
    iProximity: longint;
    fStemmedSearch: BOOL;
    fTitleOnly: BOOL;
    fExecute: BOOL;
    pszWindow: PAnsiChar;
  end;
  _HH_FTS_QUERYW = record
    cbStruct: Integer;
    fUniCodeStrings: BOOL;
    pszSearchQuery: PWideChar;
    iProximity: longint;
    fStemmedSearch: BOOL;
    fTitleOnly: BOOL;
    fExecute: BOOL;
    pszWindow: PWideChar;
  end;
  _HH_FTS_QUERY = _HH_FTS_QUERYW;

  THH_Fts_QueryA = _HH_FTS_QUERYA;
  THH_Fts_QueryW = _HH_FTS_QUERYW;
  {$IFNDEF UNICODE}
  THH_Fts_Query = THH_Fts_QueryA;
  {$ELSE}
  THH_Fts_Query = THH_Fts_QueryW;
  {$ENDIF}

  HH_FTS_QUERYA = _HH_FTS_QUERYA;
  HH_FTS_QUERYW = _HH_FTS_QUERYW;
  {$IFNDEF UNICODE}
  HH_FTS_QUERY = HH_FTS_QUERYA;
  {$ELSE}
  HH_FTS_QUERY = HH_FTS_QUERYW;
  {$ENDIF}

  PHH_Wintype = ^THH_Wintype;

  _HH_WINTYPE = record
    cbStruct: Integer;
    fUniCodeStrings: BOOL;
    pszType: LPCTSTR;
    fsValidMembers: DWord;
    fsWinProperties: DWord;
    pszCaption: LPCTSTR;
    dwStyles: DWord; 
    dwExStyles: DWord;
    rcWindowPos: TRect;
    nShowState: Integer;
    hwndHelp: HWND;
    hwndCaller: HWND;
    paInfoTypes: PHH_Infotype;
    hwndToolBar: HWND;
    hwndNavigation: HWND;
    hwndHTML: HWND;
    iNavWidth: Integer;
    rcHTML: TRect;
    pszToc: LPCTSTR;
    pszIndex: LPCTSTR;
    pszFile: LPCTSTR;
    pszHome: LPCTSTR;
    fsToolBarFlags: DWord;
    fNotExpanded: BOOL;
    curNavType: Integer;
    tabPos: Integer;
    idNotify: Integer;
    tabOrder: array[0..19] of Byte;
    cHistory: Integer;
    pszJump1: LPCTSTR;
    pszJump2: LPCTSTR;
    pszUrlJump1: LPCTSTR;
    pszUrlJump2: LPCTSTR;
    rcMinSize: TRect;
    cbInfoTYpes: Integer;
    pszCustomTabs: Integer;
  end;

  THH_WINTYPE = _HH_WINTYPE;
  HH_WINTYPE = _HH_WINTYPE;

  PHH_NTrack = ^THH_NTrack;

  _HH_NTRACK = packed record
    hdr : TNMHdr;
    pszCurUrl: PAnsiChar;
    idAction: Integer;
  end;

  THH_NTrack = _HH_NTRACK;
  HH_NTRACK = _HH_NTRACK;

function HtmlHelp(hWndCaller: HWND; pszFile: String; uCommand: UINT; dwData: DWORD_PTR): HWND;

{$IFNDEF Get8087CW}
var
  Default8087CW: Word = $1332;{ Default 8087 control word.  FPU control
                                register is set to this value.
                                CAUTION:  Setting this to an invalid value
                                could cause unpredictable behavior. }
function Get8087CW: Word;
procedure Set8087CW(NewCW: Word);
{$ENDIF}

implementation

uses
  {$IFDEF DisableWinHelp}
  WinHelpViewer,
  {$ENDIF}
  {$IFDEF HasHelpIntfs}
  HelpIntfs,
  {$ENDIF}
  {$IFDEF HasStrUtils}
  StrUtils,
  {$ENDIF}
  Forms,
  Controls,
  SysUtils;

{$IFNDEF Get8087CW}
procedure Set8087CW(NewCW: Word);
begin
  Default8087CW := NewCW;
  asm
        FNCLEX  // don't raise pending exceptions enabled by the new flags
        FLDCW   Default8087CW
  end;
end;

function Get8087CW: Word;
asm
        PUSH    0
        FNSTCW  [ESP].Word
        POP     EAX
end;
{$ENDIF}

const
  PathDelim = '\';

type
  THtmlHelpAProc = function(hWndCaller: HWND; pszFile: PAnsiChar; uCommand: UINT; dwData: DWORD_PTR): HWnd; stdcall;
  THtmlHelpWProc = function(hWndCaller: HWND; pszFile: PWideChar; uCommand: UINT; dwData: DWORD_PTR): HWnd; stdcall;

var
  HtmlHelpModule: HModule;
  HtmlHelpAProc: THtmlHelpAProc;
  HtmlHelpWProc: THtmlHelpWPRoc;

function _HtmlHelpSetup : Boolean;

  function SafeLoadLibrary(const Filename: string; ErrorMode: UINT = SEM_NOOPENFILEERRORBOX): HMODULE;

    {$IFDEF CPUX86}
    function TestAndClearFPUExceptions(AExceptionMask: Word): Boolean;
    asm
          PUSH    ECX
          MOV     CX, AX
          FSTSW   AX
          TEST    AX, CX
          JNE     @@bad
          XOR     EAX, EAX
          INC     EAX
          JMP     @@exit
    @@bad:
          XOR     EAX, EAX
    @@exit:
          POP     ECX
          FCLEX
    end;
    {$ENDIF CPUX86}

  var
    OldMode: UINT;
    {$IFDEF CPUX86}
    FPUControlWord: Word;
    {$ENDIF CPUX86}
  begin
    FillChar(Result, SizeOf(Result), 0); // avoid "Return value of function 'SafeLoadLibrary' might be undefined"
    OldMode := SetErrorMode(ErrorMode);
    try
      {$IFDEF CPUX86}
        asm
          FNSTCW  FPUControlWord
        end;
        try
          Result := LoadLibrary(PChar(Filename));
          TestAndClearFPUExceptions(0);
        finally
          asm
            FNCLEX
            FLDCW FPUControlWord
          end;
        end;
      {$ENDIF CPUX86}
      {$IFDEF CPUX64}
        Result := LoadLibrary(PChar(Filename));
      {$ENDIF CPUX64}
    finally
      SetErrorMode(OldMode);
    end;
  end;

  function GetSystemDirectory: String;
  begin
    SetLength(Result, 4097);
    FillChar(Pointer(Result)^, Length(Result) * SizeOf(Char), 0);
    Windows.GetSystemDirectory(PChar(Result), Length(Result) - 1);
    SetLength(Result, StrLen(PChar(Result)));
    if Result = '' then
      Result := 'C:\Windows\System32\'
    else
    if Result[Length(Result)] <> PathDelim then
      Result := Result + PathDelim;
  end;

begin
  if HtmlHelpModule = 0 then
  begin
    HtmlHelpModule := SafeLoadLibrary('hhctrl.ocx');
    if HtmlHelpModule = 0 then
      HtmlHelpModule := SafeLoadLibrary(GetSystemDirectory + 'hhctrl.ocx');
    if HtmlHelpModule <> 0 then
    begin
      @HtmlHelpAProc := GetProcAddress(HtmlHelpModule, 'HtmlHelpA');
      @HtmlHelpWProc := GetProcAddress(HtmlHelpModule, 'HtmlHelpW');
    end;
  end;
  Result := Assigned(HtmlHelpAProc) and Assigned(HtmlHelpWProc);
end;

function HtmlHelp(hWndCaller: HWND; pszFile: String; uCommand: UINT; dwData: DWORD_PTR): HWND;
begin
  Result := 0;
  if _HtmlHelpSetup then
  begin
  {$IFNDEF UNICODE}
    Result := HtmlHelpAProc(hWndCaller, Pointer(pszFile), uCommand, dwData);
  {$ELSE}
    Result := HtmlHelpWProc(hWndCaller, Pointer(pszFile), uCommand, dwData);
  {$ENDIF}
    // http://stackoverflow.com/questions/15012547/helpfile-opened-from-modal-window-unresponsive
    if (Result <> 0) and
       IsWindow(Result) and
       IsWindowVisible(Result) and
       (not IsWindowEnabled(Result)) then
      EnableWindow(Result, True);
  end;
end;

type
  {$IFNDEF HasHelpIntfs}
  IHelpManager = interface
    ['{B0FC9366-5F0E-11D3-A3B9-00C04F79AD3A}']
    function  GetHandle: {$IFDEF LongintGetHandle}Longint{$ELSE}THandle{$ENDIF}; { sizeof(LongInt) = sizeof (HWND) }
    function  GetHelpFile: String;
    procedure Release(const ViewerID: Integer);
  end;
  {$ENDIF}

  THTMLHelpViewer = class(TInterfacedObject {$IFDEF HasHelpIntfs}, ICustomHelpViewer, IExtendedHelpViewer {$IFDEF HasIExtendedHelpViewer2}, IExtendedHelpViewer2{$ENDIF} {$IFDEF HasISpecialWinHelpViewer}, ISpecialWinHelpViewer{$ENDIF}{$ENDIF})
  private
    FInitializedCookie: LongInt;
    FViewerID: Integer;
    FTopCenter: TPoint;
    FForeground: TColorRef;
    FBackground: TColorRef;
    FMargins: TRect;
    FFontDesc: string;
    FPopupResourceHandle: HWND;

    FPopupResourceID: LongInt;
    FPopupText: string;
    FInitialized: Boolean;
    FHelpManager: IHelpManager;
    procedure ValidateHelpViewer;
  public
    constructor Create;
    destructor Destroy; override;
    { internal support functions }
    function GetHelpFile(const Name: string): string;
    procedure InternalShutDown;
    procedure SynchTopic(Handle: HWND; const HelpFileName: string);
    procedure LookupALink(Handle: HWND; const HelpFileName: string; LinkPtr: PHH_AkLink);
    procedure LookupKeyword(Handle: HWND; const HelpFileName: string; LinkPtr: PHH_AKLink);
    procedure DisplayTextPopup(Handle: HWND; Data: PHH_Popup);
    { ICustomHelpViewer }
    function GetViewerName : string;
    function UnderstandsKeyword(const HelpString: string): Integer;
    function GetHelpStrings(const HelpString: string): TStringList;
    function CanShowTableOfContents: Boolean;
    procedure ShowTableOfContents;
    procedure ShowHelp(const HelpString: string);
    procedure NotifyID(const ViewerID: Integer);
    procedure SoftShutDown;
    procedure ShutDown;
    { IExtendedHelpViewer }
    function UnderstandsTopic(const Topic: string): Boolean;
    procedure DisplayTopic(const Topic: string); overload;
    function UnderstandsContext(const ContextID: Integer; const HelpFileName: string): Boolean;
    procedure DisplayHelpByContext(const ContextId: Integer; const HelpFileName: string);
    { ISpecialHtmlHelpViewer }
    function CallHtmlHelp(Handle: HWND; HelpFileName: string; Command: Integer; Data: DWORD_PTR): HWND;
    { IExtendedHelpViewer2 }
    procedure DisplaySearch(const Topic: string);
    procedure DisplayIndex(const Topic: string);
    procedure DisplayTopic(const Topic, Anchor: string); overload;
    { IPopupHelp }
    procedure SetupPopupWindow(TopCenter: TPoint; Foreground, Background: DWord; Margins: TRect; const FontDesc: string);
    procedure SetupPopupSource(Handle: HWND; ID: LongInt; const Text: string);
    procedure Popup(KeepWindowSetup: Boolean; KeepSourceSetup: Boolean);
    procedure ClearSetup;
    { ISpecialWinHelpViewer }
    function CallWinHelp(Handle: {$IFDEF LongintGetHandle}Longint{$ELSE}THandle{$ENDIF}; const HelpFileName: string; Command: Word; Data: {$IFDEF LongintGetHandle}Longint{$ELSE}NativeUInt{$ENDIF}) : Boolean;
    { properties }
    property ViewerID : Integer read FViewerID;
    property HelpManager : IHelpManager read FHelpManager write FHelpManager;
    property TopCenter: TPoint read FTopCenter write FTopCenter;
    property Foreground: TColorRef read FForeground write FForeground;
    property Background: TColorRef read FBackground write FBackground;
    property Margins: TRect read FMargins write FMargins;
    property FontDesc: string read FFontDesc write FFontDesc;
    property PopupResourceHandle: HWND read FPopupResourceHandle write FPopupResourceHandle;
    property PopupResourceId: LongInt read FPopupResourceId write FPopupResourceId;
    property PopupText: string read FPopupText write FPopupText;
  end;

var
  HelpViewer: THtmlHelpViewer;
  {$IFDEF HasHelpIntfs}
  HelpViewerIntf: ICustomHelpViewer;
  {$ENDIF}

procedure THtmlHelpViewer.ValidateHelpViewer;
begin
{ commented out to allow an error message for the field test. when help is
  delivered, restore this. ALSO, note, that checking for the return from
  HH_INITIALIZE appears to be wrong, and the raise should remain commented
  out: HH_INITIALIZE always returns 0 and fails to set the cookie. }

  if not FInitialized then
  begin
    HtmlHelp(0, '', HH_INITIALIZE, DWORD_PTR(@FInitializedCookie));
    if FInitializedCookie = 0 then
    begin
       //raise EHelpSystemException.CreateRes(@hNoHtmlHelp);
    end;
    FInitialized := True;
  end;

  //raise EHelpSystemException.CreateRes(@hNoHelpInThisRelease);
end;

{ ICustomHelpViewer. }

{ GetViewerName returns a string that the Help Manager can use to identify
  this Viewer in a UI element asking users to choose among Viewers. }
function THtmlHelpViewer.GetViewerName: string;
begin
  Result := ViewerName;
end;

{ UnderstandsKeyword is a querying function that the Help Manager calls to
  determine if the Viewer provide helps on a particular keyword string. }
function THtmlHelpViewer.UnderstandsKeyword(const HelpString: string): Integer;
var
  CanShowHelp : Boolean;
  HelpFile: string;
begin
  HelpFile := GetHelpFile('');
  Result := 1;
  if Assigned(HtmlHelpTester) then
  begin
    CanShowHelp := HtmlHelpTester.CanShowALink(HelpString, HelpFile);
    if not CanShowHelp then Result := 0;
  end;
end;

{ GetHelpStrings is used by the Help Manager to display a list of keyword
  matches from which an application's user can select one. It assumes
  that the String List is properly allocated, so this function should
  never return nil. }

function THtmlHelpViewer.GetHelpStrings(const HelpString: string): TStringList;
begin
  if Assigned(HtmlHelpTester) then
    Result := HtmlHelpTester.GetHelpStrings(HelpString)
  else
  begin
    Result := TStringList.Create;
    Result.Add(GetViewerName + ': ' + HelpString);
  end;
end;

{ CanShowTableOfContents is a querying function that the Help Manager
  calls to determine if the Viewer supports tables of contents. HtmlHelp does. }

function THtmlHelpViewer.CanShowTableOfContents: Boolean;
begin
  Result := True;
end;

{ ShowTableOfContents is a command function that the Help Manager uses
  to direct the Viewer to display a table of contents. It is never
  called without being preceded by a call to CanShowTableOfContents. }
procedure THtmlHelpViewer.ShowTableOfContents;
var
  FileName : string;
  Handle: HWND;
begin
  ValidateHelpViewer;
  FileName := GetHelpFile('');
  Handle := HWND(HelpManager.GetHandle);
  SynchTopic(Handle, FileName);
  HtmlHelp(Handle, FileName, HH_DISPLAY_TOPIC, 0);
end;

procedure THtmlHelpViewer.ShowHelp(const HelpString: string);
var
  FileName : string;
  Link: THH_AKLink;
begin
  ValidateHelpViewer;
  FileName := GetHelpFile('');

  Link.cbStruct := SizeOf(THH_AKLink);
  Link.pszKeywords := PChar(HelpString);
  Link.fReserved := false;
  Link.pszUrl := nil;
  Link.pszMsgText := nil;
  Link.pszMsgTitle := nil;
  Link.pszWindow := nil;
  Link.fIndexOnFail := True;

  LookupKeyword(HelpManager.GetHandle, FileName, @Link);
end;

{ NotifyID is called by the Help Manager after a successful registration
  to provide the Help Viewer with a cookie which uniquely identifies the
  Viewer to the Manager, and can be used in communications between the two. }

procedure THtmlHelpViewer.NotifyId(const ViewerId: Integer);
begin
  FViewerID := ViewerID;
end;

{ SoftShutDown is called by the help manager to ask the viewer to
  terminate any externally spawned subsystem without shutting itself down. }
procedure THtmlHelpViewer.SoftShutDown;
begin
  if FInitialized then
  begin
    HtmlHelp(0, '', HH_CLOSE_ALL, 0);
    Sleep(0);
  end;  
end;

procedure THtmlHelpViewer.ShutDown;
begin
  SoftShutDown;
  if FInitialized then
  begin
    HtmlHelp(0, '', HH_UNINITIALIZE, DWORD_PTR(@FInitializedCookie));
    FInitialized := false;
    FInitializedCookie := 0;
  end;
  if Assigned(FHelpManager) then
    HelpManager := nil;
  if Assigned(HtmlHelpTester) then
    HtmlHelpTester := nil;
end;

{ IExtendedHelpViewer }

{ UnderstandsTopic is called by the Help Manager to ask if the Viewer
  is capable of displaying a topic-based help query for a given topic.
  It's default behavior is to say 'yes'. }

function THtmlHelpVIewer.UnderstandsTopic(const Topic: string): Boolean;
var
  HelpFile: string;
begin;
  HelpFile := GetHelpFile('');
  if Assigned(HtmlHelpTester) then
    Result := HtmlHelpTester.CanShowTopic(Topic, HelpFile)
  else
    Result := True;
end;

{ DisplayTopic is called by the Help Manager if a Help Viewer claims
  in its response to UnderstandsTopic to be able to provide Topic-based
  help for a particular keyword. }

procedure THtmlHelpViewer.DisplayTopic(const Topic: string);
const
  InvokeSep = '::/';
  InvokeSuf = '.htm';
var
  HelpFile: string;
  InvocationString: string;
begin
  ValidateHelpViewer;
  HelpFile := GetHelpFile('');
  InvocationString := HelpFile + InvokeSep + Topic + InvokeSuf;
  HtmlHelp(HWND(HelpManager.GetHandle), InvocationString, HH_DISPLAY_TOPIC, 0);
end;

{ UnderstandsContext is a querying function called by the Help Manager
  to determine if an Extended Help Viewer is capable of providing
  help for a particular context-ID. Like all querying functions in
  this file, the default behavior is to say 'yes' unless overridden by
  a Tester. }

function THtmlHelpViewer.UnderstandsContext(const ContextId: Integer;
                                            const HelpFileName: string): Boolean;
begin
  Result := True;
  if Assigned(HtmlHelpTester) then
     Result := HtmlHelpTester.CanShowContext(ContextId, GetHelpFile(HelpFileName));
end;

{ DisplayHelpByContext is used by the Help Manager to request that a
  Help Viewer display help for a particular Context-ID. It is only
  invoked after a successful call to CanShowContext. }

procedure THtmlHelpviewer.DisplayHelpByContext(const ContextId: Integer; const HelpFileName: string);
var
  Handle: HWND;
  FileName: string;
begin
  ValidateHelpViewer;
  FileName := GetHelpFile(HelpFileName);
  Handle := HWND(HelpManager.GetHandle);
  SynchTopic(Handle, FileName);
  HtmlHelp(Handle, FileName, HH_HELP_CONTEXT, ContextId);
end;

type
  THelpManagerWrapper = class(TObject, IHelpManager)
  private
    FHandle: HWND;
    FFileName: String;
    FWrappedHM: IHelpManager;
  protected
    { IInterface }
    function QueryInterface(const IID: TGUID; out Obj): HResult; virtual; stdcall;
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;

    { IHelpManager }
    function  GetHandle: {$IFDEF LongintGetHandle}Longint{$ELSE}THandle{$ENDIF}; { sizeof(LongInt) = sizeof (HWND) }
    function  GetHelpFile: String;
    procedure Release(const ViewerID: Integer);
  public
    constructor Create(const AHelpManager: IHelpManager; const AHandle: HWND; const AFileName: String);

    property WrapperHM: IHelpManager read FWrappedHM;
    property HelpHandle: HWND read FHandle write FHandle;
    property HelpFile: String read FFileName write FFileName;
  end;

{ THelpManagerWrapper }

constructor THelpManagerWrapper.Create(const AHelpManager: IHelpManager; const AHandle: HWND; const AFileName: String);
begin
  inherited Create;

  FHandle := AHandle;
  FFileName := AFileName;
  FWrappedHM := AHelpManager;
end;

function THelpManagerWrapper.GetHandle: {$IFDEF LongintGetHandle}Longint{$ELSE}THandle{$ENDIF};
begin
  Result := {$IFDEF LongintGetHandle}Longint{$ELSE}THandle{$ENDIF}(FHandle);
end;

function THelpManagerWrapper.GetHelpFile: String;
begin
  Result := FFileName;
end;

procedure THelpManagerWrapper.Release(const ViewerID: Integer);
begin
  FWrappedHM.Release(ViewerID);
end;

function THelpManagerWrapper.QueryInterface(const IID: TGUID; out Obj): HResult;
begin
  if GetInterface(IID, Obj) then
    Result := S_OK
  else
    Result := E_NOINTERFACE
end;

function THelpManagerWrapper._AddRef: Integer;
begin
  Result := -1;
end;

function THelpManagerWrapper._Release: Integer;
begin
  Result := -1;
end;

{$IFNDEF HasStrUtils}
procedure FreeAndNil(var Obj);
var
  Temp: TObject;
begin
  Temp := TObject(Obj);
  Pointer(Obj) := nil;
  Temp.Free;
end;
{$ENDIF}

function PerformHLPCmd(Command: Word; Data: DWORD_PTR; var CallHelp: Boolean; const ADefHandle: HWND; const ADefHelpFile: String): Boolean;

  {$IFNDEF HasStrUtils}
  function AnsiStartsText(const ASubText, AText: string): Boolean;
  var
    P: PChar;
    L, L2: Integer;
  begin
    P := PChar(AText);
    L := Length(ASubText);
    L2 := Length(AText);
    if L > L2 then
      Result := False
    else
      Result := CompareString(LOCALE_USER_DEFAULT, NORM_IGNORECASE, P, L, PChar(ASubText), L) = 2;
  end;

  function AnsiEndsText(const ASubText, AText: string): Boolean;

    function AnsiStrIComp(S1, S2: PChar): Integer;
    begin
      Result := CompareString(LOCALE_USER_DEFAULT, NORM_IGNORECASE, S1, -1, S2, -1) - 2;
    end;

  var
    SubTextLocation: Integer;
  begin
    SubTextLocation := Length(AText) - Length(ASubText) + 1;
    Result := SubTextLocation <= 0;
    if not Result and (ASubText <> '') and (ByteType(AText, SubTextLocation) <> mbTrailByte) then
    begin
      Result := AnsiStrIComp(Pointer(ASubText), Pointer(@AText[SubTextLocation])) = 0;
    end;
  end;
  {$ENDIF}

var
  HelpHandle: HWND;
  HelpFile: String;

  procedure GetParams;
  begin
    HelpHandle := ADefHandle;
    HelpFile := ADefHelpFile;
    if (HelpHandle <> 0) or (HelpFile <> '') then
      Exit;

    if Assigned(HelpViewer.HelpManager) then
    begin
      HelpHandle := HelpViewer.HelpManager.GetHandle;
      HelpFile := HelpViewer.HelpManager.GetHelpFile;
      if HelpFile <> '' then
        Exit;
    end
    else
    begin
      HelpHandle := 0;
      HelpFile := '';
    end;

    if Assigned(Screen.ActiveForm) and Screen.ActiveForm.HandleAllocated then
    begin
      if HelpHandle = 0 then
        HelpHandle := Screen.ActiveForm.Handle;
      if (HelpFile = '') and (Screen.ActiveForm.HelpFile <> '') then
        HelpFile := Screen.ActiveForm.HelpFile;
    end;

    if HelpHandle = 0 then
    begin
      HelpHandle := Application.Handle;
      if Application.MainForm <> nil then
        HelpHandle := Application.MainForm.Handle;
    end;

    if HelpFile = '' then
      HelpFile := Application.HelpFile;
  end;

  procedure PositionWnd(const AWndInfo: THelpWinInfo); overload;
  var
    WndName: String;
    Wnd: HWND;
  begin
    SetLength(WndName, AWndInfo.wStructSize - (SizeOf(AWndInfo) - SizeOf(AWndInfo.rgchMember)) div SizeOf(Char));
    Move(AWndInfo.rgchMember[0], Pointer(WndName)^, Length(WndName) * SizeOf(Char));
    WndName := PChar(WndName);

    Wnd := HelpViewer.CallHtmlHelp(HelpHandle, HelpFile, HH_GET_WIN_HANDLE, Cardinal(Pointer(WndName)));
    if Wnd <> 0 then
    begin
      SetWindowPos(Wnd, HWND_TOP, AWndInfo.x, AWndInfo.y, AWndInfo.dx, AWndInfo.dy, SWP_SHOWWINDOW);
      ShowWindow(Wnd, AWndInfo.wMax);
    end;
  end;

  procedure PositionWnd(const AWidth, AHeight: Integer); overload;
  var
    Wnd: HWND;
    Pt: TPoint;
  begin
    if not GetCursorPos(Pt) then
      Exit;
    Wnd := HelpViewer.CallHtmlHelp(HelpHandle, HelpFile, HH_GET_WIN_HANDLE, 0);
    if Wnd <> 0 then
      SetWindowPos(Wnd, HWND_TOP, Pt.X, Pt.Y, AWidth, AHeight, SWP_SHOWWINDOW);
  end;

  procedure ProcessCommand(Data: Longint);

    function GetArg(const ACmd: String): String;
    var
      X: Integer;
    begin
      Result := ACmd;

      X := Pos('(', Result);
      if X > 0 then
      begin
        Result := Trim(Copy(Result, X + 1, MaxInt));
        if (Result <> '') and (Result[Length(Result)] = ')') then
          SetLength(Result, Length(Result) - 1);
      end;

      if (Length(Result) > 2) and
         (Result[1] = '"') and
         (Result[Length(Result)] = '"') then
        Result := Copy(Result, 2, Length(Result) - 2);
    end;

  var
    DataStr: String;
  begin
    DataStr := PChar(Data);

    if AnsiStartsText('SEARCH(', DataStr) then
      HelpViewer.DisplayIndex(GetArg(DataStr))
    else
    if AnsiStartsText('FIND(', DataStr) then
      HelpViewer.DisplaySearch(GetArg(DataStr))
    else
    if AnsiStartsText('JumpID("",', DataStr) then
      HelpViewer.DisplayTopic(GetArg('(' + Copy(DataStr, 11, MaxInt)))
    else
    if AnsiStartsText('JI(', DataStr) then
      HelpViewer.DisplayTopic(GetArg(DataStr))
    else
    if AnsiStartsText('::\', DataStr) or
       AnsiStartsText('::/', DataStr) then
      HelpViewer.DisplayTopic(ChangeFileExt(Copy(DataStr, 4, MaxInt), ''))
    else
    if AnsiEndsText('.htm', DataStr) or
       AnsiEndsText('.html', DataStr) then
      HelpViewer.DisplayTopic(ChangeFileExt(DataStr, ''))
    else
      HelpViewer.ShowHelp(DataStr);
  end;

var
  HMW: THelpManagerWrapper;
begin
  GetParams;

  if (HelpFile = '') or (HelpViewer = nil) then
  begin
    CallHelp := False;
    Result := False;
    Exit;
  end;

  HMW := THelpManagerWrapper.Create(HelpViewer.HelpManager, HelpHandle, HelpFile);
  try
    HelpViewer.HelpManager := HMW;

    try
      Result := True;
      CallHelp := False;

      case Command of
        HELP_CONTEXT:
          HelpViewer.DisplayHelpByContext(Data, HelpFile);
        HELP_QUIT:
          HelpViewer.SoftShutDown;
        HELP_CONTENTS:
          HelpViewer.CallHtmlHelp(HelpHandle, HelpFile, HH_DISPLAY_TOC, 0);
        HELP_CONTEXTPOPUP:
          HelpViewer.DisplayHelpByContext(Data, HelpFile);
        HELP_KEY:
          HelpViewer.DisplayIndex(PChar(Data));
        HELP_PARTIALKEY:
          HelpViewer.ShowHelp(PChar(Data));
        HELP_SETWINPOS:
          PositionWnd(THelpWinInfo(Pointer(Data)^));
        HELP_CONTEXTMENU:
        begin
          if Pos('::', HelpFile) <= 0 then
          begin
            HelpFile := HelpFile + '::/popups\cshelp.txt';
            HMW.HelpFile := HelpFile;
          end;
          HelpViewer.CallHtmlHelp(HelpHandle, HelpFile, HH_TP_HELP_CONTEXTMENU, Data);
        end;
        HELP_FINDER:
          HelpViewer.DisplayHelpByContext(0, HelpFile);
        HELP_WM_HELP:
        begin
          if Pos('::', HelpFile) <= 0 then
          begin
            HelpFile := HelpFile + '::/popups\cshelp.txt';
            HMW.HelpFile := HelpFile;
          end;
          HelpViewer.CallHtmlHelp(HelpHandle, HelpFile, HH_TP_HELP_WM_HELP, Data);
        end;
        HELP_SETPOPUP_POS:
          PositionWnd(Data and $FFFF, Data shr 16);
        HELP_TAB:
          HelpViewer.CallHtmlHelp(HelpHandle, HelpFile, HH_DISPLAY_TOC, 0);
        HELP_COMMAND:
          ProcessCommand(Data);
        // Not applicable:
        HELP_FORCEFILE, HELP_MULTIKEY:
          CallHelp := False;
      else
        // HELP_TCARD:
        // HELP_TCARD_DATA:
        // HELP_TCARD_OTHER_CALLER:
        // HELP_HELPONHELP:
        // HELP_SETINDEX:
        // HELP_SETCONTENTS:
        CallHelp := True;
      end;

    finally
      HelpViewer.HelpManager := HMW.WrapperHM;
    end;
  finally
    FreeAndNil(HMW);
  end;
end;

{ ISpecialWinHelpViewer }

{ This function reveals a design flaw in the D6/7 help system. :(
  ISpecialWinHelpViewer.CallWinHelp is intended to allow third-party
  help systems to process WinHelp messages which were not generalizable
  by the system designer. In this case, the expected behavior would be
  to convert WinHelp messages into HtmlHelp messages and forward them
  along.

  However, the same necessity that compels developers to be able to send
  non-generalizable winhelp messages also compels the ability to send
  non-generalizable htmlhelp messages. There is no mechanism in the 
  existing architecture to do that.

  The function signature for WinHelp() and HtmlHelp() are sufficiently
  similar, however, to allow the function to multiplex. Depending on the
  answer provided by an implementation of IHtmlHelpTester, the function
  will either convert messages (under the assumption that they are
  WinHelp messages) or pass them through (under the assumption that they
  are HtmlHelp messages).

  The need for this should be resolved in the next revision of the RTL, but 
  this function will continue to behave that way for purposes of backwards
  compatability. }

function THtmlHelpViewer.CallWinHelp(Handle: {$IFDEF LongintGetHandle}Longint{$ELSE}THandle{$ENDIF}; const HelpFileName: string; Command: Word; Data: {$IFDEF LongintGetHandle}Longint{$ELSE}NativeUInt{$ENDIF}): Boolean;
var
  Converted : Boolean;
  FileName: string;
begin
  ValidateHelpViewer;
  Result := False;
  FileName := GetHelpFile(HelpFileName);
  if FileName <> '' then
  begin
    if Assigned(HtmlHelpTester) then
      Converted := HtmlHelpTester.ConvertWinHelp(Command, DWORD_PTR(Data))
    else
      Converted := False;

    if not Converted then
    begin
      Converted := True;
      PerformHLPCmd(Command, DWORD_PTR(Data), Converted, HWND(Handle), HelpFileName);
      Converted := not Converted;
      if not Converted then
        Exit;
    end
    else
    begin
      CallHtmlHelp(HWND(Handle), FileName, Command, DWORD_PTR(Data));
      if Command = HH_CLOSE_ALL then
        Sleep(0);
    end;
    Result := True;
  end;
end;

{ ISpecialHtmlHelpViewer }

function THtmlHelpViewer.CallHtmlHelp(Handle: HWND; HelpFileName: string; Command: Integer; Data: DWORD_PTR): HWND;
begin
  ValidateHelpViewer;
  Result := 0;
  case Command of
    HH_CLOSE_ALL:
    begin
      SoftShutDown;
      Sleep(0);
    end;
    HH_DISPLAY_TEXT_POPUP:
    begin
      DisplayTextPopup(Handle, PHH_Popup(Data));
    end;
    HH_HELP_CONTEXT:
    begin
      DisplayHelpByContext(Data, HelpFileName);
    end;
    HH_ALINK_LOOKUP:
    begin
      LookupALink(Handle, HelpFileName, PHH_AkLink(Data));
    end;
    { DisplayIndex, DisplaySearch, DisplayToc }
  else
    begin
      SynchTopic(Handle, HelpFileName);
      Result := HtmlHelp(Handle, HelpFileName, Command, Data);
    end;
  end;
end;

{ IExtendedHelpViewer2 }

procedure THtmlHelpViewer.DisplayIndex(const Topic: string);
var
  HelpFile: string;
begin
  ValidateHelpViewer;
  HelpFile := GetHelpFile('');
  HtmlHelp(HWND(HelpManager.GetHandle), HelpFile, HH_DISPLAY_INDEX, DWORD_PTR(Pointer(Topic)));
end;

procedure THtmlHelpViewer.DisplaySearch(const Topic: string);
var
  HelpFile: string;
  Query: HH_FTS_QUERY;
begin
  ValidateHelpViewer;
  HelpFile := GetHelpFile('');

  FillChar(Query, SizeOf(Query), 0);
  Query.cbStruct := SizeOf(Query);
  Query.pszSearchQuery := PChar(Topic);
  {$IFDEF UNICODE}
  Query.fUniCodeStrings := True;
  {$ENDIF}
  Query.iProximity := -1;
  Query.fStemmedSearch := False;
  Query.fTitleOnly := False;
  Query.fExecute := True;
  Query.pszWindow := nil;


  //Note: There is a bug in the Windows SDK call HtmlHelp().  Even though
  //  fExecute is set to true, the search is not executed. The following
  //  webpage has more info:
  //  http://support.microsoft.com/kb/q241381/
  HtmlHelp(HWND(HelpManager.GetHandle), HelpFile, HH_DISPLAY_SEARCH, DWORD_PTR(@Query));
end;

procedure THtmlHelpViewer.DisplayTopic(const Topic, Anchor: string);
const
  InvokeSep = '::/';
  InvokeSuf = '.htm';
  AnchorSep = '#';
var
  HelpFile: string;
  InvocationString: string;
begin
  ValidateHelpViewer;
  HelpFile := GetHelpFile('');
  InvocationString := HelpFile + InvokeSep + Topic + InvokeSuf + AnchorSep + Anchor;
  HtmlHelp(HWND(HelpManager.GetHandle), InvocationString, HH_DISPLAY_TOPIC, 0);
end;

{ IPopupHelp }

procedure THtmlHelpViewer.SetupPopupWindow(TopCenter: TPoint; 
                                           Foreground, Background: DWord; 
                                           Margins: TRect; 
                                           const FontDesc: string);
begin
  Self.TopCenter := TopCenter;
  Self.Foreground := Foreground;
  Self.Background := Background;
  Self.Margins := Margins;
  Self.FontDesc := FontDesc;
end;

procedure THtmlHelpVIewer.SetupPopupSource(Handle: HWND; ID: LongInt;
                                           const Text: string);
begin
 Self.PopupResourceHandle := Handle;
 Self.PopupResourceId := ID;
 Self.PopupText := Text;
end;

procedure THtmlHelpViewer.Popup(KeepWindowSetup: Boolean; 
                                KeepSourceSetup: Boolean);
begin
  { execute popup call }
  if not KeepWindowSetup then
  begin
  end;
  if not KeepSourceSetup then
  begin
  end;
end;

procedure THtmlHelpViewer.ClearSetup;
begin

end;

{==========================================================================}

procedure THtmlHelpViewer.SynchTopic(Handle: HWND; const HelpFileName: string);
begin
  HtmlHelp(Handle, HelpFileName, HH_DISPLAY_TOPIC, 0);
end;

procedure THtmlHelpViewer.LookupALink(Handle: HWND; const HelpFileName: string; LinkPtr: PHH_AkLink);
begin
  HtmlHelp(Handle, HelpFileName, HH_ALINK_LOOKUP, DWORD_PTR(LinkPtr));
end;

procedure THtmlHelpViewer.LookupKeyword(Handle: HWND; const HelpFileName: string; LinkPtr: PHH_AkLink);
begin
  HtmlHelp(Handle, HelpFileName, HH_KEYWORD_LOOKUP, DWORD_PTR(LinkPtr));
end;

procedure THtmlHelpViewer.DisplayTextPopup(Handle: HWND; Data: PHH_Popup);
var
  FileName: string;
begin
  HtmlHelp(Handle, FileName, HH_DISPLAY_TEXT_POPUP, DWORD_PTR(Data));
end;

constructor THtmlHelpViewer.Create;
begin
  inherited Create;
  {$IFDEF HasHelpIntfs}
  HelpViewerIntf := Self;
  {$ENDIF}
  FInitialized := False;
  FInitializedCookie := 0;
  ClearSetup;
end;

destructor THtmlHelpViewer.Destroy;
begin
  HelpViewer := nil;
  inherited Destroy;
end;

function THtmlHelpViewer.GetHelpFile(const Name: string): string;
var
  FileName: string;
begin
  Result := '';
  if (Name = '') and Assigned(FHelpManager) then
    FileName := HelpManager.GetHelpFile
  else
    FileName := Name;

  if (FileName = '') and Assigned(HtmlHelpTester) then 
    FileName := HtmlHelpTester.GetDefaultHelpFile;

  if Assigned(HtmlHelpTester) then
    FileName := HtmlHelpTester.GetHelpPath + PathDelim + FileName;

  Result := FileName;
end;

procedure THtmlHelpViewer.InternalShutDown;
begin
  SoftShutDown;
  if Assigned(FHelpManager) then
  begin
    HelpManager.Release(ViewerID);
    HelpManager := nil;
  end;
end;

{$IFDEF DisableWinHelp}

type
  TWinHelpDisabler = class(TInterfacedObject, IWinHelpTester)
  public
    function CanShowALink(const ALink, FileName: string): Boolean;
    function CanShowTopic(const Topic, FileName: string): Boolean;
    function CanShowContext(const Context: Integer; const FileName: string): Boolean;
    function GetHelpStrings(const ALink: string): TStringList;
    function GetHelpPath : string;
    function GetDefaultHelpFile: string;
  end;

{ TWinHelpDisabler }

function TWinHelpDisabler.CanShowALink(const ALink, FileName: string): Boolean;
begin
  Result := False;
end;

function TWinHelpDisabler.CanShowContext(const Context: Integer; const FileName: string): Boolean;
begin
  Result := False;
end;

function TWinHelpDisabler.CanShowTopic(const Topic, FileName: string): Boolean;
begin
  Result := False;
end;

function TWinHelpDisabler.GetDefaultHelpFile: string;
begin
  Result := '';
end;

function TWinHelpDisabler.GetHelpPath: string;
begin
  Result := '';
end;

function TWinHelpDisabler.GetHelpStrings(const ALink: string): TStringList;
begin
  Result := nil;
end;

{$ENDIF}

type
  TDummy = class
    class procedure OnMessage(var Msg: TMsg; var Handled: Boolean);
    {$IFDEF OverrideOnHelp}
    class function OnHelp(Command: Word; Data: Longint; var CallHelp: Boolean): Boolean;
    {$ENDIF}
  end;

class procedure TDummy.OnMessage(var Msg: TMsg; var Handled: Boolean);
begin
  Handled := False;
  if HelpViewer = nil then
    Exit;
  if not HelpViewer.FInitialized then
    Exit;

  if HtmlHelp(0, '', HH_PRETRANSLATEMESSAGE, DWORD_PTR(@Msg)) <> 0 then
    Handled := True;
end;

{$IFDEF OverrideOnHelp}

{ TDummy }

class function TDummy.OnHelp(Command: Word; Data: Integer; var CallHelp: Boolean): Boolean;
begin
  Result := PerformHLPCmd(Command, Data, CallHelp, 0, '');
end;

{$ENDIF}

initialization
  {$IFNDEF HasGet8087CW}
  Set8087CW(Default8087CW);
  {$ENDIF}
  HtmlHelpModule := 0;
  {$IFDEF DisableWinHelp}
  if not Assigned(WinHelpViewer.WinHelpTester) then
    WinHelpViewer.WinHelpTester := TWinHelpDisabler.Create;
  {$ENDIF}
  HelpViewer := THtmlHelpViewer.Create;
  Application.OnMessage := TDummy.OnMessage;
  {$IFDEF HasHelpIntfs}
  HelpIntfs.RegisterViewer(HelpViewerIntf, HelpViewer.FHelpManager);
  {$ENDIF}
  {$IFDEF OverrideOnHelp}
  Application.OnHelp := TDummy.OnHelp;
  {$ENDIF}

finalization
  if Assigned(HelpViewer.HelpManager) then
    HelpViewer.InternalShutDown
  else
    HelpViewer.SoftShutDown;
  HelpViewer.ShutDown;
  {$IFDEF HasHelpIntfs}
  HelpViewerIntf := nil;
  {$ELSE}
  FreeAndNil(HelpViewer);
  {$ENDIF}
  {$IFDEF DisableWinHelp}
  WinHelpViewer.WinHelpTester := nil;
  {$ENDIF}
  {$IFDEF OverrideOnHelp}
  Application.OnHelp := nil;
  {$ENDIF}
  Application.OnMessage := nil;
  HtmlHelpTester := nil;
  HtmlHelpModule := 0;

end.
