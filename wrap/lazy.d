import std.stdio;
import std.string;
import std.conv;
import std.range:repeat;

string process(string s)
{
	return s[0].to!string.toLower~s[1..$];
}

string getBody(string s)
{
   	auto i=s.indexOf("!");
   	return s[0..i];
}
string[] fields=[
	"XllRename!newname","XllAtLeastArgs!(2)","XllCategory!","XllShortcut!","XllHelpTopic!",
    "XllFunctionHelp!","XllArgumentHelp!", "XllThreadSafe!","XllMacro!","XllAllowAbort!""XllVolatile!",
    "XllDisableFunctionWizard!","XllDisableReplaceCalc!"
    ];

void main(string[] args)
{
	foreach(s;fields)
    {
    	auto name=s.getBody;
    	writefln("
struct "~name~"(bool _"~name~") {
	enum "~name.process~" = _"~name~";
}

template Is"~name~"(T...) {
	enum bool Is"~name~" = T[0].stringof.startsWith(\""~name~"!\");
}
");

    }


	foreach(s;fields)
	{
		auto name=s.getBody;
		writefln("\talias Filter!(Is"~name~", Params) "~name~"s;");
		writefln("static if("~name~"s.length) {");
		writefln("	enum "~name.toLower~" = "~name~"s[0]."~name.process~";");
		writefln("}else{");
		writefln("	enum "~name.toLower~" = "~`"";`);
		writefln("}");
	}

	writef("\n\talias ");
	foreach(i,s;fields)
	{
		auto name=s.getBody;
		if(i>0)
			writef("\t\t");
		writef("Filter!(Not!Is"~name);
		if (i==fields.length-1)
			writefln(')'.repeat(fields.length).to!string~" rem;");
		else
			writefln(",");
	}
	writefln(`
	    template IsString(T...) {
	        enum bool IsString = is(typeof(T[0]) == string);
	    }
	    static if(Filter!(IsString, rem).length) {
	        static assert(false, "string parameters must be wrapped with Docstring, Mode, etc");
	    }
	}
	`);

}
/*
struct XllThreadSafe(bool _XllThreadSafe) {
    enum xllThreadSafe = _XllThreadSafe;
}
template XllThreadSafe(T...) {
    enum bool isXllThreadSafe = T[0].stringof.startsWith("XllThreadSafe!");
}



struct Args(string default_modulename,
            string default_docstring,
            string default_pyname,
            string default_mode,
            Params...) {
    alias Filter!(IsDocstring, Params) Docstrings;
    static if(Docstrings.length) {
        enum docstring = Docstrings[0].doc;
    }else{
        enum docstring = default_docstring;
    }
    alias Filter!(IsPyName, Params) PyNames;
    static if(PyNames.length) {
        enum pyname = PyNames[0].name;
    }else{
        enum pyname = default_pyname;
    }
    alias Filter!(IsMode, Params) Modes;
    static if(Modes.length) {
        enum mode = Modes[0].mode;
    }else{
        enum mode = default_mode;
    }
    alias Filter!(IsModuleName, Params) ModuleNames;
    static if(ModuleNames.length) {
        enum modulename = ModuleNames[0].modulename;
    }else{
        enum modulename = default_modulename;
    }

    alias Filter!(Not!IsModuleName, 
          Filter!(Not!IsDocstring, 
          Filter!(Not!IsPyName,
          Filter!(Not!IsMode,
              Params)))) rem;
    template IsString(T...) {
        enum bool IsString = is(typeof(T[0]) == string);
    }
    static if(Filter!(IsString, rem).length) {
        static assert(false, "string parameters must be wrapped with Docstring, Mode, etc");
    }
}*/