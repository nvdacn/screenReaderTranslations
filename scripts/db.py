#!/usr/bin/env python3
import argparse
import sys
import json


class DB(dict):

    def __init__(self, fname='settings', autoSave=False, *args, **kwargs):
        super(DB, self).__init__(*args, **kwargs)
        # if settings file is corrupt or doesnt exist, make sure we end up with an empty dict.
        self.fname = fname
        self.autoSave = autoSave
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

    def __delitem__(self, key):
        super(DB, self).__delitem__(key)
        if self.autoSave:
            self.save()

    def __setitem__(self, key, value):
        super(DB, self).__setitem__(key, value)
        if self.autoSave:
            self.save()

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
    parser = argparse.ArgumentParser(description='Json db interface.')
    parser.add_argument('-f', '--file', default='settings', help='Use the given file as the database.')
    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument('-s', '--set', nargs=2, help='insert or update key/value.')
    group.add_argument('-g', '--get', help='name of key which should be looked up.')
    group.add_argument('-d', '--delete', help='name of key which should be deleted.')
    args = parser.parse_args()
    
    db = DB(args.file, autoSave=True)
    if args.get:
        print(db[args.get])
    elif args.set:
        k, v = args.set
        if v == '-': # user is giving us the data on stdin
            db[k] = sys.stdin.readlines()
        else:
            db[k] = v
    elif args.delete:
         try:
             del db[args.delete]
         except KeyError:
             pass
