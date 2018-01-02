# RungeKuttaUtilities


**RungeKuttaUtilities** is a Wolfram Language package that automates
the derivation of order conditions for Runge-Kutta methods. This
functionality is also present in the Wolfram Language's built-in
`NumericalDifferentialEquationAnalysis` package, but
RungeKuttaUtilities is several orders of magnitude faster and
more memory-efficient. This allows order conditions to be derived
for much higher orders than previously feasible (up to *p = 23*
on my personal laptop).

RungeKuttaUtilities' efficiency gains are based on the observation
that the properties of rooted trees on *n* vertices relevant to the
analysis of Runge-Kutta methods (namely, their Butcher weights and
densities) can be recursively calculated from the corresponding
values for rooted trees on *n - 1* vertices. Crucially, this can be
done in a fashion that avoids having to explicitly compute the
trees themselves, which is where
`NumericalDifferentialEquationAnalysis` spends much of its time and
memory.

# Installation

**RungeKuttaUtilities** is a single-file package written purely in
the Wolfram Language with no external dependencies. To install,
simply download the `RungeKuttaUtilities.wl` file from this repository
and open it with *Mathematica*. Then, open the **File ⇨ Install...**
dialog, and select the following options:

- Type of Item to Install: **Package**
- Source: **RungeKuttaUtilities.wl**
- Install Name: **RungeKuttaUtilities** (no `.wl` suffix)

Choose installation for all users or the current user only, according
to your preference, and click OK. You should now be able to execute
``Needs["RungeKuttaUtilities.wl`"];`` from any notebook and call
functions defined by RungeKuttaUtilities.

# Documentation

All functions defined by **RungeKuttaUtilities** come with `::usage`
strings that explain their functionality. These can be viewed by using
Mathematica's `Information` operator (e.g., `?ButcherGammaTable`).

For simplicity, all functions defined by **RungeKuttaUtilities** take
a single positive integer parameter and remain unevaluated when called
with invalid parameters. Symbolic results are returned using formal
symbols in the same manner as `NumericalDifferentialEquationAnalysis`.
