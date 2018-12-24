(* ::Package:: *)

(* :Title: RungeKuttaUtilities *)
(* :Context: RungeKuttaUtilities` *)
(* :Author: David K. Zhang *)
(* :Date: 2018-12-23 *)

(* :Package Version: 1.1 *)
(* :Wolfram Language Version: 11.2 *)

(* :Summary: RungeKuttaUtilities is a Wolfram Language package that automates
             the derivation of order conditions for Runge-Kutta methods. This
             functionality is also present in the Wolfram Language's built-in
             NumericalDifferentialEquationAnalysis package, but
             RungeKuttaUtilities is several orders of magnitude faster and
             more memory-efficient. This allows order conditions to be derived
             for much higher orders than previously feasible (up to p = 25).

             RungeKuttaUtilities' efficiency gains are based on the observation
             that the properties of rooted trees on n vertices relevant to the
             analysis of Runge-Kutta methods (namely, their Butcher weights and
             densities) can be recursively calculated from the corresponding
             values for rooted trees on n - 1 vertices. Crucially, this can be
             done in a fashion that avoids having to explicitly compute the
             trees themselves, which is where
             NumericalDifferentialEquationAnalysis spends much of its time and
             memory. *)

(* :Copyright: (c) 2017-2019 David K. Zhang

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE. *)

BeginPackage["RungeKuttaUtilities`"];

ButcherTreeTable::usage = "\!\(\*RowBox[{\"ButcherTreeTable\", \"[\", \
StyleBox[\"n\", \"TI\"], \"]\"}]\) gives a list of all rooted trees on \
\!\(\*StyleBox[\"n\", \"TI\"]\) vertices. Each vertex is represented by \
the formal symbol \[FormalF], siblings are represented as products, and \
children are represented as nested expressions.";

ButcherGammaTable::usage = "\!\(\*RowBox[{\"ButcherGammaTable\", \"[\", \
StyleBox[\"n\", \"TI\"], \"]\"}]\) gives a list containing the density of \
each rooted tree on \!\(\*StyleBox[\"n\", \"TI\"]\) vertices in the order \
given by \!\(\*RowBox[{\"ButcherTreeTable\", \"[\", \
StyleBox[\"n\", \"TI\"], \"]\"}]\).";

ButcherPhiTable::usage = "\!\(\*RowBox[{\"ButcherPhiTable\", \"[\", \
StyleBox[\"n\", \"TI\"], \"]\"}]\) gives a list containing the weight of \
each rooted tree on \!\(\*StyleBox[\"n\", \"TI\"]\) vertices in the order \
given by \!\(\*RowBox[{\"ButcherTreeTable\", \"[\", \
StyleBox[\"n\", \"TI\"], \"]\"}]\) using stage-independent tensor notation.";

ButcherConditionTable::usage = "\!\(\*RowBox[{\"ButcherConditionTable\", \
\"[\", StyleBox[\"n\", \"TI\"], \"]\"}]\) gives a list of order conditions \
that define a Runge-Kutta method of order \!\(\*StyleBox[\"n\", \"TI\"]\) \
using stage-independent tensor notation.";

ButcherSigmaTable::usage = "\!\(\*RowBox[{\"ButcherSigmaTable\", \"[\", \
StyleBox[\"n\", \"TI\"], \"]\"}]\) gives a list containing the symmetry of \
each rooted tree on \!\(\*StyleBox[\"n\", \"TI\"]\) vertices in the order \
given by \!\(\*RowBox[{\"ButcherTreeTable\", \"[\", \
StyleBox[\"n\", \"TI\"], \"]\"}]\).";

Begin["`Private`"];

monomials[{x_}, n_Integer] := {x^n};
monomials[xs_List, 1] := xs;
monomials[{a_, b_}, 2] := {a^2, b^2, a*b};
monomials[xs_List, n_Integer] := Join @@ (
	Times @@ (xs^#)& /@ Permutations[#]& /@
		IntegerPartitions[n, {Length[xs]}, Range[0, n]]);

ButcherTreeTable[1] = {\[FormalF]};
ButcherTreeTable[n_Integer?Positive] := ButcherTreeTable[n] =
	\[FormalF] /@ Flatten[Outer[Times, ##]& @@@ Apply[
		monomials[ButcherTreeTable[#1], #2]&,
		Internal`IntegerPartitions[n - 1], {2}]];

ButcherGammaTable[1] = {1};
ButcherGammaTable[n_Integer?Positive] := ButcherGammaTable[n] =
	n * Flatten[Outer[Times, ##]& @@@ Apply[
		monomials[ButcherGammaTable[#1], #2]&,
		Internal`IntegerPartitions[n - 1], {2}]];

ButcherPhiTable[1] = {\[FormalC]};
ButcherPhiTable[n_Integer?Positive] := ButcherPhiTable[n] =
	(\[FormalB].#)& /@ Flatten[Outer[Times, ##]& @@@ Apply[
		monomials[ButcherPhiTable[#1] /. \[FormalB] -> \[FormalA], #2]&,
		Internal`IntegerPartitions[n - 1], {2}]];

ButcherConditionTable[1] = {\[FormalB].\[FormalE] == 1};
ButcherConditionTable[n_Integer?Positive] := MapThread[Equal,
	{ButcherPhiTable[n], 1 / ButcherGammaTable[n]}];

sigma[1] = sigma[\[FormalF]] = 1;
sigma[\[FormalF][t_]] := With[{facs = FactorList[t]}, Times[
	Times @@ Factorial[Last /@ facs],
	Times @@ Power @@@ MapAt[sigma, facs, {All, 1}]]];

ButcherSigmaTable[n_Integer?Positive] := ButcherSigmaTable[n] =
	sigma /@ ButcherTreeTable[n];

End[]; (* `Private` *)
EndPackage[]; (* RungeKuttaUtilities` *)
