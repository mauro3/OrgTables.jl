# OrgTables

[![Build Status](https://travis-ci.org/mauro3/OrgTables.jl.svg?branch=master)](https://travis-ci.org/mauro3/OrgTables.jl)
[![Build status](https://ci.appveyor.com/api/projects/status/eb1uam230dreew0r?svg=true)](https://ci.appveyor.com/project/mauro3/orgtables-jl)

A Julia package to read emacs
[org-mode tables](http://orgmode.org/guide/Tables.html).  Essentially,
any line starting with `|` as first non-whitespace is considered part
of a table.  Horizontal lines `|----+---|` are ignored.  Only the
first table in a file is read.

This reads an org-table (in `test/testtable2.org`) into a
`Matrix{Float64}` replacing empty strings with `NaN`s:

```julia
using OrgTables
data,header = readorg("testtable2.org", Float64, NaN)
```

It works with FileIO.jl, but needs to be loaded explicitly (not
registered with FileIO.jl):
```julia
using OrgTables, FileIO
data,header = load("testtable2.org", T=Float64, fillval=NaN)
```


TODO:

- support several tables in one file
- make a writer
