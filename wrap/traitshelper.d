module traitshelper;
import std.typetuple;
alias  Arguments = TypeTuple;
alias Map = staticMap;
//, Filter;
import std.typecons : tuple, Tuple;
import std.traits;
import std.algorithm;
import std.string;
import traitstest;

template Not(alias Pred) {
    template Not(Stuff...) {
        enum Not = !Pred!(Stuff[0]);
    }
}

struct Xlld(Args ...){}

@property auto xlld(Args ...)()
{
    return Xlld!Args();
}

template TryTypeof(TL ...)
if(TL.length == 1)
{
    static if(is(TL[0]))
        alias TryTypeof = TL[0]; 
    else static if(is(typeof(TL[0])))
        alias TryTypeof = typeof(TL[0]);
    else static assert("Can't get a type out of this");
}

/*
 * With the builtin alias declaration, you cannot declare
 * aliases of, for example, literal values. You can alias anything
 * including literal values via this template.
 */
// symbols and literal values
template Alias(alias a)
{
    static if (__traits(compiles, { alias x = a; }))
        alias Alias = a;
    else static if (__traits(compiles, { enum x = a; }))
        enum Alias = a;
    else
        static assert(0, "Cannot alias " ~ a.stringof);
}
// types and tuples
template Alias(a...)
{
    alias Alias = a;
}

unittest
{
    enum abc = 1;
    static assert(__traits(compiles, { alias a = Alias!(123); }));
    static assert(__traits(compiles, { alias a = Alias!(abc); }));
    static assert(__traits(compiles, { alias a = Alias!(int); }));
    static assert(__traits(compiles, { alias a = Alias!(1,abc,int); }));
}

bool containsxlld(attrs...)()
{
    foreach(attr; attrs)
        static if(is(TryTypeof!attr == Xlld!Args, Args...))
        {
            return true;
        }
    return false;
}

private auto registerFunctionImpl(alias define, alias parent, string mem)()
{
    //pragma(msg, "callable");
    alias ols = Arguments!(__traits(getOverloads, parent, mem));
    foreach(i, ol; ols)
    {
        alias attrs = Arguments!(__traits(getAttributes, ol));
        static if(containsxlld!attrs)
            foreach(attr; attrs)
            {
                static if(is(TryTypeof!attr == Xlld!Args, Args...))
                {
                    return define!(ol, Args)();
                }
            }
        // issue 14747
        else static if(i == ols.length - 1)
        {
            return;
        }
    }
    // issue 14747
    //assert(0);
}

alias registerFunction(alias parent, string mem) = registerFunctionImpl!(def, parent, mem);

alias MemberFunction(alias parent, string mem) = ReturnType!(registerFunctionImpl!(Def, parent, mem));
alias StaticMemberFunction(alias parent, string mem) = ReturnType!(registerFunctionImpl!(StaticDef, parent, mem));
alias PropertyMember(alias parent, string mem) = ReturnType!(registerFunctionImpl!(Property, parent, mem));

private auto MemberHelper(alias parent, string mem)()
{
    alias agg = Alias!(mixin(`parent.`~mem));

    alias attrs = Arguments!(__traits(getAttributes, agg));
    foreach(i, attr; attrs)
    {
        static if(is(TryTypeof!attr == Xlld!Args, Args...))
        {
            return Member!(mem, Args)();
        }
        // issue 14747
        else static if(i == attrs.length - 1)
            return;
    }
    // issue 14747
    assert(0);
}

alias _Member(alias parent, string mem) = ReturnType!(MemberHelper!(parent, mem));


template Symbol(alias parent)
{
    alias Symbol(string mem) = .Symbol!(mem, parent);
}

