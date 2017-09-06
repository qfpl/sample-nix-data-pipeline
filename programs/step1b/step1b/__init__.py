import os, sys

def spaceMe(str):
  res = ""
  for s in str:
      res += s
      res += " "
  return res

def main():
  fileIn = open(sys.argv[1], "r")
  fileOut = open(sys.argv[2], "w+")

  contents = fileIn.read()

  fileOut.write(spaceMe(contents))

  fileOut.close()
  fileIn.close()


