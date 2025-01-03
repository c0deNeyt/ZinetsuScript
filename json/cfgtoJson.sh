#!/bin/bash

# Input and output files
input_file="/media/sf_Linux/sandbox/Json/file.cfg"

import csv

# Input CFG file
cfg_file = "config.cfg"

# Output CSV file
output_file = "output.csv"

def parse_cfg_to_csv(lines):
    """
    Parse a CFG file and output rows for a CSV.
    Each row contains the flattened key hierarchy and its value.
    """
    rows = []
    stack = []  # To track the nesting hierarchy
    
    for line in lines:
        line = line.strip()
        if not line or line.startswith("#"):
            # Skip empty lines and comments
            continue
        if line.endswith("{"):
            # Start of a new block
            key = line.split("{")[0].strip()
            stack.append(key)
        elif line == "}":
            # End of a block
            if stack:
                stack.pop()
        elif "=" in line and line.endswith(";"):
            # Key-value pair
            key, value = map(str.strip, line[:-1].split("=", 1))
            # Handle list values (denoted by brackets [ ])
            if value.startswith("[") and value.endswith("]"):
                value = ", ".join(value[1:-1].split())
            # Build the full key hierarchy
            full_key = ".".join(stack + [key])
            rows.append({"Key": full_key, "Value": value})
    return rows

def convert_cfg_to_csv(cfg_file, output_file):
    # Read the CFG file
    with open(cfg_file, "r") as file:
        lines = file.readlines()

    # Parse the CFG into rows for CSV
    rows = parse_cfg_to_csv(lines)

    # Write rows to the CSV file
    with open(output_file, "w", newline="") as file:
        writer = csv.DictWriter(file, fieldnames=["Key", "Value"])
        writer.writeheader()
        writer.writerows(rows)

    print(f"Converted CSV written to {output_file}")

# Run the conversion
convert_cfg_to_csv(cfg_file, output_file)

