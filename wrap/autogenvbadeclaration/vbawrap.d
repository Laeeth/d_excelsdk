module vbawrap;
import std.traits;
import std.stdio;
import std.conv;
import std.array;
import std.range;
import std.typecons;
import std.string;

struct mystruct
{
	double a;
	int[] b;
}
/*double test()
{
	return 1.0;
}*/



double test(double[] inp,  double[] oup)
{
	double sum=0.0;
	oup.length=inp.length;
	foreach(i;0..inp.length)
	{
		oup[i]=inp[i]*inp[i];
		sum+=oup[i];
	}
	return sum;
}

//double test2=vbawrap!test();

/*auto vbawrap(T)(T t)
if (isFunctionPointer!T || isDelegate!T)
{
	enum attrs=functionAttributes!T|functionAttribute.C_;
	return cast(SetFunctionAttributes!(T,functionLinkage!T,attrs)) t;
}*/

string[] modulelist()
{
	string[] ret;
    foreach(m; __traits(allMembers, vbawrap)) 
    {
    	ret~=m;
    }
    return ret;
}

string[] funclist()
{
	string[] ret;
    foreach(m; __traits(allMembers, vbawrap)) 
    {
   		ret~=m;
    }
    return ret;
}
string[] structmembers()
{
	string[] ret;
    foreach(m; __traits(allMembers, mystruct)) 
    {
    	ret~=m;
    }
    return ret;
}

string[] structtovba(string structname)
{
	string ret;
	ret="Type "~structname~"\n";
    foreach(m; __traits(allMembers, mystruct)) 
    {
		ret~="\t"~m~" as "~DtoVBAType(m.type.stringof)~"\n";
	}
	ret~="End Type\n";
	return ret;
}

string DtoVBAType(string arg)
{
	switch(arg)
	{
		case "double":
			return "Double";

		case "int":
			return "Integer";

		case "long":
			return "Long";
	}
	return"";
}
mixin(wrap!test);
int main(string[] args)
{
 	string fn="test";
    writefln("members of mystruct: %s\n\n\n",structmembers());
	writefln(wrap());
	//mixin(wrap());
    writefln("functions for module: %s",funclist());
	writefln("success!");
	return 1;
}

template wrap(alias fn)
{
    	string fnstring=fullyQualifiedName(fn);
    	string newwrapper="extern(Windows) "~ReturnType(fn)~" vbwrap_"~fnstring~"(";
	    string[] fnargnames,fnargtypes;
	    foreach(m,type; ParameterTypeTuple!fn)
	    {
	        string t=parameterNamesOf!test[m];
	        //static if (__traits(isStaticFunction, __traits(getMember, vbawrap, m))) 
	        //writefln("%s,%s",t,type.stringof);     
	        fnargnames~=t;
	        fnargtypes~=type.stringof;
	        newwrapper~=DtoVBA(type.stringof)~" "~t~",";
	        if (is_array_dynamic(type.stringof))
	        	newwrapper~="size_t num_"~t~",";
	    }
		string bodytext="";
		string[] dynargs;
		foreach(arg;0..fnargnames.length)
		{
			if (is_array_dynamic(fnargtypes[arg]))
			{
				bodytext~="\t"~extracttype(fnargtypes[arg])~ "[] arg_" ~ fnargnames[arg] ~ ";\n";
				bodytext~="\targ_"~fnargnames[arg]~".length="~"num_"~fnargnames[arg]~";\n";
				dynargs~=fnargnames[arg];
			}
		}
		foreach(arg;0..dynargs.length)
		{
			bodytext~="\tforeach(arg;0..num_"~dynargs[arg]~")\n\t{\n\t\t";
			bodytext~="arg_"~dynargs[arg]~"[arg]="~dynargs[arg]~"[arg];\n";
			bodytext~="\t}\n\n";
		}
	/*
				newwrapper~=fnargcasts[arg]~fnargnames[arg]~",";
	        fnargcasts~=DtoVBA_cast(type.stringof);
	        newwrapper~=DtoVBA(type.stringof) ~ " " ~ t ~ ",";*/
		
	    newwrapper=newwrapper[0..$-1] ~")\n";
		newwrapper~="{\n"~bodytext;
		newwrapper~="\treturn "~"test(";
		foreach(arg;0..fnargnames.length)
		{
			if (is_array_dynamic(fnargtypes[arg]))
				newwrapper~="arg_";
			newwrapper~=fnargnames[arg]~",";
		}
		newwrapper=newwrapper[0..$-1]~");";
		newwrapper~= "\n}\n";
		wrap= newwrapper;
}

