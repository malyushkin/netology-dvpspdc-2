# Практическое задание по теме «Языки разметки JSON и YAML»

1. Мы выгрузили JSON, который получили через API запрос к нашему сервису:
	```
    { "info" : "Sample JSON output from our service\t",
        "elements" :[
            { "name" : "first",
            "type" : "server",
            "ip" : 7175 
            },
            { "name" : "second",
            "type" : "proxy",
            "ip : 71.78.22.43
            }
        ]
    }
	```
  Нужно найти и исправить все ошибки, которые допускает наш сервис

Валидный JSON:

```json
{
   "info": "Sample JSON output from our service\t",
   "elements": [
      {
         "name": "first",
         "type": "server",
         "ip": 7175
      },
      {
         "name": "second",
         "type": "proxy",
         "ip": "71.78.22.43"
      }
   ]
}
```

---

2. В прошлый рабочий день мы создавали скрипт, позволяющий опрашивать веб-сервисы и получать их IP. К уже реализованному функционалу нам нужно добавить возможность записи JSON и YAML файлов, описывающих наши сервисы. Формат записи JSON по одному сервису: { "имя сервиса" : "его IP"}. Формат записи YAML по одному сервису: - имя сервиса: его IP. Если в момент исполнения скрипта меняется IP у сервиса - он должен так же поменяться в yml и json файле.

Скрипт [dns.py](dns.py):

```python
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
```

Результат работы скрипта в JSON [last_check.json](last_check.json):

```json
{
    "drive.google.com": "64.233.161.194",
    "mail.google.com": "74.125.205.18",
    "google.com": "173.194.221.139",
    "instagram.com": "157.240.205.174"
}
```

Результат работы скрипта в YAML [last_check.json](last_check.yaml):
```yaml
---
drive.google.com: 64.233.161.194
mail.google.com: 74.125.205.18
google.com: 173.194.221.139
instagram.com: 157.240.205.174
...
```
