(* ::Package:: *)

(* ::Title:: *)
(*The ExportMatlab package*)


(* ::Text:: *)
(*A wrapper around "ToMatlab".*)
(*Two main features:*)
(*	* Better conversion of non-ascii characters*)
(*	* Matlab translation is delayed so that a variable's definition can be updated*)


(* ::Subsection:: *)
(*This is the beginning*)


BeginPackage["MatlabExport`",{"ToMatlab`"}];


(* ::Text:: *)
(*Objects to export:*)


MatlabExport::usage = 
  "MatlabExport[<expr>,<equals string>]:
     Saves the Mathematica code <expr> to be converted to
     Matlab by `MatlabShow`. <equals string> is the prepended
     Matlab variable to be used; if omitted, the string form
     of <expr> is used instead. This is useful for cases like
        x = Sqrt[y^2+z^2];
        MatlabExport[x]
  ";

MatlabShow::usage = 
  "MatlabShow:
     Prints out the list of Matlab translations that have
     been stored by `ExportMatlab`.";

MatlabSubs::usage = 
  "MatlabSubs[<expr>]:  
     Appends <expr> to the `matlabsubs` list.";

MatlabString::usage = 
  "MatlabString[<expr>]:
     Converts a Mathematica expression to Matlab syntax 
     immediately. Useful for testing purposes.";

matlabtranslations::usage = 
  "matlabtranslations (list):
     Internal list of expressions to be converted to Matlab
     that is created by the `MatlabExport` command. Converted 
     to Matlab syntax and printed by the `MatlabShow` command.";

matlabsubs::usage = 
  "matlabsubs (list):
     List of transformation rules to apply to expressions 
     before they are converted to Matlab form during the
     execution of `MatlabExport`.";


(* ::Subsection:: *)
(*Package internals*)


Begin["`Private`"];


(* ::Subsubsection:: *)
(*Public methods*)


MatlabExport[in_] := MatlabExport[in,ToString@HoldForm@in]
MatlabExport[in_,equals_] := 
Module[{eq,p,s},
  eq = equals <> "...\n  ";
  s := SafeString[in,matlabsubs];
  p := Position[matlabtranslations,{_,eq,_}];
  If[ p==={} ,
  (* if this symbol not yet translated, add it to the list: *) 
    AppendTo[matlabtranslations,{s,eq,50}],
  (* otherwise, replace it in the list: *) 
    matlabtranslations = ReplacePart[matlabtranslations,{s,eq,50},p]];
]


MatlabString[in_] := SafeString[in,matlabsubs] // ToString


MatlabShow := Module[{},
  Print /@ ToMatlab @@@ matlabtranslations;
  matlabtranslations := {} ]


MatlabSubs[expr__] := AppendTo[matlabsubs,#]& /@ {expr} 


(* ::Text:: *)
(*Initialise:*)


matlabtranslations := {}
matlabsubs := {}


(* ::Subsubsection:: *)
(*"Sanitising" functions*)


(* ::Text:: *)
(* Make the Mathematica code suitable for plain text. This code*)
(*	* converts Greek characters to ASCII*)
(*	* removes time arguments*)
(*	* converts subscripts to concatenations, and*)
(*	* transforms derivatives into an ASCII representation.*)


SafeString[in_] := SafeString[in,{}]
SafeString[in_,subs_] := 
Module[{out},
  out := in //. subs 
    //. x_[Global`t] -> x (* that Global` took me a long time to debug *)
    //. Subscript[x_,y_] :>           
        Symbol[ToString[HoldForm[x]] <> ToString[y]]     
    //. Derivative[x__][y__][z__] :>         
        Symbol[ToString[y] <> "d" <> StringJoin @@ ToString /@ List[x]]
    //. Derivative[x__][y__] :> 
        Symbol[ToString[y] <> "d" <> StringJoin @@ ToString /@ List[x]];
gr2rom[out]]


(* ::Text:: *)
(*Transforming Greek symbols to ASCII with decent names:*)


gr2rom[x_] := 
Module[{s},
  s = ToString[FullForm[x]];
  s = StringReplace[s,{RegularExpression["\\\\\[(\\w+)\\]"] -> "$1"}];
  s = StringReplace[s,{"Curly" -> "Var"}];
ToExpression[s]]


(* ::Subsection:: *)
(*The end*)


(* ::Text:: *)
(*Thanks for coming.*)


End[];
EndPackage[]
