/***********************************************************************\
*                                 ras.d                                 *
*                                                                       *
*                       Windows API header module                       *
*                                                                       *
*                 Translated from MinGW Windows headers                 *
*                                                                       *
*                       Placed into public domain                       *
\***********************************************************************/
module win32.ras;
pragma(lib, "rasapi32");

private import win32.basetyps, win32.lmcons, win32.w32api, win32.windef;

align(4):

const RAS_MaxDeviceType = 16;
const RAS_MaxPhoneNumber = 128;
const RAS_MaxIpAddress = 15;
const RAS_MaxIpxAddress = 21;
const RAS_MaxEntryName = 256;
const RAS_MaxDeviceName = 128;
const RAS_MaxCallbackNumber = RAS_MaxPhoneNumber;
const RAS_MaxAreaCode = 10;
const RAS_MaxPadType = 32;
const RAS_MaxX25Address = 200;
const RAS_MaxFacilities = 200;
const RAS_MaxUserData = 200;
const RAS_MaxReplyMessage = 1024;

const RDEOPT_UsePrefixSuffix           = 0x00000001;
const RDEOPT_PausedStates              = 0x00000002;
const RDEOPT_IgnoreModemSpeaker        = 0x00000004;
const RDEOPT_SetModemSpeaker           = 0x00000008;
const RDEOPT_IgnoreSoftwareCompression = 0x00000010;
const RDEOPT_SetSoftwareCompression    = 0x00000020;
const RDEOPT_DisableConnectedUI        = 0x00000040;
const RDEOPT_DisableReconnectUI        = 0x00000080;
const RDEOPT_DisableReconnect          = 0x00000100;
const RDEOPT_NoUser                    = 0x00000200;
const RDEOPT_PauseOnScript             = 0x00000400;
const RDEOPT_Router                    = 0x00000800;

const REN_User = 0x00000000;
const REN_AllUsers = 0x00000001;
const VS_Default = 0;
const VS_PptpOnly = 1;
const VS_PptpFirst = 2;
const VS_L2tpOnly = 3;
const VS_L2tpFirst = 4;

const RASDIALEVENT = "RasDialEvent";
const WM_RASDIALEVENT = 0xCCCD;

const RASEO_UseCountryAndAreaCodes = 0x00000001;
const RASEO_SpecificIpAddr = 0x00000002;
const RASEO_SpecificNameServers = 0x00000004;
const RASEO_IpHeaderCompression = 0x00000008;
const RASEO_RemoteDefaultGateway = 0x00000010;
const RASEO_DisableLcpExtensions = 0x00000020;
const RASEO_TerminalBeforeDial = 0x00000040;
const RASEO_TerminalAfterDial = 0x00000080;
const RASEO_ModemLights = 0x00000100;
const RASEO_SwCompression = 0x00000200;
const RASEO_RequireEncryptedPw = 0x00000400;
const RASEO_RequireMsEncryptedPw = 0x00000800;
const RASEO_RequireDataEncryption = 0x00001000;
const RASEO_NetworkLogon = 0x00002000;
const RASEO_UseLogonCredentials = 0x00004000;
const RASEO_PromoteAlternates = 0x00008000;
const RASNP_NetBEUI = 0x00000001;
const RASNP_Ipx = 0x00000002;
const RASNP_Ip = 0x00000004;
const RASFP_Ppp = 0x00000001;
const RASFP_Slip = 0x00000002;
const RASFP_Ras = 0x00000004;

const TCHAR[]
	RASDT_Modem = "modem",
	RASDT_Isdn = "isdn",
	RASDT_X25 = "x25",
	RASDT_Vpn = "vpn",
	RASDT_Pad = "pad",
	RASDT_Generic = "GENERIC",
	RASDT_Serial = "SERIAL",
	RASDT_FrameRelay = "FRAMERELAY",
	RASDT_Atm = "ATM",
	RASDT_Sonet = "SONET",
	RASDT_SW56 = "SW56",
	RASDT_Irda = "IRDA",
	RASDT_Parallel = "PARALLEL";

const RASET_Phone = 1;
const RASET_Vpn = 2;
const RASET_Direct = 3;
const RASET_Internet = 4;

static if (_WIN32_WINNT >= 0x401) {
	const RASEO_SecureLocalFiles = 0x00010000;
	const RASCN_Connection = 0x00000001;
	const RASCN_Disconnection = 0x00000002;
	const RASCN_BandwidthAdded = 0x00000004;
	const RASCN_BandwidthRemoved = 0x00000008;
	const RASEDM_DialAll = 1;
	const RASEDM_DialAsNeeded = 2;
	const RASIDS_Disabled = 0xffffffff;
	const RASIDS_UseGlobalValue = 0;
	const RASADFLG_PositionDlg = 0x00000001;
	const RASCM_UserName = 0x00000001;
	const RASCM_Password = 0x00000002;
	const RASCM_Domain = 0x00000004;
	const RASADP_DisableConnectionQuery = 0;
	const RASADP_LoginSessionDisable = 1;
	const RASADP_SavedAddressesLimit = 2;
	const RASADP_FailedConnectionTimeout = 3;
	const RASADP_ConnectionQueryTimeout = 4;
}
static if (_WIN32_WINNT >= 0x500) {
	const RDEOPT_CustomDial = 0x00001000;
	const RASLCPAP_PAP = 0xC023;
	const RASLCPAP_SPAP = 0xC027;
	const RASLCPAP_CHAP = 0xC223;
	const RASLCPAP_EAP = 0xC227;
	const RASLCPAD_CHAP_MD5 = 0x05;
	const RASLCPAD_CHAP_MS = 0x80;
	const RASLCPAD_CHAP_MSV2 = 0x81;
	const RASLCPO_PFC    = 0x00000001;
	const RASLCPO_ACFC   = 0x00000002;
	const RASLCPO_SSHF   = 0x00000004;
	const RASLCPO_DES_56 = 0x00000008;
	const RASLCPO_3_DES  = 0x00000010;

	const RASCCPCA_MPPC = 0x00000006;
	const RASCCPCA_STAC = 0x00000005;

	const RASCCPO_Compression      = 0x00000001;
	const RASCCPO_HistoryLess      = 0x00000002;
	const RASCCPO_Encryption56bit  = 0x00000010;
	const RASCCPO_Encryption40bit  = 0x00000020;
	const RASCCPO_Encryption128bit = 0x00000040;

	const RASEO_RequireEAP          = 0x00020000;
	const RASEO_RequirePAP          = 0x00040000;
	const RASEO_RequireSPAP         = 0x00080000;
	const RASEO_Custom              = 0x00100000;
	const RASEO_PreviewPhoneNumber  = 0x00200000;
	const RASEO_SharedPhoneNumbers  = 0x00800000;
	const RASEO_PreviewUserPw       = 0x01000000;
	const RASEO_PreviewDomain       = 0x02000000;
	const RASEO_ShowDialingProgress = 0x04000000;
	const RASEO_RequireCHAP         = 0x08000000;
	const RASEO_RequireMsCHAP       = 0x10000000;
	const RASEO_RequireMsCHAP2      = 0x20000000;
	const RASEO_RequireW95MSCHAP    = 0x40000000;
	const RASEO_CustomScript        = 0x80000000;

	const RASIPO_VJ = 0x00000001;
	const RCD_SingleUser = 0;
	const RCD_AllUsers = 0x00000001;
	const RCD_Eap = 0x00000002;
	const RASEAPF_NonInteractive = 0x00000002;
	const RASEAPF_Logon = 0x00000004;
	const RASEAPF_Preview = 0x00000008;
	const ET_40Bit = 1;
	const ET_128Bit = 2;
	const ET_None = 0;
	const ET_Require = 1;
	const ET_RequireMax = 2;
	const ET_Optional = 3;
}

