#!/usr/bin/env python3
import sys, json
settingsFile = 'settings'
f = open(settingsFile, 'r')
try:
    data = json.load(f)
except ValueError:
    data = {}
f.close()


if sys.argv[1] == 'get':
    try:
        print(data[sys.argv[2]])
    except:
        print("key not found.")
        print("0")
elif sys.argv[1] == 'set':
    if sys.argv[3] == '-':
        data[sys.argv[2]] = sys.stdin.readlines()
    else:
        data[sys.argv[2]] = sys.argv[3]
elif sys.argv[1] == 'del':
    try:
        del data[sys.argv[2]]
    except KeyError:
        pass
else:
    print("dont know what to do.")

f = open(settingsFile, 'w')
json.dump(data, f, indent=2, ensure_ascii=False, sort_keys=True)
f.close()

