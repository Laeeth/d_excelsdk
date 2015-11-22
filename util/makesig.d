import std.stdio;
import std.conv;

string makeMultiArgWrap(string wrapperName, int numArgs)
{
	string ret;
	ret="extern(Windows) LPXLOPER12 "~wrapperName~"(function(LPXLOPER12[] args) child)
	(
	";
	ret~="\t";
	foreach(i;0..numArgs)
	{
		ret~="LPXLOPER12 arg"~i.to!string;
		if (i<numArgs-1)
		{
			ret~=", ";
			if (i%6==0)
				ret~="\n\t";
		}
	}
	ret~=")
	{
		LPXLOPER12[] args=[";
	foreach(i;0..numArgs)
	{
		ret~="arg"~i.to!string;
		if (i<numArgs-1)
			ret~=", ";
	}
	ret~="];
	size_t numArgs="~numArgs.to!string~";
	while(args[numArgs-1].xltype==xltypeMissing)
		--numArgs;
	return (*child)(args);
}
";
	return ret;
}

void main(string[] args)
{
	writefln("%s",makeMultiArgWrap("multiArgWrap",29));
}