const RASCS_PAUSED = 0x1000;
const RASCS_DONE = 0x2000;
enum RASCONNSTATE {
	RASCS_OpenPort = 0,
	RASCS_PortOpened,
	RASCS_ConnectDevice,
	RASCS_DeviceConnected,
	RASCS_AllDevicesConnected,
	RASCS_Authenticate,
	RASCS_AuthNotify,
	RASCS_AuthRetry,
	RASCS_AuthCallback,
	RASCS_AuthChangePassword,
	RASCS_AuthProject,
	RASCS_AuthLinkSpeed,
	RASCS_AuthAck,
	RASCS_ReAuthenticate,
	RASCS_Authenticated,
	RASCS_PrepareForCallback,
	RASCS_WaitForModemReset,
	RASCS_WaitForCallback,
	RASCS_Projected,
	RASCS_StartAuthentication,
	RASCS_CallbackComplete,
	RASCS_LogonNetwork,
	RASCS_SubEntryConnected,
	RASCS_SubEntryDisconnected,
	RASCS_Interactive = RASCS_PAUSED,
	RASCS_RetryAuthentication,
	RASCS_CallbackSetByCaller,
	RASCS_PasswordExpired,
//	static if (_WIN32_WINNT >= 0x500) {
		RASCS_InvokeEapUI,
//	}
	RASCS_Connected = RASCS_DONE,
	RASCS_Disconnected
}
alias RASCONNSTATE* LPRASCONNSTATE;

enum RASPROJECTION {
	RASP_Amb =      0x10000,
	RASP_PppNbf =   0x803F,
	RASP_PppIpx =   0x802B,
	RASP_PppIp =    0x8021,
//	static if (_WIN32_WINNT >= 0x500) {
		RASP_PppCcp =   0x80FD,
//	}
	RASP_PppLcp =   0xC021,
	RASP_Slip =     0x20000
}
alias RASPROJECTION* LPRASPROJECTION;

alias TypeDef!(HANDLE) HRASCONN;
alias HRASCONN* LPHRASCONN;

struct RASCONNW {
	DWORD dwSize;
	HRASCONN hrasconn;
	WCHAR[RAS_MaxEntryName + 1] szEntryName;
	WCHAR[RAS_MaxDeviceType + 1] szDeviceType;
	WCHAR[RAS_MaxDeviceName + 1] szDeviceName;
	static if (_WIN32_WINNT >= 0x401) {
		WCHAR[MAX_PATH] szPhonebook;
		DWORD dwSubEntry;
	}
	static if (_WIN32_WINNT >= 0x500) {
		GUID guidEntry;
	}
	static if (_WIN32_WINNT >= 0x501) {
		DWORD dwFlags;
		LUID luid;
	}
}
alias RASCONNW* LPRASCONNW;

struct RASCONNA {
	DWORD dwSize;
	HRASCONN hrasconn;
	CHAR[RAS_MaxEntryName + 1] szEntryName;
	CHAR[RAS_MaxDeviceType + 1] szDeviceType;
	CHAR[RAS_MaxDeviceName + 1] szDeviceName;
	static if (_WIN32_WINNT >= 0x401) {
		CHAR[MAX_PATH] szPhonebook;
		DWORD dwSubEntry;
	}
	static if (_WIN32_WINNT >= 0x500) {
		GUID guidEntry;
	}
	static if (_WIN32_WINNT >= 0x501) {
		DWORD dwFlags;
		LUID luid;
	}
}
alias RASCONNA* LPRASCONNA;

struct RASCONNSTATUSW {
	DWORD dwSize;
	RASCONNSTATE rasconnstate;
	DWORD dwError;
	WCHAR[RAS_MaxDeviceType + 1] szDeviceType;
	WCHAR[RAS_MaxDeviceName + 1] szDeviceName;
	static if (_WIN32_WINNT >= 0x401) {
		WCHAR[RAS_MaxPhoneNumber + 1] szPhoneNumber;
	}
}
alias RASCONNSTATUSW* LPRASCONNSTATUSW;

