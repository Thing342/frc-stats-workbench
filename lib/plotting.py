import matplotlib.pyplot as plt
import numpy as np

def plot_with_fit(x, y, yhat, names, delta=2.0):
    fig, ax = plt.subplots()
    ax.scatter(x, y)
    ax.plot(np.unique(x), np.poly1d(np.polyfit(x, y, 1))(np.unique(x)))
    plt.xlabel("Average Match Margin")
    plt.ylabel("Win Pct")
    
    error = y - yhat
    error_z = (error - error.mean()) / error.std()

    for name in names:
        if abs(error_z[name]) > delta: 
            ax.annotate(name, (x[name], y[name]))