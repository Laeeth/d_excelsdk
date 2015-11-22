module kpropdll;
/*
	K-prop: a foundational library for proprietary trading

	(c) 2014 Laeeth Isharc and Khalid Khan

	This module contains C-style wrappers for various library components in order to make them easily accessible from Excel,
	VBA, and similar.
*/

//	This function uses double array dIn as an argument with dimensions iSizeIn
//	and puts results in double array dOut with dimensions iSizeOut
//	For this example, dIn and dOut are the same size so iSizeOut is ignored
//	But in general, dIn and dOut can have different dimensions
extern (Windows) long useArray( double* dIn, double* dOut, int n)
{
	int i, j;
	for(i=0;i<n;i++)
	{
		dOut[i]=dIn[i]*10;
	}
	return 123L;
}

alias BSTR=wchar*;

extern (Windows) long coolString(char* s, int slen)
{
	if (slen<4)
		return slen;
	auto s2="cool";
	foreach(i;0..slen)
		s2~=s[i];
	foreach(i,c;s2)
		s[i]=c;
	return s2.length;
}
/**
string toDString(BSTR* str, bool dontFree=false)
{
	auto ret=(to!string(str[0 .. SysStringLen(str)]));
	if (!dontFree)
		SysFreeString(str);
	return ret;
}

BSTR* toBSTR(string str)
{
	if(str is null)
	{
		ret.bstrVal="";
		return ret;
	}
	BSTR* ret = enforce(SysAllocString(toUTFz!(const(wchar)*)(str)), "Out of memory");
	ret.bstrVal = str;
	return ret;
}
/**
  wchar* bstr = SysAllocString(std.utf.toUTF16z(s));

and

  char[] s = std.utf.toUTF8(bstr[0 .. SysStringLen(bstr)]);
  SysFreeString(bstr);
*/
  
/**
Argument Types in C/C++ and VBA
You should note the following when you compare the declarations of argument types in C/C++ and VBA.
A VBA String is passed as a pointer to a byte-string BSTR structure when passed ByVal, and as a pointer to a pointer when passed ByRef.
A VBA Variant that contains a string is passed as a pointer to a Unicode wide-character string BSTR structure when passed ByVal, and as a pointer to a pointer when passed ByRef.
The VBA Integer is a 16-bit type equivalent to a signed short in C/C++.
The VBA Long is a 32-bit type equivalent to a signed int in C/C++.
Both VBA and C/C++ allow the definition of user-defined data types, using the Type and struct statements respectively.
Both VBA and C/C++ support the Variant data type, defined for C/C++ in the Windows OLE/COM header files as VARIANT.
VBA arrays are OLE SafeArrays, defined for C/C++ in the Windows OLE/COM header files as SAFEARRAY.
The VBA Currency data type is passed as a structure of type CY, defined in the Windows header file wtypes.h, when passed ByVal, and as a pointer to this when passed ByRef.
In VBA, data elements in user-defined data types are packed to 4-byte boundaries, whereas in Visual Studio, by default, they are packed to 8-byte boundaries. Therefore you must enclose the C/C++ structure definition in a #pragma pack(4) … #pragma pack() block to avoid elements being misaligned.



VBA supports a greater range of values in some cases than Excel supports. The VBA double is IEEE compliant, supporting subnormal numbers that are currently rounded down to zero on the worksheet. The VBA Date type can represent dates as early as 1-Jan-0100 using negative serialized dates. Excel only allows serialized dates greater than or equal to zero. The VBA Currency type—a scaled 64-bit integer—can achieve accuracy not supported in 8-byte doubles, and so is not matched in the worksheet.
Excel only passes Variants of the following types to a VBA user-defined function.
VBA data type
C/C++ Variant type bit flags
Description
Double
VT_R8
Boolean
VT_BOOL
Date
VT_DATE
String
VT_BSTR
OLE Bstr byte string
Range
VT_DISPATCH
Range and cell references
Variant containing an array
VT_ARRAY | VT_VARIANT
Literal arrays
Ccy
VT_CY
64-bit integer scaled to permit 4 decimal places of accuracy.
Variant containing an error
VT_ERROR
VT_EMPTY
Empty cells or omitted arguments
You can check the type of a passed-in Variant in VBA using the VarType, except that the function returns the type of the range’s values when called with references. To determine if a Variant is a Range reference object, you can use the IsObject function.
You can create Variants that contain arrays of variants in VBA from a Range by assigning its Value property to a Variant. Any cells in the source range that are formatted using the standard currency format for the regional settings in force at the time are converted to array elements of type Currency. Any cells formatted as dates are converted to array elements of type Date. Cells containing strings are converted to wide-character BSTR Variants. Cells containing errors are converted to Variants of type VT_ERROR. Cells containing BooleanTrue or False are converted to Variants of type VT_BOOL.
Note
The Variant stores True as –1 and False as 0. Numbers not formatted as dates or currency amounts are converted to Variants of type VT_R8.
Variant and String Arguments
Excel works internally with wide-character Unicode strings. When a VBA user-defined function is declared as taking a String argument, Excel converts the supplied string to a byte-string in a locale-specific way. If you want your function to be passed a Unicode string, your VBA user-defined function should accept a Variant instead of a String argument. Your DLL function can then accept that Variant BSTR wide-character string from VBA.
To return Unicode strings to VBA from a DLL, you should modify a Variant string argument in place. For this to work, you must declare the DLL function as taking a pointer to the Variant and in your C/C++ code, and declare the argument in the VBA code as ByRef varg As Variant. The old string memory should be released, and the new string value created by using the OLE Bstr string functions only in the DLL.
To return a byte string to VBA from a DLL, you should modify a byte-string BSTR argument in place. For this to work, you must declare the DLL function as taking a pointer to a pointer to the BSTR and in your C/C++ code, and declare the argument in the VBA code as ‘ByRef varg As String’.
You should only handle strings that are passed in these ways from VBA using the OLE BSTR string functions to avoid memory-related problems. For example, you must call SysFreeString to free the memory before overwriting the passed in string, and SysAllocStringByteLen or SysAllocStringLen to allocate space for a new string.
You can create Excel worksheet errors as Variants in VBA by using the CVerr function with arguments as shown in the following table. Worksheet errors can also be returned to VBA from a DLL using Variants of type VT_ERROR, and with the following values in the ulVal field.
Error
Variant ulVal value
CVerr argument
#NULL!
2148141008
2000
#DIV/0!
2148141015
2007
#VALUE!
2148141023
2015
#REF!
2148141031
2023
#NAME?
2148141037
2029
#NUM!
2148141044
2036
#N/A
2148141050
2042
Note that the Variant ulVal value given is equivalent to the CVerr argument value plus x800A0000 hexadecimal.

*/