struct RASCONNSTATUSA {
	DWORD dwSize;
	RASCONNSTATE rasconnstate;
	DWORD dwError;
	CHAR[RAS_MaxDeviceType + 1] szDeviceType;
	CHAR[RAS_MaxDeviceName + 1] szDeviceName;
	static if (_WIN32_WINNT >= 0x401) {
		CHAR[RAS_MaxPhoneNumber + 1] szPhoneNumber;
	}
}
alias RASCONNSTATUSA* LPRASCONNSTATUSA;

struct RASDIALPARAMSW {
	DWORD dwSize;
	WCHAR[RAS_MaxEntryName + 1] szEntryName;
	WCHAR[RAS_MaxPhoneNumber + 1] szPhoneNumber;
	WCHAR[RAS_MaxCallbackNumber + 1] szCallbackNumber;
	WCHAR[UNLEN + 1] szUserName;
	WCHAR[PWLEN + 1] szPassword;
	WCHAR[DNLEN + 1] szDomain;
	static if (_WIN32_WINNT >= 0x401) {
		DWORD dwSubEntry;
		ULONG_PTR dwCallbackId;
	}
}
alias RASDIALPARAMSW* LPRASDIALPARAMSW;

struct RASDIALPARAMSA{
	DWORD dwSize;
	CHAR[RAS_MaxEntryName + 1] szEntryName;
	CHAR[RAS_MaxPhoneNumber + 1] szPhoneNumber;
	CHAR[RAS_MaxCallbackNumber + 1] szCallbackNumber;
	CHAR[UNLEN + 1] szUserName;
	CHAR[PWLEN + 1] szPassword;
	CHAR[DNLEN + 1] szDomain;
	static if (_WIN32_WINNT >= 0x401) {
		DWORD dwSubEntry;
		ULONG_PTR dwCallbackId;
	}
}
alias RASDIALPARAMSA* LPRASDIALPARAMSA;

static if (_WIN32_WINNT >= 0x500) {
	struct RASEAPINFO {
		DWORD dwSizeofEapInfo;
		BYTE *pbEapInfo;
	}
}

struct RASDIALEXTENSIONS {
	DWORD dwSize;
	DWORD dwfOptions;
	HWND hwndParent;
	ULONG_PTR reserved;
	static if (_WIN32_WINNT >= 0x500) {
		ULONG_PTR reserved1;
		RASEAPINFO RasEapInfo;
	}
}
alias RASDIALEXTENSIONS* LPRASDIALEXTENSIONS;

struct RASENTRYNAMEW {
	DWORD dwSize;
	WCHAR[RAS_MaxEntryName + 1] szEntryName;
	static if (_WIN32_WINNT >= 0x500) {
		DWORD dwFlags;
		WCHAR[MAX_PATH + 1] szPhonebookPath;
	}
}
alias RASENTRYNAMEW* LPRASENTRYNAMEW;

struct RASENTRYNAMEA{
	DWORD dwSize;
	CHAR[RAS_MaxEntryName + 1] szEntryName;
	static if (_WIN32_WINNT >= 0x500) {
		DWORD dwFlags;
		CHAR[MAX_PATH + 1] szPhonebookPath;
	}
}
alias RASENTRYNAMEA* LPRASENTRYNAMEA;

struct RASAMBW{
	DWORD dwSize;
	DWORD dwError;
	WCHAR[NETBIOS_NAME_LEN + 1] szNetBiosError;
	BYTE bLana;
}
alias RASAMBW* LPRASAMBW;

struct RASAMBA{
	DWORD dwSize;
	DWORD dwError;
	CHAR[NETBIOS_NAME_LEN + 1] szNetBiosError;
	BYTE bLana;
}
alias RASAMBA* LPRASAMBA;

struct RASPPPNBFW{
	DWORD dwSize;
	DWORD dwError;
	DWORD dwNetBiosError;
	WCHAR[NETBIOS_NAME_LEN + 1] szNetBiosError;
	WCHAR[NETBIOS_NAME_LEN + 1] szWorkstationName;
	BYTE bLana;
}
alias RASPPPNBFW* LPRASPPPNBFW;

struct RASPPPNBFA{
	DWORD dwSize;
	DWORD dwError;
	DWORD dwNetBiosError;
	CHAR[NETBIOS_NAME_LEN + 1] szNetBiosError;
	CHAR[NETBIOS_NAME_LEN + 1] szWorkstationName;
	BYTE bLana;
}
alias RASPPPNBFA* LPRASPPPNBFA;

struct RASPPPIPXW {
	DWORD dwSize;
	DWORD dwError;
	WCHAR[RAS_MaxIpxAddress + 1] szIpxAddress;
}
alias RASPPPIPXW* LPRASPPPIPXW;

struct RASPPPIPXA {
	DWORD dwSize;
	DWORD dwError;
	CHAR[RAS_MaxIpxAddress + 1] szIpxAddress;
}
alias RASPPPIPXA* LPRASPPPIPXA;

struct RASPPPIPW{
	DWORD dwSize;
	DWORD dwError;
	WCHAR[RAS_MaxIpAddress + 1] szIpAddress;
	//#ifndef WINNT35COMPATIBLE
	WCHAR[RAS_MaxIpAddress + 1] szServerIpAddress;
	//#endif
	static if (_WIN32_WINNT >= 0x500) {
		DWORD dwOptions;
		DWORD dwServerOptions;
	}
}
alias RASPPPIPW* LPRASPPPIPW;

struct RASPPPIPA{
	DWORD dwSize;
	DWORD dwError;
	CHAR[RAS_MaxIpAddress + 1] szIpAddress;
	//#ifndef WINNT35COMPATIBLE
	CHAR[RAS_MaxIpAddress + 1] szServerIpAddress;
	//#endif
	static if (_WIN32_WINNT >= 0x500) {
		DWORD dwOptions;
		DWORD dwServerOptions;
	}
}
alias RASPPPIPA* LPRASPPPIPA;

