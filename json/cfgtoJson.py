import json 

# Input CFG file
cfg_file = "/media/sf_Linux/sandbox/Json/newFile.cfg"

def parse_config(lines):
    """
    Recursively parses configuration lines into a nested dictionary.
    """
    config = {}
    stack = [config]
    
    for line in lines:
        line = line.strip()
        
        # Skip empty lines and comments
        if not line or line.startswith("#"):
            continue
        
        if line.endswith("{"):  # Start of a new block
            key = line[:-1].strip()
            stack[-1][key] = {}
            stack.append(stack[-1][key])  # Add new block to the stack
        
        elif line == "}":  # End of a block
            stack.pop()
        
        else:  # Key-value pair
            if "{" in line or "}" in line:
                continue
            
            if " " in line:
                key, value = line.split(" ", 1)
                stack[-1][key.strip()] = value.strip()
    
    return config

# Read the .cfg file
with open(cfg_file, "r") as file:
    cfg_lines = file.readlines()

# Parse the .cfg content into a dictionary
parsed_config = parse_config(cfg_lines)

# Convert the dictionary to JSON format
json_data = json.dumps(parsed_config, indent=4)

# Write the JSON data to a file
json_file = "config.json"  # Replace with your desired output file name
with open(json_file, "w") as file:
    file.write(json_data)

print(f"Conversion complete! JSON file saved as '{json_file}'.")

