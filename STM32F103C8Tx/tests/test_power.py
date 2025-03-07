import numpy as np
import matplotlib.pyplot as plt

def plot_power_results():
    # Load simulation data
    data = np.loadtxt('power_test.txt', skiprows=1)

    # Plot results
    fig, (ax1, ax2) = plt.subplots(2, 1, figsize=(10, 8))

    # Voltage plots
    ax1.plot(data[:,0], data[:,1], label='VDD')
    ax1.plot(data[:,0], data[:,2], label='VDD_INT')
    ax1.plot(data[:,0], data[:,3], label='VOK')
    ax1.plot(data[:,0], data[:,4], label='POR_n')
    ax1.set_ylabel('Voltage (V)')
    ax1.legend()

    # Current plot
    ax2.plot(data[:,0], data[:,5]*1000, label='Current (mA)')
    ax2.set_xlabel('Time (s)')
    ax2.set_ylabel('Current (mA)')
    ax2.legend()
    
    plt.show()

if __name__ == '__main__':
    plot_power_results()