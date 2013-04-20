#!/usr/bin/env python3
import sys, json

class DB(dict):

    def __init__(self, fname='settings', *args):
        super(DB, self).__init__(*args)
        # if settings file is corrupt or doesnt exist, make sure we end up with an empty dict.
        self.fname = fname
        f = open(fname, 'r')
        try:
            self.update(json.load(f))
        except ValueError:
            pass
        f.close()

    def __getitem__(self, key):
        try:
            return super(DB, self).__getitem__(key)
        except:
            return 0
    def echo(self):
        return ("hello world\n" +
               "this is a test message." +
               "this is the end.")

    def save(self):
        ## prune keys that have no content.
        rkeys = []
        for key in self.keys():
            if not self[key]: rkeys.append(key)
        for key in rkeys:
            del self[key]

        ## write out the remaining keys to file.
        f = open(self.fname, 'w')
        json.dump(self, f, indent=2, ensure_ascii=False, sort_keys=True)
        f.close()

##############
if __name__ == "__main__" and len(sys.argv) >= 1:
    db = DB()
    # user wanted to store a key/value pair.
    if sys.argv[1] == 'get':
        print(db[sys.argv[2]])
    elif sys.argv[1] == 'set':
        if sys.argv[3] == '-': # user is giving us the data on stdin
            db[sys.argv[2]] = sys.stdin.readlines()
        else:
            db[sys.argv[2]] = sys.argv[3]
    # user wishes to remove a key.
    elif sys.argv[1] == 'del':
        try:
            del db[sys.argv[2]]
        except KeyError:
            pass
    else:
        print("dont know what to do.")

    db.save()

