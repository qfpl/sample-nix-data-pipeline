import os, sys

def interleave(in1, in2):
  m = max(len(in1), len(in2))
  pad1 = in1 + (m - len(in1)) * [""]
  pad2 = in2 + (m - len(in2)) * [""]
  z = zip(pad1, pad2)

  res = []
  for (a, b) in z:
      res += a
      res += b

  return res

def main():
  fileIn1 = open(sys.argv[1], "r")
  fileIn2 = open(sys.argv[2], "r")
  fileOut = open(sys.argv[3], "w+")

  contents1 = fileIn1.readlines()
  contents2 = fileIn2.readlines()

  fileOut.writelines(interleave(contents1, contents2))

  fileOut.close()
  fileIn2.close()
  fileIn1.close()
