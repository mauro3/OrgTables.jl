using OrgTables
using Base.Test

r,h=readorg("testtable3.org", HeaderT=ASCIIString)
@test h==ASCIIString[]
@test typeof(r)==Matrix{UTF8String}

r,h=readorg("testtable1.org")
@test h==UTF8String["X","Y","id","r-dists contour","f","contours","dB","bed ele","bmax","Surf DEM","remarks"]
@test typeof(r)==Matrix{UTF8String}

r,h=readorg("testtable2.org", Float64, NaN)
@test h==UTF8String["X","Y","r-dists contour","f","dB","bed ele","bmax","Surf  DEM"]
@test typeof(r)==Matrix{Float64}
@test all([x[1]===x[2] for x in zip(r[1,:],[624479.0  232874.0    1.0  NaN    NaN     376.0   NaN    434.0])])
