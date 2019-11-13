import os, parseopt
import fab

import fileMonitor

var sourceFileName: string
var persist: bool
var watch: bool

proc execNim(file: string) =
  let command = "nim c -r --outdir:/tmp " & file
  discard execShellCmd(command)

var parser = initOptParser()
for kind, key, value in parser.getopt():
  case kind
  of cmdArgument: sourceFileName = key
  of cmdLongOption, cmdShortOption:
    case key
    of "watch", "w": watch = true
    of "persist", "p": persist = true
  else: discard

if sourceFileName == "":
  echo "Specify Nim Source File"
elif watch:
  execNim(sourceFileName)
  fileMonitor(
    sourceFileName,
    callback =
      proc() =
        bold("RuNim: " & sourceFileName)
        execNim(sourceFileName)
  )
else:
  execNim(sourceFileName)
