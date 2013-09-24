#!/usr/bin/env python
# encoding: utf-8
import json
import argparse
parser = argparse.ArgumentParser(description='Utility to check that the given file is json readable.')
parser.add_argument('-f', '--file', required=True, help='file to be checked.')
args = parser.parse_args()
with open(args.file) as f:
    try:
        data = json.load(f)
    except Exception as e:
        print("error: %s" %e.message)
    else:
        print("all good.")