template Symbol(string mem, alias parent)
{
    pragma(msg, "registering " ~ parent.stringof ~ '.' ~ mem);
    static if(is(parent == struct) || is(parent == class))
    {
        pragma(msg, "with class/struct parent");
        static if(!(__traits(compiles, mixin(`isAggregateType!(parent.`~mem~')'))
                    && mixin(`isAggregateType!(parent.`~mem~')')
                   )
                    && mixin(`isCallable!(parent.`~mem~')'))
        {
            static if(__traits(isStaticFunction, mixin(`parent.`~mem)))
            {
                pragma(msg, "as static member function");
                alias Symbol =  StaticMemberFunction!(parent, mem);
            }
            static if(functionAttributes!(mixin(`parent.`~mem)) & FunctionAttribute.property)
            {
                pragma(msg, "as property member");
                alias Symbol = PropertyMember!(parent, mem);
            }
            else
            {
                pragma(msg, "as member function");
                alias Symbol =  MemberFunction!(parent, mem);
            }
        }
        else
        {
            pragma(msg, "as member");
            alias Symbol = _Member!(parent, mem);
        }
    }
    else static assert(false);
}


void printWrapped(alias extModule)()
{
    import std.algorithm : startsWith, canFind, endsWith;
    alias membersAll = Alias!(__traits(allMembers, extModule));
    enum isNotTypeInfoInit(string a) = !(a.startsWith("_") && a.canFind("TypeInfo") && a.endsWith("__initZ"));
    alias members = Filter!(isNotTypeInfoInit, membersAll);
    foreach(mem; members)
    {
        static if(mixin(`isCallable!(extModule.`~mem~')'))
            registerFunction!(extModule, mem)();
    }
    /*static if(__traits(hasMember, extModule, "xlldAutoOpen"))
        extModule.preInit();
        
    xlAutoOpen();

    foreach(mem; members)
    {
        static if(mixin(`!isCallable!(extModule.`~mem~')'))
            registerModuleScopeSymbol!(mem, extModule)();
    }

    static if(__traits(hasMember, extModule, "xlldAutoClose"))
        extModule.postInit();
    */
}


void def(alias _fn, Options...)() {
    alias Args!("","", __traits(identifier,_fn), "",Options) args;
    //pragma(msg,_fn);
    //pragma(msg,Options);
    static if(args.rem.length) {
        alias args.rem[0] fn_t;
    }else {
        alias typeof(&_fn) fn_t;
    }
    alias def_selector!(_fn, fn_t).FN fn;
    
    //pragma(msg,fn);
    pragma(msg,args.xllrename);
    addName(args.xllrename);
    //PyMethodDef empty;
    //ready_module_methods(args.modulename);
    //PyMethodDef[]* list = &module_methods[args.modulename];

/*    (*list)[$-1].ml_name = (args.pyname ~ "\0").dup.ptr;
    (*list)[$-1].ml_meth = cast(PyCFunction) &function_wrap!(fn,args.pyname).func;
    (*list)[$-1].ml_flags = METH_VARARGS | METH_KEYWORDS;
    (*list)[$-1].ml_doc = (args.docstring ~ "\0").dup.ptr;
    (*list) ~= empty;*/
}
/*
@xlld!( XllRename!"newname",XllAtLeastArgs!(2),XllCategory!"dlangsci",XllShortcut!"shortcutName",XllHelpTopic!"general",
    XllFunctionHelp!"returns the hash of arguments",XllArgumentHelp!"number 1,2..29 are 1 to 29 arguments to process",
    XllThreadSafe!false,XllMacro!false, XllAllowAbort!false,XllVolatile!false,XllDisableFunctionWizard!false,
    XlldisableReplaceCalc!false)
*/


struct XllRename(string _XllRename) {
    enum xllRename = _XllRename;
}

template IsXllRename(T...) {
    enum bool IsXllRename = T[0].stringof.startsWith("XllRename!");
}


struct XllAtLeastArgs(int _XllAtLeastArgs) {
    enum xllAtLeastArgs = _XllAtLeastArgs;
}

template IsXllAtLeastArgs(T...) {
    enum bool IsXllAtLeastArgs = T[0].stringof.startsWith("XllAtLeastArgs!");
}


struct XllCategory(string _XllCategory) {
    enum xllCategory = _XllCategory;
}

template IsXllCategory(T...) {
    enum bool IsXllCategory = T[0].stringof.startsWith("XllCategory!");
}


struct XllShortcut(string _XllShortcut) {
    enum xllShortcut = _XllShortcut;
}

template IsXllShortcut(T...) {
    enum bool IsXllShortcut = T[0].stringof.startsWith("XllShortcut!");
}


struct XllHelpTopic(string _XllHelpTopic) {
    enum xllHelpTopic = _XllHelpTopic;
}

