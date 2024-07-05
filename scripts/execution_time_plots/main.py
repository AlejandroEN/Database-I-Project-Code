import json

import matplotlib.pyplot as plt

from scripts.utils.get_file_content import get_file_content

json_file = get_file_content(r".\assets\json\query_1_execution_times.json")

data_dict = json.loads(json_file)

# Extract data for plotting
sizes = list(data_dict.keys())
unindexed = [data_dict[size]['unindexed'] for size in sizes]
indexed_default = [data_dict[size]['indexed_default'] for size in sizes]
indexed_custom = [data_dict[size]['indexed_custom'] for size in sizes]

# Plotting
plt.figure(figsize=(10, 6))
plt.plot(sizes, unindexed, label='Unindexed', marker='o')
plt.plot(sizes, indexed_default, label='Indexed Default', marker='o')
plt.plot(sizes, indexed_custom, label='Indexed Custom', marker='o')


plt.xlabel("Cantidad de Registros")
plt.ylabel("Costo promedio (ms)")
plt.title("Comparación de Consultas")
plt.legend()
plt.grid(True)

# Save the plot as a PNG file
output_file = "consulta_comparison.png"
plt.savefig(output_file)

plt.show()

print(f"Plot saved as {output_file}")
