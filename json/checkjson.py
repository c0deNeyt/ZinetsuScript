import json

try:
    with open("config.json", "r") as f:
        data = json.load(f)
except json.JSONDecodeError as e:
    print(f"JSON Parse Error: {e}")