struct RASPPPLCPW{
	DWORD dwSize;
	BOOL fBundled;
	static if (_WIN32_WINNT >= 0x500) {
		DWORD dwError;
		DWORD dwAuthenticationProtocol;
		DWORD dwAuthenticationData;
		DWORD dwEapTypeId;
		DWORD dwServerAuthenticationProtocol;
		DWORD dwServerAuthenticationData;
		DWORD dwServerEapTypeId;
		BOOL fMultilink;
		DWORD dwTerminateReason;
		DWORD dwServerTerminateReason;
		WCHAR[RAS_MaxReplyMessage] szReplyMessage;
		DWORD dwOptions;
		DWORD dwServerOptions;
	}
}
alias RASPPPLCPW* LPRASPPPLCPW;

struct RASPPPLCPA{
	DWORD dwSize;
	BOOL fBundled;
	static if (_WIN32_WINNT >= 0x500) {
		DWORD dwError;
		DWORD dwAuthenticationProtocol;
		DWORD dwAuthenticationData;
		DWORD dwEapTypeId;
		DWORD dwServerAuthenticationProtocol;
		DWORD dwServerAuthenticationData;
		DWORD dwServerEapTypeId;
		BOOL fMultilink;
		DWORD dwTerminateReason;
		DWORD dwServerTerminateReason;
		CHAR[RAS_MaxReplyMessage] szReplyMessage;
		DWORD dwOptions;
		DWORD dwServerOptions;
	}
}
alias RASPPPLCPA* LPRASPPPLCPA;

struct RASSLIPW{
	DWORD dwSize;
	DWORD dwError;
	WCHAR[RAS_MaxIpAddress + 1] szIpAddress;
}
alias RASSLIPW* LPRASSLIPW;

struct RASSLIPA{
	DWORD dwSize;
	DWORD dwError;
	CHAR[RAS_MaxIpAddress + 1] szIpAddress;
}
alias RASSLIPA* LPRASSLIPA;

struct RASDEVINFOW{
	DWORD dwSize;
	WCHAR[RAS_MaxDeviceType + 1] szDeviceType;
	WCHAR[RAS_MaxDeviceName + 1] szDeviceName;
}
alias RASDEVINFOW* LPRASDEVINFOW;

struct RASDEVINFOA{
	DWORD dwSize;
	CHAR[RAS_MaxDeviceType + 1] szDeviceType;
	CHAR[RAS_MaxDeviceName + 1] szDeviceName;
}
alias RASDEVINFOA* LPRASDEVINFOA;

struct RASCTRYINFO {
	DWORD dwSize;
	DWORD dwCountryID;
	DWORD dwNextCountryID;
	DWORD dwCountryCode;
	DWORD dwCountryNameOffset;
}
alias RASCTRYINFO* LPRASCTRYINFO;
alias RASCTRYINFO  RASCTRYINFOW, RASCTRYINFOA;
alias RASCTRYINFOW* LPRASCTRYINFOW;
alias RASCTRYINFOA* LPRASCTRYINFOA;

struct RASIPADDR {
	BYTE a;
	BYTE b;
	BYTE c;
	BYTE d;
}

struct RASENTRYW {
	DWORD dwSize;
	DWORD dwfOptions;
	DWORD dwCountryID;
	DWORD dwCountryCode;
	WCHAR[RAS_MaxAreaCode + 1] szAreaCode;
	WCHAR[RAS_MaxPhoneNumber + 1] szLocalPhoneNumber;
	DWORD dwAlternateOffset;
	RASIPADDR ipaddr;
	RASIPADDR ipaddrDns;
	RASIPADDR ipaddrDnsAlt;
	RASIPADDR ipaddrWins;
	RASIPADDR ipaddrWinsAlt;
	DWORD dwFrameSize;
	DWORD dwfNetProtocols;
	DWORD dwFramingProtocol;
	WCHAR[MAX_PATH] szScript;
	WCHAR[MAX_PATH] szAutodialDll;
	WCHAR[MAX_PATH] szAutodialFunc;
	WCHAR[RAS_MaxDeviceType + 1] szDeviceType;
	WCHAR[RAS_MaxDeviceName + 1] szDeviceName;
	WCHAR[RAS_MaxPadType + 1] szX25PadType;
	WCHAR[RAS_MaxX25Address + 1] szX25Address;
	WCHAR[RAS_MaxFacilities + 1] szX25Facilities;
	WCHAR[RAS_MaxUserData + 1] szX25UserData;
	DWORD dwChannels;
	DWORD dwReserved1;
	DWORD dwReserved2;
	static if (_WIN32_WINNT >= 0x401) {
		DWORD dwSubEntries;
		DWORD dwDialMode;
		DWORD dwDialExtraPercent;
		DWORD dwDialExtraSampleSeconds;
		DWORD dwHangUpExtraPercent;
		DWORD dwHangUpExtraSampleSeconds;
		DWORD dwIdleDisconnectSeconds;
	}
	static if (_WIN32_WINNT >= 0x500) {
		DWORD dwType;
		DWORD dwEncryptionType;
		DWORD dwCustomAuthKey;
		GUID guidId;
		WCHAR[MAX_PATH] szCustomDialDll;
		DWORD dwVpnStrategy;
	}
}
alias RASENTRYW* LPRASENTRYW;

struct RASENTRYA {
	DWORD dwSize;
	DWORD dwfOptions;
	DWORD dwCountryID;
	DWORD dwCountryCode;
	CHAR[RAS_MaxAreaCode + 1] szAreaCode;
	CHAR[RAS_MaxPhoneNumber + 1] szLocalPhoneNumber;
	DWORD dwAlternateOffset;
	RASIPADDR ipaddr;
	RASIPADDR ipaddrDns;
	RASIPADDR ipaddrDnsAlt;
	RASIPADDR ipaddrWins;
	RASIPADDR ipaddrWinsAlt;
	DWORD dwFrameSize;
	DWORD dwfNetProtocols;
	DWORD dwFramingProtocol;
	CHAR[MAX_PATH] szScript;
	CHAR[MAX_PATH] szAutodialDll;
	CHAR[MAX_PATH] szAutodialFunc;
	CHAR[RAS_MaxDeviceType + 1] szDeviceType;
	CHAR[RAS_MaxDeviceName + 1] szDeviceName;
	CHAR[RAS_MaxPadType + 1] szX25PadType;
	CHAR[RAS_MaxX25Address + 1] szX25Address;
	CHAR[RAS_MaxFacilities + 1] szX25Facilities;
	CHAR[RAS_MaxUserData + 1] szX25UserData;
	DWORD dwChannels;
	DWORD dwReserved1;
	DWORD dwReserved2;
	static if (_WIN32_WINNT >= 0x401) {
		DWORD dwSubEntries;
		DWORD dwDialMode;
		DWORD dwDialExtraPercent;
		DWORD dwDialExtraSampleSeconds;
		DWORD dwHangUpExtraPercent;
		DWORD dwHangUpExtraSampleSeconds;
		DWORD dwIdleDisconnectSeconds;
	}
	static if (_WIN32_WINNT >= 0x500) {
		DWORD dwType;
		DWORD dwEncryptionType;
		DWORD dwCustomAuthKey;
		GUID guidId;
		CHAR[MAX_PATH] szCustomDialDll;
		DWORD dwVpnStrategy;
	}
}
alias RASENTRYA* LPRASENTRYA;


