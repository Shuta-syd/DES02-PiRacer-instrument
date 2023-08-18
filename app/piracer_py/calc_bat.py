import numpy as np
from scipy.optimize import curve_fit
import matplotlib.pyplot as plt

            # battery info: 
            # sanyo 18650
            # number of cells: 3
            # discharhing curve per cell: https://lygte-info.dk/info/BatteryChargePercent%20UK.html
            # voltage per cell while discharching: 4.2, 4.1, 4.0, 3.9, 3.8, 3.7, 3.6, 3.5, 3.4, 3.3, 3.2
            # battery level per cell in % while discharhing: 100, 91, 79, 62, 42, 12, 2, 0, 0 ,0 ,0

# Given data
voltage = np.array([4.2, 4.1, 4.0, 3.9, 3.8, 3.7, 3.6, 3.5, 3.4, 3.3, 3.2])
battery_level = np.array([100, 91, 79, 62, 42, 12, 2, 0, 0, 0, 0])

# Define the function to fit (exponential decay)
def exponential_decay(x, a, b, c):
    return a * np.exp(-b * x) + c

# Perform the curve fit
params, covariance = curve_fit(exponential_decay, voltage, battery_level)

# Extract the parameters
a_fit, b_fit, c_fit = params

# Generate points for the fitted curve
voltage_fit = np.linspace(min(voltage), max(voltage), 100)
battery_level_fit = exponential_decay(voltage_fit, a_fit, b_fit, c_fit)

# Plot the original data and the fitted curve
plt.scatter(voltage, battery_level, label="Original Data")
plt.plot(voltage_fit, battery_level_fit, label="Fitted Curve")
plt.xlabel("Voltage (V)")
plt.ylabel("Battery Level (%)")
plt.legend()
plt.show()

# Print the fitted parameters
print("Fitted Parameters:")
print("a:", a_fit)
print("b:", b_fit)
print("c:", c_fit)

# print formular of curve in terminal
print("Formular of curve:")
print(f"y = {a_fit:.3f} * exp(-{b_fit:.3f} * x) + {c_fit:.3f}")
