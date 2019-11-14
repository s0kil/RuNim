import os, parseopt
import fab

import fileMonitor

var sourceFileName: string
# TODO : `persist` Ask User To Proceed With Compilation After File Change
# var persist: bool
var watch, silent: bool

proc execNim(file: string, silent: bool = false) =
  var command: string
  if silent == true:
    command = "nim c --run --verbosity:0 --hints:off --outdir:/tmp " & file
  else:
    command = "nim c --run --outdir:/tmp " & file
  discard execShellCmd(command)

var parser = initOptParser()
for kind, key, value in parser.getopt():
  case kind
  of cmdArgument: sourceFileName = key
  of cmdLongOption, cmdShortOption:
    case key
    of "watch", "w": watch = true
    of "silent", "s": silent = true
    # of "persist", "p": persist = true
  else: discard

if sourceFileName == "":
  echo "Specify Nim Source File"
elif watch:
  execNim(sourceFileName, silent)
  fileMonitor(
    sourceFileName,
    callback =
      proc() =
        bold("RuNim: " & sourceFileName)
        execNim(sourceFileName, silent)
  )
else:
  execNim(sourceFileName, silent)