template IsXllHelpTopic(T...) {
    enum bool IsXllHelpTopic = T[0].stringof.startsWith("XllHelpTopic!");
}


struct XllFunctionHelp(string _XllFunctionHelp) {
    enum xllFunctionHelp = _XllFunctionHelp;
}

template IsXllFunctionHelp(T...) {
    enum bool IsXllFunctionHelp = T[0].stringof.startsWith("XllFunctionHelp!");
}


struct XllArgumentHelp(string _XllArgumentHelp) {
    enum xllArgumentHelp = _XllArgumentHelp;
}

template IsXllArgumentHelp(T...) {
    enum bool IsXllArgumentHelp = T[0].stringof.startsWith("XllArgumentHelp!");
}


struct XllThreadSafe(bool _XllThreadSafe) {
    enum xllThreadSafe = _XllThreadSafe;
}

template IsXllThreadSafe(T...) {
    enum bool IsXllThreadSafe = T[0].stringof.startsWith("XllThreadSafe!");
}


struct XllMacro(bool _XllMacro) {
    enum xllMacro = _XllMacro;
}

template IsXllMacro(T...) {
    enum bool IsXllMacro = T[0].stringof.startsWith("XllMacro!");
}


struct XllAllowAbort(bool _XllAllowAbort) {
    enum xllAllowAbort = _XllAllowAbort;
}

template IsXllAllowAbort(T...) {
    enum bool IsXllAllowAbort = T[0].stringof.startsWith("XllAllowAbort!");
}


struct XllDisableFunctionWizard(bool _XllDisableFunctionWizard) {
    enum xllDisableFunctionWizard = _XllDisableFunctionWizard;
}

template IsXllDisableFunctionWizard(T...) {
    enum bool IsXllDisableFunctionWizard = T[0].stringof.startsWith("XllDisableFunctionWizard!");
}


struct XllDisableReplaceCalc(bool _XllDisableReplaceCalc) {
    enum xllDisableReplaceCalc = _XllDisableReplaceCalc;
}

template IsXllDisableReplaceCalc(T...) {
    enum bool IsXllDisableReplaceCalc = T[0].stringof.startsWith("XllDisableReplaceCalc!");
}

struct XllVolatile(bool _XllVolatile) {
    enum xllVolatile = _XllVolatile;
}

template IsXllVolatile(T...) {
    enum bool IsXllVolatile = T[0].stringof.startsWith("XllVolatile!");
}
struct Args(Params...)
{

        alias Filter!(IsXllRename, Params) XllRenames;
    static if(XllRenames.length) {
        enum xllrename = XllRenames[0].xllRename;
    }else{
        enum xllrename = "";
    }
        alias Filter!(IsXllAtLeastArgs, Params) XllAtLeastArgss;
    static if(XllAtLeastArgss.length) {
        enum xllatleastargs = XllAtLeastArgss[0].xllAtLeastArgs;
    }else{
        enum xllatleastargs = "";
    }
        alias Filter!(IsXllCategory, Params) XllCategorys;
    static if(XllCategorys.length) {
        enum xllcategory = XllCategorys[0].xllCategory;
    }else{
        enum xllcategory = "";
    }
        alias Filter!(IsXllShortcut, Params) XllShortcuts;
    static if(XllShortcuts.length) {
        enum xllshortcut = XllShortcuts[0].xllShortcut;
    }else{
        enum xllshortcut = "";
    }
        alias Filter!(IsXllHelpTopic, Params) XllHelpTopics;
    static if(XllHelpTopics.length) {
        enum xllhelptopic = XllHelpTopics[0].xllHelpTopic;
    }else{
        enum xllhelptopic = "";
    }
        alias Filter!(IsXllFunctionHelp, Params) XllFunctionHelps;
    static if(XllFunctionHelps.length) {
        enum xllfunctionhelp = XllFunctionHelps[0].xllFunctionHelp;
    }else{
        enum xllfunctionhelp = "";
    }
        alias Filter!(IsXllArgumentHelp, Params) XllArgumentHelps;
    static if(XllArgumentHelps.length) {
        enum xllargumenthelp = XllArgumentHelps[0].xllArgumentHelp;
    }else{
        enum xllargumenthelp = "";
    }
        alias Filter!(IsXllThreadSafe, Params) XllThreadSafes;
    static if(XllThreadSafes.length) {
        enum xllthreadsafe = XllThreadSafes[0].xllThreadSafe;
    }else{
        enum xllthreadsafe = "";
    }
        alias Filter!(IsXllMacro, Params) XllMacros;
    static if(XllMacros.length) {
        enum xllmacro = XllMacros[0].xllMacro;
    }else{
        enum xllmacro = "";
    }
        alias Filter!(IsXllAllowAbort, Params) XllAllowAborts;
    static if(XllAllowAborts.length) {
        enum xllallowabort = XllAllowAborts[0].xllAllowAbort;
    }else{
        enum xllallowabort = "";
    }
        alias Filter!(IsXllDisableFunctionWizard, Params) XllDisableFunctionWizards;
    static if(XllDisableFunctionWizards.length) {
        enum xlldisablefunctionwizard = XllDisableFunctionWizards[0].xllDisableFunctionWizard;
    }else{
        enum xlldisablefunctionwizard = "";
    }
        alias Filter!(IsXllDisableReplaceCalc, Params) XllDisableReplaceCalcs;
    static if(XllDisableReplaceCalcs.length) {
        enum xlldisablereplacecalc = XllDisableReplaceCalcs[0].xllDisableReplaceCalc;
    }else{
        enum xlldisablereplacecalc = "";
    }

