#!/usr/bin/env python3
import sys, json

settingsFile = 'settings'

# if settings file is corrupt or doesnt exist, make sure we end up with an empty dict.
f = open(settingsFile, 'r')
try:
    data = json.load(f)
except ValueError:
    data = {}
f.close()

# user wants the value of a key, if not found return 0
if sys.argv[1] == 'get':
    try:
        print(data[sys.argv[2]])
    except:
        print("key not found.")
        print("0")

# user wanted to store a key/value pair.
elif sys.argv[1] == 'set':
    if sys.argv[3] == '-': # user is giving us the data on stdin
        data[sys.argv[2]] = sys.stdin.readlines()
    else:
        data[sys.argv[2]] = sys.argv[3]

# user wishes to remove a key.
elif sys.argv[1] == 'del':
    try:
        del data[sys.argv[2]]
    except KeyError:
        pass
else:
    print("dont know what to do.")

## prune keys that have no content.
rkeys = []
for key in data.keys():
    if not data[key]: rkeys.append(key)
for key in rkeys:
    del data[key]

## write out the remaining keys to file.
f = open(settingsFile, 'w')
json.dump(data, f, indent=2, ensure_ascii=False, sort_keys=True)
f.close()