static if (_WIN32_WINNT >= 0x401) {
	struct RASADPARAMS {
		DWORD dwSize;
		HWND hwndOwner;
		DWORD dwFlags;
		LONG xDlg;
		LONG yDlg;
	}
	alias RASADPARAMS* LPRASADPARAMS;

	struct RASSUBENTRYW{
		DWORD dwSize;
		DWORD dwfFlags;
		WCHAR[RAS_MaxDeviceType + 1] szDeviceType;
		WCHAR[RAS_MaxDeviceName + 1] szDeviceName;
		WCHAR[RAS_MaxPhoneNumber + 1] szLocalPhoneNumber;
		DWORD dwAlternateOffset;
	}
	alias RASSUBENTRYW* LPRASSUBENTRYW;

	struct RASSUBENTRYA{
		DWORD dwSize;
		DWORD dwfFlags;
		CHAR[RAS_MaxDeviceType + 1] szDeviceType;
		CHAR[RAS_MaxDeviceName + 1] szDeviceName;
		CHAR[RAS_MaxPhoneNumber + 1] szLocalPhoneNumber;
		DWORD dwAlternateOffset;
	}
	alias RASSUBENTRYA* LPRASSUBENTRYA;

	struct RASCREDENTIALSW{
		DWORD dwSize;
		DWORD dwMask;
		WCHAR[UNLEN + 1] szUserName;
		WCHAR[PWLEN + 1] szPassword;
		WCHAR[DNLEN + 1] szDomain;
	}
	alias RASCREDENTIALSW* LPRASCREDENTIALSW;

	struct RASCREDENTIALSA{
		DWORD dwSize;
		DWORD dwMask;
		CHAR[UNLEN + 1] szUserName;
		CHAR[PWLEN + 1] szPassword;
		CHAR[DNLEN + 1] szDomain;
	}
	alias RASCREDENTIALSA* LPRASCREDENTIALSA;

	struct RASAUTODIALENTRYW{
		DWORD dwSize;
		DWORD dwFlags;
		DWORD dwDialingLocation;
		WCHAR[RAS_MaxEntryName + 1] szEntry;
	}
	alias RASAUTODIALENTRYW* LPRASAUTODIALENTRYW;

	struct RASAUTODIALENTRYA{
		DWORD dwSize;
		DWORD dwFlags;
		DWORD dwDialingLocation;
		CHAR[RAS_MaxEntryName + 1] szEntry;
	}
	alias RASAUTODIALENTRYA* LPRASAUTODIALENTRYA;
}

static if (_WIN32_WINNT >= 0x500) {
	struct RASPPPCCP{
		DWORD dwSize;
		DWORD dwError;
		DWORD dwCompressionAlgorithm;
		DWORD dwOptions;
		DWORD dwServerCompressionAlgorithm;
		DWORD dwServerOptions;
	}
	alias RASPPPCCP* LPRASPPPCCP;

	struct RASEAPUSERIDENTITYW{
		WCHAR[UNLEN + 1] szUserName;
		DWORD dwSizeofEapInfo;
		BYTE[1] pbEapInfo;
	}
	alias RASEAPUSERIDENTITYW* LPRASEAPUSERIDENTITYW;

	struct RASEAPUSERIDENTITYA{
		CHAR[UNLEN + 1] szUserName;
		DWORD dwSizeofEapInfo;
		BYTE[1] pbEapInfo;
	}
	alias RASEAPUSERIDENTITYA* LPRASEAPUSERIDENTITYA;

	struct RAS_STATS{
		DWORD dwSize;
		DWORD dwBytesXmited;
		DWORD dwBytesRcved;
		DWORD dwFramesXmited;
		DWORD dwFramesRcved;
		DWORD dwCrcErr;
		DWORD dwTimeoutErr;
		DWORD dwAlignmentErr;
		DWORD dwHardwareOverrunErr;
		DWORD dwFramingErr;
		DWORD dwBufferOverrunErr;
		DWORD dwCompressionRatioIn;
		DWORD dwCompressionRatioOut;
		DWORD dwBps;
		DWORD dwConnectDuration;
	}
	alias RAS_STATS* PRAS_STATS;
}


