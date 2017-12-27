# RungeKuttaUtilities


**RungeKuttaUtilities** is a Wolfram Language package that automates
the derivation of order conditions for Runge-Kutta methods. This
functionality is also present in the Wolfram Language's built-in
`NumericalDifferentialEquationAnalysis` package, but
RungeKuttaUtilities is several orders of magnitude faster and
more memory-efficient. This allows order conditions to be derived
for much higher orders than previously feasible (up to *p = 23* on my personal laptop).

RungeKuttaUtilities' efficiency gains are based on the observation
that the properties of rooted trees on *n* vertices relevant to the
analysis of Runge-Kutta methods (namely, their Butcher weights and
densities) can be recursively calculated from the corresponding
values for rooted trees on *n - 1* vertices. Crucially, this can be
done in a fashion that avoids having to explicitly compute the
trees themselves, which is where
`NumericalDifferentialEquationAnalysis` spends much of its time and
memory.