    alias Filter!(IsXllVolatile, Params) XllVolatile;
    static if(XllVolatile.length) {
        enum xllvolatile = XllVolatile[0].xllVolatile;
    }else{
        enum xllvolatile = false;
    }
    alias Filter!(Not!IsXllRename,
        Filter!(Not!IsXllAtLeastArgs,
        Filter!(Not!IsXllCategory,
        Filter!(Not!IsXllShortcut,
        Filter!(Not!IsXllHelpTopic,
        Filter!(Not!IsXllFunctionHelp,
        Filter!(Not!IsXllArgumentHelp,
        Filter!(Not!IsXllThreadSafe,
        Filter!(Not!IsXllMacro,
        Filter!(Not!IsXllAllowAbort,
        Filter!(Not!IsXllDisableFunctionWizard,
        Filter!(Not!IsXllDisableReplaceCalc)))))))))))) rem;

        template IsString(T...) {
            enum bool IsString = is(typeof(T[0]) == string);
        }
        static if(Filter!(IsString, rem).length) {
            static assert(false, "string parameters must be wrapped with Docstring, Mode, etc");
        }
       
}


template Typeof(alias fn0) {
    alias typeof(&fn0) Typeof;
}

template def_selector(alias fn, fn_t) {
    alias alias_selector!(fn, fn_t) als;
    static if(als.VOverloads.length == 0 && als.Overloads.length != 0) {
        alias staticMap!(Typeof, als.Overloads) OverloadsT;
        static assert(0, format("%s not among %s", 
                    fn_t.stringof,OverloadsT.stringof));
    }else static if(als.VOverloads.length > 1){
        static assert(0, format("%s: Cannot choose between %s", als.nom, 
                    staticMap!(Typeof, als.VOverloads)));
    }else{
        alias als.VOverloads[0] FN;
    }
}

template IsEponymousTemplateFunction(alias fn) {
    // dmd issue 13372: its not a bug, its a feature!
    alias TypeTuple!(__traits(parent, fn))[0] Parent;
    enum IsEponymousTemplateFunction = is(typeof(Parent) == typeof(fn));
}

template alias_selector(alias fn, fn_t) {
    alias ParameterTypeTuple!fn_t ps; 
    alias ReturnType!fn_t ret;
    alias TypeTuple!(__traits(parent, fn))[0] Parent;
    enum nom = __traits(identifier, fn);
    template IsDesired(alias f) {
        alias ParameterTypeTuple!f fps;
        alias ReturnType!f fret;
        enum bool IsDesired = is(ps == fps) && is(fret == ret);
    }
    static if(IsEponymousTemplateFunction!fn) {
        alias TypeTuple!(fn) Overloads;
    }else{
        alias TypeTuple!(__traits(getOverloads, Parent, nom)) Overloads;
    }
    alias Filter!(IsDesired, Overloads) VOverloads;
}