string extracttype(string arg)
{
	return split(arg,"[")[0];
}
bool is_array_static(string arg)
{
	return false;

}
bool is_array_dynamic(string arg)
{
	auto i=arg.indexOf("[]");
	return (i>-1);
	
}
string DtoVBA(string arg)
{
	return replace(arg,"[]","*");
}
string DtoVBA_cast(string arg)
{
	auto ret=replace(arg,"[]","*");
	ret="cast("~ret~")";
	return ret;
}
/* *
 * Returns the parameter names of the given function
 * 
 * Params:
 *     func = the function alias to get the parameter names of
 *     
 * Returns: an array of strings containing the parameter names 
 */
/+
string parameterNamesOf( alias fn )( ) {
    string fullName = typeof(&fn).stringof;
    int pos = fullName.lastIndexOf( ')' );
    int end = pos;
    int count = 0;
    do {
        if ( fullName[pos] == ')' ) {
            count++;
        } else if ( fullName[pos] == '(' ) {
            count--;
        }
        pos--;
    } while ( count > 0 );
    return fullName[pos+2..end];
}
+/

 
template parameterNamesOf (alias func) {
        const parameterNamesOf = parameterInfoImpl!(func)[0];
}

// FIXME: I lost about a second on compile time after adding support for defaults :-(
template parameterDefaultsOf (alias func) {
        const parameterDefaultsOf = parameterInfoImpl!(func)[1];
}

bool parameterHasDefault(alias func)(int p) {
        auto a = parameterDefaultsOf!(func);
	if(a.length == 0)
		return false;
	return a[p].length > 0;
}

template parameterDefaultOf (alias func, int paramNum) {
	alias parameterDefaultOf = ParameterDefaultValueTuple!func[paramNum];
        //auto a = parameterDefaultsOf!(func);
	//return a[paramNum];
}

sizediff_t indexOfNew(string s, char a) {
	foreach(i, c; s)
		if(c == a)
			return i;
	return -1;
}

sizediff_t lastIndexOfNew(string s, char a) {
	for(sizediff_t i = s.length; i > 0; i--)
		if(s[i - 1] == a)
			return i - 1;
	return -1;
}
 

// FIXME: a problem here is the compiler only keeps one stringof
// for a particular type
//
// so if you have void a(string a, string b); and void b(string b, string c),
// both a() and b() will show up as params == ["a", "b"]!
//
// 
private string[][2] parameterInfoImpl (alias func) ()
{
        string funcStr = typeof(func).stringof; // this might fix the fixme above...
						// it used to be typeof(&func).stringof

        auto start = funcStr.indexOfNew('(');
        auto end = funcStr.lastIndexOfNew(')');

	assert(start != -1);
	assert(end != -1);
        
        const firstPattern = ' ';
        const secondPattern = ',';
        
        funcStr = funcStr[start + 1 .. end];
        
        if (funcStr == "") // no parameters
                return [null, null];
                
        funcStr ~= secondPattern;
        
        string token;
        string[] arr;
        
        foreach (c ; funcStr)
        {               
                if (c != firstPattern && c != secondPattern)
                        token ~= c;
                
                else
                {                       
                        if (token)
                                arr ~= token;
                        
                        token = null;
                }                       
        }
        
        if (arr.length == 1)
                return [arr, [""]];
        
        string[] result;
	string[] defaults;
        bool skip = false;

	bool gettingDefault = false;

	string currentName = "";
	string currentDefault = "";
        
        foreach (str ; arr)
        {
		if(str == "=") {
			gettingDefault = true;
			continue;
		}

		if(gettingDefault) {
			assert(str.length);
			currentDefault = str;
			gettingDefault = false;
			continue;
		}

                skip = !skip;
                
                if (skip) {
			if(currentName.length) {
				result ~= currentName;
				defaults ~= currentDefault;
				currentName = null;
			}
                        continue;
		}

		currentName = str;
        }

	if(currentName !is null) {
		result ~= currentName;
		defaults ~= currentDefault;
	}

	assert(result.length == defaults.length);
        
        return [result, defaults];
}


extern (Windows) long useArray( double* dIn, double* dOut, int* iSizeIn, int* iSizeOut )
{
	int i, j, iHeight, iWidth;
	iHeight = iSizeIn[0];
	iWidth = iSizeIn[1];
	for(i=0;i<iHeight;i++) {
		for(j=0;j<iWidth;j++) {
			dOut[i*iWidth+j] = dIn[i*iWidth+j]*10;
		}
	}
	return 0L;
}
