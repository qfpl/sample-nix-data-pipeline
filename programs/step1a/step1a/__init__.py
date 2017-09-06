import os, sys

def main():
  fileIn = open(sys.argv[1], "r")
  fileOut = open(sys.argv[2], "w+")

  contents = fileIn.read()
  fileOut.write(contents.upper())

  fileOut.close()
  fileIn.close()


