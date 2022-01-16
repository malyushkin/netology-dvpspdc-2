import json
import yaml
from socket import gethostbyname

file_name = "last_check"
with open(file_name, "r") as file:
    lines = file.readlines()

dns = {line.split()[0]: line.split()[1] for line in lines}

for name in dns.keys():
    if gethostbyname(name) != dns[name]:
        print(f"[ERROR] {name} IP mismatch: {dns[name]} {gethostbyname(name)}")
        dns[name] = gethostbyname(name)

    # Save plain text
    with open(file_name, "w") as plain_file:
        for dns_item in dns:
            plain_file.write(f"{dns_item}\t{dns[dns_item]}\n")

    # Save JSON
    with open(f"{file_name}.json", "w") as json_file:
        json_file.write(json.dumps(dns, indent=4))

    # Save YAML
    with open(f"{file_name}.yaml", "w") as yaml_file:
        yaml_file.write(yaml.dump(dns, indent=4, sort_keys=False, explicit_start=True, explicit_end=True))
