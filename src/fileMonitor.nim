import os, times

let modifiedTime =
  proc(filePath: string): auto =
    os.getLastModificationTime(filePath).toUnix()

proc fileMonitor*(
  filePath: string,
  latency: int = 100,
  callback: proc
) =
  var modifiedLast = modifiedTime(filePath)

  while true:
    os.sleep(latency)
    var modified = modifiedTime(filePath)

    if (modified - modifiedLast > 0):
      modifiedLast = modified
      callback()
