#!/usr/bin/python

import sys
import os

if __name__ == "__main__":
  argv = sys.argv
  argv.pop(0)
  if "--numeric-version" in argv:
    os.system("ghc --numeric-version")
    sys.exit()
  print "== GHC Arguments: Start =="
  for arg in argv:
    print arg
  print "== GHC Arguments: End =="
