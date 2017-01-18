using OrgTables
using Base.Test

r,h=readorg("testtable3.org", HeaderT=String)
@test h==String[]
@test typeof(r)==Matrix{String}

r,h=readorg("testtable1.org")
@test h==String["X","Y","id","r-dists contour","f","contours","dB","bed ele","bmax","Surf DEM","remarks"]
@test typeof(r)==Matrix{String}

r,h=readorg("testtable2.org", Float64, NaN)
@test h==String["X","Y","r-dists contour","f","dB","bed ele","bmax","Surf  DEM"]
@test typeof(r)==Matrix{Float64}
@test all([x[1]===x[2] for x in zip(r[1,:],[624479.0, 232874.0, 1.0, NaN, NaN, 376.0, NaN, 434.0])])

r,h=readorg("testtable1.org", Float64, NaN, drop=[3,6,11])
@test h==String["X","Y","r-dists contour","f","dB","bed ele","bmax","Surf DEM"]
@test typeof(r)==Matrix{Float64}

# test FileIO.jl inerop
using FileIO
r,h=load("testtable3.org", HeaderT=String)
@test h==String[]
@test typeof(r)==Matrix{String}

r,h=load("testtable1.org")
@test h==String["X","Y","id","r-dists contour","f","contours","dB","bed ele","bmax","Surf DEM","remarks"]
@test typeof(r)==Matrix{String}

r,h=load("testtable2.org", T=Float64, fillval=NaN)
@test h==String["X","Y","r-dists contour","f","dB","bed ele","bmax","Surf  DEM"]
@test typeof(r)==Matrix{Float64}
@test all([x[1]===x[2] for x in zip(r[1,:],[624479.0, 232874.0, 1.0, NaN, NaN, 376.0, NaN, 434.0])])

r,h=load("testtable1.org", T=Float64, fillval=NaN, drop=[3,6,11])
@test h==String["X","Y","r-dists contour","f","dB","bed ele","bmax","Surf DEM"]
@test typeof(r)==Matrix{Float64}
