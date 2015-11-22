module traitstest;
import std.typetuple : Arguments = TypeTuple, Map = staticMap, Filter;
import std.typecons : tuple, Tuple;
import std.traits;
import std.math;
import traitshelper;
import std.stdio;

/*
	"XllRename!newname","XllAtLeastArgs!(2)","XllCategory!","XllShortcut!","XllHelpTopic!",
    "XllFunctionHelp!","XllArgumentHelp!", "XllThreadSafe!","XllMacro!","XllAllowAbort!""XllVolatile!",
    "XllDisableFunctionWizard!","XllDisableReplaceCalc!"
*/
@Xlld!(	XllRename!"newname",XllAtLeastArgs!(10),XllCategory!"retarded",XllShortcut!"stoopid",XllHelpTopic!"helptopic",
		XllFunctionHelp!"no help", XllArgumentHelp!"even less", XllThreadSafe!false,XllMacro!false, XllAllowAbort!true,
		XllAllowAbort!true,XllVolatile!true,XllDisableFunctionWizard!true,XllDisableReplaceCalc!false)
	//"hello",1,double.nan)
	 double test()
{
	return 1.0;
}

//pragma(msg, printWrapped!traitstest);
//PropertyMember!("traitstest", "test"));

enum string[2] names=["",""];
//void function(string s) addNamedg=&addName;
auto addNamedg=&addName;

void addName(string s)
{
	names~=s;
}

void main(string[] argsz)
{
	addNamedg=&addName;
	pragma(msg,printWrapped!traitstest);
	writefln("%s",names);
	//writefln("%s",args.xllcategory);
}