/* UNICODE typedefs for structures*/
version (Unicode) {
	alias RASCONNW RASCONN;
	alias RASENTRYW RASENTRY;
	alias RASCONNSTATUSW RASCONNSTATUS;
	alias RASDIALPARAMSW RASDIALPARAMS;
	alias RASAMBW RASAMB;
	alias RASPPPNBFW RASPPPNBF;
	alias RASPPPIPXW RASPPPIPX;
	alias RASPPPIPW RASPPPIP;
	alias RASPPPLCPW RASPPPLCP;
	alias RASSLIPW RASSLIP;
	alias RASDEVINFOW RASDEVINFO;
	alias RASENTRYNAMEW RASENTRYNAME;

	static if (_WIN32_WINNT >= 0x401) {
		alias RASSUBENTRYW RASSUBENTRY;
		alias RASCREDENTIALSW RASCREDENTIALS;
		alias RASAUTODIALENTRYW RASAUTODIALENTRY;
	}

	static if (_WIN32_WINNT >= 0x500) {
		alias RASEAPUSERIDENTITYW RASEAPUSERIDENTITY;
	}

} else { // ! defined UNICODE

	alias RASCONNA RASCONN;
	alias RASENTRYA  RASENTRY;
	alias RASCONNSTATUSA RASCONNSTATUS;
	alias RASDIALPARAMSA RASDIALPARAMS;
	alias RASAMBA RASAMB;
	alias RASPPPNBFA RASPPPNBF;
	alias RASPPPIPXA RASPPPIPX;
	alias RASPPPIPA RASPPPIP;
	alias RASPPPLCPA RASPPPLCP;
	alias RASSLIPA RASSLIP;
	alias RASDEVINFOA  RASDEVINFO;
	alias RASENTRYNAMEA RASENTRYNAME;

	static if (_WIN32_WINNT >= 0x401) {
		alias RASSUBENTRYA RASSUBENTRY;
		alias RASCREDENTIALSA RASCREDENTIALS;
		alias RASAUTODIALENTRYA RASAUTODIALENTRY;
	}
	static if (_WIN32_WINNT >= 0x500) {
		alias RASEAPUSERIDENTITYA RASEAPUSERIDENTITY;
	}
}// ! UNICODE


alias RASCONN* LPRASCONN;
alias RASENTRY* LPRASENTRY;
alias RASCONNSTATUS* LPRASCONNSTATUS;
alias RASDIALPARAMS* LPRASDIALPARAMS;
alias RASAMB* LPRASAM;
alias RASPPPNBF* LPRASPPPNBF;
alias RASPPPIPX* LPRASPPPIPX;
alias RASPPPIP* LPRASPPPIP;
alias RASPPPLCP* LPRASPPPLCP;
alias RASSLIP* LPRASSLIP;
alias RASDEVINFO* LPRASDEVINFO;
alias RASENTRYNAME* LPRASENTRYNAME;

static if (_WIN32_WINNT >= 0x401) {
	alias RASSUBENTRY* LPRASSUBENTRY;
	alias RASCREDENTIALS* LPRASCREDENTIALS;
	alias RASAUTODIALENTRY* LPRASAUTODIALENTRY;
}
static if (_WIN32_WINNT >= 0x500) {
	alias RASEAPUSERIDENTITY* LPRASEAPUSERIDENTITY;
}

/* Callback prototypes */
deprecated {
	alias BOOL function (HWND, LPSTR, DWORD, LPDWORD) ORASADFUNC;
}

alias void function (UINT, RASCONNSTATE, DWORD) RASDIALFUNC;
alias void function(HRASCONN, UINT, RASCONNSTATE, DWORD,
DWORD) RASDIALFUNC1;
alias DWORD function (ULONG_PTR, DWORD, HRASCONN, UINT,
RASCONNSTATE, DWORD, DWORD) RASDIALFUNC2;

/* External functions */
DWORD RasDialA (LPRASDIALEXTENSIONS, LPCSTR, LPRASDIALPARAMSA,
DWORD, LPVOID, LPHRASCONN);
DWORD RasDialW (LPRASDIALEXTENSIONS, LPCWSTR, LPRASDIALPARAMSW,
DWORD, LPVOID, LPHRASCONN);
DWORD RasEnumConnectionsA (LPRASCONNA, LPDWORD, LPDWORD);
DWORD RasEnumConnectionsW (LPRASCONNW, LPDWORD, LPDWORD);
DWORD RasEnumEntriesA (LPCSTR, LPCSTR, LPRASENTRYNAMEA, LPDWORD,
LPDWORD);
DWORD RasEnumEntriesW (LPCWSTR, LPCWSTR, LPRASENTRYNAMEW, LPDWORD,
LPDWORD);
DWORD RasGetConnectStatusA (HRASCONN, LPRASCONNSTATUSA);
DWORD RasGetConnectStatusW (HRASCONN, LPRASCONNSTATUSW);
DWORD RasGetErrorStringA (UINT, LPSTR, DWORD);
DWORD RasGetErrorStringW (UINT, LPWSTR, DWORD);
DWORD RasHangUpA (HRASCONN);
DWORD RasHangUpW (HRASCONN);
DWORD RasGetProjectionInfoA (HRASCONN, RASPROJECTION, LPVOID,
LPDWORD);
DWORD RasGetProjectionInfoW (HRASCONN, RASPROJECTION, LPVOID,
LPDWORD);
DWORD RasCreatePhonebookEntryA (HWND, LPCSTR);
DWORD RasCreatePhonebookEntryW (HWND, LPCWSTR);
DWORD RasEditPhonebookEntryA (HWND, LPCSTR, LPCSTR);
DWORD RasEditPhonebookEntryW (HWND, LPCWSTR, LPCWSTR);
DWORD RasSetEntryDialParamsA (LPCSTR, LPRASDIALPARAMSA, BOOL);
DWORD RasSetEntryDialParamsW (LPCWSTR, LPRASDIALPARAMSW, BOOL);
DWORD RasGetEntryDialParamsA (LPCSTR, LPRASDIALPARAMSA, LPBOOL);
DWORD RasGetEntryDialParamsW (LPCWSTR, LPRASDIALPARAMSW, LPBOOL);
DWORD RasEnumDevicesA (LPRASDEVINFOA, LPDWORD, LPDWORD);
DWORD RasEnumDevicesW (LPRASDEVINFOW, LPDWORD, LPDWORD);
DWORD RasGetCountryInfoA (LPRASCTRYINFOA, LPDWORD);
DWORD RasGetCountryInfoW (LPRASCTRYINFOW, LPDWORD);
DWORD RasGetEntryPropertiesA (LPCSTR, LPCSTR, LPRASENTRYA, LPDWORD,
LPBYTE, LPDWORD);
DWORD RasGetEntryPropertiesW (LPCWSTR, LPCWSTR, LPRASENTRYW,
LPDWORD, LPBYTE, LPDWORD);
DWORD RasSetEntryPropertiesA (LPCSTR, LPCSTR, LPRASENTRYA, DWORD,
LPBYTE, DWORD);
DWORD RasSetEntryPropertiesW (LPCWSTR, LPCWSTR, LPRASENTRYW, DWORD,
LPBYTE, DWORD);
DWORD RasRenameEntryA (LPCSTR, LPCSTR, LPCSTR);
DWORD RasRenameEntryW (LPCWSTR, LPCWSTR, LPCWSTR);
DWORD RasDeleteEntryA (LPCSTR, LPCSTR);
DWORD RasDeleteEntryW (LPCWSTR, LPCWSTR);
DWORD RasValidateEntryNameA (LPCSTR, LPCSTR);
DWORD RasValidateEntryNameW (LPCWSTR, LPCWSTR);

