# OrgTables

[![Build Status](https://travis-ci.org/mauro3/OrgTables.jl.svg?branch=master)](https://travis-ci.org/mauro3/OrgTables.jl)

A Julia package to read emacs
[org-mode tables](http://orgmode.org/guide/Tables.html).  Essentially,
any line starting with `|` as first non-whitespace is considered part
of a table.  Horizontal lines `|----+---|` are ignored.  Only the
first table in a file is read.

```julia
using OrgTables
r,h=readorg("testtable2.org", Float64, NaN)
```

TODO:

- support several tables in one file
- make a writer
