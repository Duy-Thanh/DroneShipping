import numpy as np
import matplotlib.pyplot as plt

def load_ngspice_data(filename):
    """Load data from ngspice output file"""
    try:
        # Load all data using numpy's loadtxt, skipping header row
        data = np.loadtxt(filename, skiprows=1)  # Skip the header row
        print(f"Loaded {len(data)} data points")
        
        # Debug: print first few rows to check column order
        print("\nFirst few data points:")
        print("Time\tVDD\tVDD_INT\tVOK\tPOR_n\tI(V1)\tVDDA_INT")
        for row in data[:3]:
            print("\t".join([f"{x:.6f}" for x in row]))
            
        if len(data.shape) == 1:
            print("Warning: Data appears to be 1D, reshaping...")
            num_columns = 7  # time + 6 variables
            num_rows = len(data) // num_columns
            data = data.reshape(num_rows, num_columns)
            print(f"Reshaped to {data.shape}")
            
        return data
        
    except Exception as e:
        print(f"Error loading data: {e}")
        # Try reading file to see what's in it
        try:
            with open(filename, 'r') as f:
                print("\nFile contents (first few lines):")
                for i, line in enumerate(f):
                    if i < 5:  # Print first 5 lines
                        print(line.strip())
        except Exception as f:
            print(f"Could not read file: {f}")
        return np.array([])

def plot_power_results():
    # Load simulation data
    data = load_ngspice_data('power_test.txt')
    
    if len(data) == 0:
        print("No data to plot!")
        return
        
    # Create figure with subplots
    fig = plt.figure(figsize=(12, 10))
    gs = fig.add_gridspec(3, 1, height_ratios=[1, 1, 1])
    
    # 1. Power Supply Voltages
    ax1 = fig.add_subplot(gs[0])
    ax1.plot(data[:,0]*1e6, data[:,1], 'b-', label='VDD', linewidth=2)
    ax1.plot(data[:,0]*1e6, data[:,2], 'r-', label='VDD_INT', linewidth=2)
    ax1.plot(data[:,0]*1e6, data[:,6], 'g-', label='VDDA_INT', linewidth=2)
    ax1.set_ylabel('Voltage (V)')
    ax1.set_title('Power Supply Voltages')
    ax1.set_ylim(0, 4)
    ax1.grid(True)
    ax1.legend()
    
    # 2. Control Signals
    ax2 = fig.add_subplot(gs[1])
    ax2.plot(data[:,0]*1e6, data[:,3], 'b-', label='VOK', linewidth=2)
    ax2.plot(data[:,0]*1e6, data[:,4], 'r-', label='POR_n', linewidth=2)
    ax2.set_ylabel('Voltage (V)')
    ax2.set_title('Control Signals')
    ax2.set_ylim(0, 4)
    ax2.grid(True)
    ax2.legend()
    
    # 3. Current Consumption
    ax3 = fig.add_subplot(gs[2])
    ax3.plot(data[:,0]*1e6, -data[:,5]*1000, 'b-', label='Current', linewidth=2)
    ax3.set_xlabel('Time (µs)')
    ax3.set_ylabel('Current (mA)')
    ax3.set_title('Power Consumption')
    ax3.grid(True)
    ax3.legend()
    
    # Set x-axis limits for all plots
    for ax in [ax1, ax2, ax3]:
        ax.set_xlim(0, data[-1,0]*1e6)
    
    # Adjust layout and display
    plt.tight_layout()
    plt.show()

def analyze_power_sequence():
    """Analyze power-up sequence timing"""
    data = load_ngspice_data('power_test.txt')
    
    if len(data) == 0:
        print("No data to analyze!")
        return
        
    # Print voltage ranges for debugging
    print(f"\nVoltage ranges:")
    print(f"VDD: {np.min(data[:,1]):.3f}V to {np.max(data[:,1]):.3f}V")
    print(f"VDD_INT: {np.min(data[:,2]):.3f}V to {np.max(data[:,2]):.3f}V")
    print(f"VOK: {np.min(data[:,3]):.3f}V to {np.max(data[:,3]):.3f}V")
    print(f"POR_n: {np.min(data[:,4]):.3f}V to {np.max(data[:,4]):.3f}V")
        
    # Find key timing points with lower threshold
    vdd_ok = np.where(data[:,1] > 2.7)[0]  # Changed from 3.0V to 2.7V
    por_release = np.where(data[:,4] > 2.7)[0]  # Changed from 3.0V to 2.7V
    
    if len(vdd_ok) == 0 or len(por_release) == 0:
        print("Warning: Could not find voltage transitions!")
        print(f"VDD samples > 2.7V: {len(vdd_ok)}")
        print(f"POR samples > 2.7V: {len(por_release)}")
        return
    
    vdd_ok = vdd_ok[0]
    por_release = por_release[0]
    
    # Print timing analysis
    print("\nPower Sequence Analysis:")
    print(f"VDD reach 2.7V: {data[vdd_ok,0]*1e6:.1f} µs")
    print(f"POR release: {data[por_release,0]*1e6:.1f} µs")
    print(f"Startup time: {data[por_release,0]*1e6 - data[vdd_ok,0]*1e6:.1f} µs")

def check_voltage_levels():
    """Verify voltage levels are within spec"""
    data = load_ngspice_data('power_test.txt')
    
    if len(data) == 0:
        print("No data to analyze!")
        return
        
    # Check voltage ranges after 100µs
    stable_idx = np.where(data[:,0] > 100e-6)[0]
    if len(stable_idx) == 0:
        print("Warning: No data points after 100µs!")
        return
        
    vdd_min = np.min(data[stable_idx,1])
    vdd_max = np.max(data[stable_idx,1])
    ripple = np.max(np.abs(data[stable_idx,2] - data[stable_idx,1]))
    
    print("\nVoltage Level Analysis:")
    print(f"VDD range: {vdd_min:.3f}V to {vdd_max:.3f}V")
    print(f"Maximum ripple: {ripple*1000:.1f} mV")

if __name__ == '__main__':
    # Run all analyses
    plot_power_results()
    analyze_power_sequence()
    check_voltage_levels()