static if (_WIN32_WINNT >= 0x401) {
	alias BOOL function (LPSTR, LPSTR, LPRASADPARAMS, LPDWORD) RASADFUNCA;
	alias BOOL function (LPWSTR, LPWSTR, LPRASADPARAMS, LPDWORD) RASADFUNCW;

	DWORD RasGetSubEntryHandleA (HRASCONN, DWORD, LPHRASCONN);
	DWORD RasGetSubEntryHandleW (HRASCONN, DWORD, LPHRASCONN);
	DWORD RasGetCredentialsA (LPCSTR, LPCSTR, LPRASCREDENTIALSA);
	DWORD RasGetCredentialsW (LPCWSTR, LPCWSTR, LPRASCREDENTIALSW);
	DWORD RasSetCredentialsA (LPCSTR, LPCSTR, LPRASCREDENTIALSA, BOOL);
	DWORD RasSetCredentialsW (LPCWSTR, LPCWSTR, LPRASCREDENTIALSW, BOOL);
	DWORD RasConnectionNotificationA (HRASCONN, HANDLE, DWORD);
	DWORD RasConnectionNotificationW (HRASCONN, HANDLE, DWORD);
	DWORD RasGetSubEntryPropertiesA (LPCSTR, LPCSTR, DWORD,
	LPRASSUBENTRYA, LPDWORD, LPBYTE, LPDWORD);
	DWORD RasGetSubEntryPropertiesW (LPCWSTR, LPCWSTR, DWORD,
	LPRASSUBENTRYW, LPDWORD, LPBYTE, LPDWORD);
	DWORD RasSetSubEntryPropertiesA (LPCSTR, LPCSTR, DWORD,
	LPRASSUBENTRYA, DWORD, LPBYTE, DWORD);
	DWORD RasSetSubEntryPropertiesW (LPCWSTR, LPCWSTR, DWORD,
	LPRASSUBENTRYW, DWORD, LPBYTE, DWORD);
	DWORD RasGetAutodialAddressA (LPCSTR, LPDWORD, LPRASAUTODIALENTRYA,
	LPDWORD, LPDWORD);
	DWORD RasGetAutodialAddressW (LPCWSTR, LPDWORD,
	LPRASAUTODIALENTRYW, LPDWORD, LPDWORD);
	DWORD RasSetAutodialAddressA (LPCSTR, DWORD, LPRASAUTODIALENTRYA,
	DWORD, DWORD);
	DWORD RasSetAutodialAddressW (LPCWSTR, DWORD, LPRASAUTODIALENTRYW,
	DWORD, DWORD);
	DWORD RasEnumAutodialAddressesA (LPSTR *, LPDWORD, LPDWORD);
	DWORD RasEnumAutodialAddressesW (LPWSTR *, LPDWORD, LPDWORD);
	DWORD RasGetAutodialEnableA (DWORD, LPBOOL);
	DWORD RasGetAutodialEnableW (DWORD, LPBOOL);
	DWORD RasSetAutodialEnableA (DWORD, BOOL);
	DWORD RasSetAutodialEnableW (DWORD, BOOL);
	DWORD RasGetAutodialParamA (DWORD, LPVOID, LPDWORD);
	DWORD RasGetAutodialParamW (DWORD, LPVOID, LPDWORD);
	DWORD RasSetAutodialParamA (DWORD, LPVOID, DWORD);
	DWORD RasSetAutodialParamW (DWORD, LPVOID, DWORD);
}

static if (_WIN32_WINNT >= 0x500) {
	alias DWORD function (HRASCONN) RasCustomHangUpFn;
	alias DWORD function (LPCTSTR,	LPCTSTR, DWORD) RasCustomDeleteEntryNotifyFn;
	alias DWORD function (HINSTANCE, LPRASDIALEXTENSIONS,
	LPCTSTR, LPRASDIALPARAMS, DWORD, LPVOID, LPHRASCONN, DWORD) RasCustomDialFn;

	DWORD RasInvokeEapUI (HRASCONN, DWORD, LPRASDIALEXTENSIONS, HWND);
	DWORD RasGetLinkStatistics (HRASCONN, DWORD, RAS_STATS*);
	DWORD RasGetConnectionStatistics (HRASCONN, RAS_STATS*);
	DWORD RasClearLinkStatistics (HRASCONN, DWORD);
	DWORD RasClearConnectionStatistics (HRASCONN);
	DWORD RasGetEapUserDataA (HANDLE, LPCSTR, LPCSTR, BYTE*, DWORD*);
	DWORD RasGetEapUserDataW (HANDLE, LPCWSTR, LPCWSTR, BYTE*, DWORD*);
	DWORD RasSetEapUserDataA (HANDLE, LPCSTR, LPCSTR, BYTE*, DWORD);
	DWORD RasSetEapUserDataW (HANDLE, LPCWSTR, LPCWSTR, BYTE*, DWORD);
	DWORD RasGetCustomAuthDataA (LPCSTR,	LPCSTR,	BYTE*,	DWORD*);
	DWORD RasGetCustomAuthDataW (LPCWSTR, LPCWSTR, BYTE*, DWORD*);
	DWORD RasSetCustomAuthDataA (LPCSTR,	LPCSTR,	BYTE*,	DWORD);
	DWORD RasSetCustomAuthDataW (LPCWSTR, LPCWSTR, BYTE*, DWORD);
	DWORD RasGetEapUserIdentityW (LPCWSTR, LPCWSTR, DWORD, HWND, LPRASEAPUSERIDENTITYW*);
	DWORD RasGetEapUserIdentityA (LPCSTR, LPCSTR, DWORD, HWND, LPRASEAPUSERIDENTITYA*);
	void RasFreeEapUserIdentityW (LPRASEAPUSERIDENTITYW);
	void RasFreeEapUserIdentityA (LPRASEAPUSERIDENTITYA);
}


