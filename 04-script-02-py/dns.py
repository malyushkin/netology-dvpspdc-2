from socket import gethostbyname

file = open("last_check", "r")
lines = file.readlines()
dns = {line.split()[0]: line.split()[1] for line in lines}

for name in dns.keys():
    if gethostbyname(name) != dns[name]:
        print(f"[ERROR] {name} IP mismatch: {dns[name]} {gethostbyname(name)}")

    print(f"{name}: {gethostbyname(name)}")
