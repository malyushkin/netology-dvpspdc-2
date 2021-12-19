#!/usr/bin/env python3

import os
import sys

if len(sys.argv) < 2:
    sys.exit()

bash_command_path = [f"cd {sys.argv[1]}", "pwd"]
path = os.popen(' && '.join(bash_command_path)).read().rstrip() + '/'

bash_command = [f"cd {sys.argv[1]}", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
is_change = False
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(path + prepare_result)