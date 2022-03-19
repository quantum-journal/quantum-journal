###################################################################
# This file shows how to create a plot that integrates seamlessly
# with the quantumarticle document class using matplotlib and rsmf.
# This script requires the packages numpy, matplotlib and rsmf.
###################################################################

import numpy as np
import matplotlib.pyplot as plt
import rsmf

# Get formatter specifications from tex file
fmt = rsmf.setup("quantum-template.tex")

# Generate dummy spectral data
x = np.linspace(400, 800, 200)
y = (
    30 / (4 + ((x - 550) / 4) ** 2)
    + 30 / (12 + ((x - 650) / 12) ** 2)
    + 0.001 * x
    + np.random.normal(0, 0.1, 200)
)

fig = fmt.figure()

# plot data
data = plt.scatter(x, y, color="C0", alpha=0.7, marker="x")

# plot fits
y_fit1 = 30 / (4 + ((x - 550) / 4) ** 2)
plt.plot(x, y_fit1, color="C1", ls="--")

y_fit2 = 30 / (12 + ((x - 650) / 12) ** 2)
plt.plot(x, y_fit2, color="C2", ls="--")

y_fit3 = 0.001 * x
plt.plot(x, y_fit3, color="C3", ls="--")

y_fit = y_fit1 + y_fit2 + y_fit3
(fit,) = plt.plot(x, y_fit, color="C0")

plt.xlabel("$\\lambda$ [nm]")
plt.ylabel("$I$ [arb. un.]")
plt.legend([data, fit], ["Data", "Fit"])
plt.tight_layout(pad=0.0)

# Save the figure in PDF format
plt.savefig("example-plotpdf")