/* UNICODE defines for functions */
version(Unicode) {
	alias RasDialW RasDial;
	alias RasEnumConnectionsW RasEnumConnections;
	alias RasEnumEntriesW RasEnumEntries;
	alias RasGetConnectStatusW RasGetConnectStatus;
	alias RasGetErrorStringW RasGetErrorString;
	alias RasHangUpW RasHangUp;
	alias RasGetProjectionInfoW RasGetProjectionInfo;
	alias RasCreatePhonebookEntryW RasCreatePhonebookEntry;
	alias RasEditPhonebookEntryW RasEditPhonebookEntry;
	alias RasSetEntryDialParamsW RasSetEntryDialParams;
	alias RasGetEntryDialParamsW RasGetEntryDialParams;
	alias RasEnumDevicesW RasEnumDevices;
	alias RasGetCountryInfoW RasGetCountryInfo;
	alias RasGetEntryPropertiesW RasGetEntryProperties;
	alias RasSetEntryPropertiesW RasSetEntryProperties;
	alias RasRenameEntryW RasRenameEntry;
	alias RasDeleteEntryW RasDeleteEntry;
	alias RasValidateEntryNameW RasValidateEntryName;

	static if (_WIN32_WINNT >= 0x401) {
		alias RASADFUNCW RASADFUNC;
		alias RasGetSubEntryHandleW RasGetSubEntryHandle;
		alias RasConnectionNotificationW RasConnectionNotification;
		alias RasGetSubEntryPropertiesW RasGetSubEntryProperties;
		alias RasSetSubEntryPropertiesW RasSetSubEntryProperties;
		alias RasGetCredentialsW RasGetCredentials;
		alias RasSetCredentialsW RasSetCredentials;
		alias RasGetAutodialAddressW RasGetAutodialAddress;
		alias RasSetAutodialAddressW RasSetAutodialAddress;
		alias RasEnumAutodialAddressesW RasEnumAutodialAddresses;
		alias RasGetAutodialEnableW RasGetAutodialEnable;
		alias RasSetAutodialEnableW RasSetAutodialEnable;
		alias RasGetAutodialParamW RasGetAutodialParam;
		alias RasSetAutodialParamW RasSetAutodialParam;
	}

	static if (_WIN32_WINNT >= 0x500) {
		alias RasGetEapUserDataW RasGetEapUserData;
		alias RasSetEapUserDataW RasSetEapUserData;
		alias RasGetCustomAuthDataW RasGetCustomAuthData;
		alias RasSetCustomAuthDataW RasSetCustomAuthData;
		alias RasGetEapUserIdentityW RasGetEapUserIdentity;
		alias RasFreeEapUserIdentityW RasFreeEapUserIdentity;
	}

} else { // !Unicode
	alias RasDialA RasDial;
	alias RasEnumConnectionsA RasEnumConnections;
	alias RasEnumEntriesA RasEnumEntries;
	alias RasGetConnectStatusA RasGetConnectStatus;
	alias RasGetErrorStringA RasGetErrorString;
	alias RasHangUpA RasHangUp;
	alias RasGetProjectionInfoA RasGetProjectionInfo;
	alias RasCreatePhonebookEntryA RasCreatePhonebookEntry;
	alias RasEditPhonebookEntryA RasEditPhonebookEntry;
	alias RasSetEntryDialParamsA RasSetEntryDialParams;
	alias RasGetEntryDialParamsA RasGetEntryDialParams;
	alias RasEnumDevicesA RasEnumDevices;
	alias RasGetCountryInfoA RasGetCountryInfo;
	alias RasGetEntryPropertiesA RasGetEntryProperties;
	alias RasSetEntryPropertiesA RasSetEntryProperties;
	alias RasRenameEntryA RasRenameEntry;
	alias RasDeleteEntryA RasDeleteEntry;
	alias RasValidateEntryNameA RasValidateEntryName;

	static if (_WIN32_WINNT >= 0x401) {
		alias RASADFUNCA RASADFUNC;
		alias RasGetSubEntryHandleA RasGetSubEntryHandle;
		alias RasConnectionNotificationA RasConnectionNotification;
		alias RasGetSubEntryPropertiesA RasGetSubEntryProperties;
		alias RasSetSubEntryPropertiesA RasSetSubEntryProperties;
		alias RasGetCredentialsA RasGetCredentials;
		alias RasSetCredentialsA RasSetCredentials;
		alias RasGetAutodialAddressA RasGetAutodialAddress;
		alias RasSetAutodialAddressA RasSetAutodialAddress;
		alias RasEnumAutodialAddressesA RasEnumAutodialAddresses;
		alias RasGetAutodialEnableA RasGetAutodialEnable;
		alias RasSetAutodialEnableA RasSetAutodialEnable;
		alias RasGetAutodialParamA RasGetAutodialParam;
		alias RasSetAutodialParamA RasSetAutodialParam;
	}

	static if (_WIN32_WINNT >= 0x500) {
		alias RasGetEapUserDataA RasGetEapUserData;
		alias RasSetEapUserDataA RasSetEapUserData;
		alias RasGetCustomAuthDataA RasGetCustomAuthData;
		alias RasSetCustomAuthDataA RasSetCustomAuthData;
		alias RasGetEapUserIdentityA RasGetEapUserIdentity;
		alias RasFreeEapUserIdentityA RasFreeEapUserIdentity;
	}
} //#endif // !Unicode
