fs        = require 'fs'
path      = require 'path'
HOMEDIR   = path.join __dirname, '..'
LIB_COV   = path.join HOMEDIR, 'lib-cov'
LIB       = path.join HOMEDIR, 'lib'
LIB_DIR   = if fs.existsSync(LIB_COV) then LIB_COV else LIB

export_source_file = (file)->
  target = exports
  if Array.isArray(file)
    for p in file[0...-1]
      target[p] ?= {}
      target = target[p]
    file = path.join(file...)
  exported = require path.join(LIB_DIR,file)
  for k,v of exported
    target[k] = v

sources = [
  'connection-factory'
  'sql-client'
  'sql-client-pool'
 ]

for file in sources
  export_source_file(file)

conditional_sources = [
  ['pg', 'postgresql-client' ]
 ]

for [required_module, file] in conditional_sources
  try
    require(required_module)
    export_source_file(file)
  catch err
    console.log("required module not available so do not load source file")

console.log exports
