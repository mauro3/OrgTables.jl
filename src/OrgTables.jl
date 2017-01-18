module OrgTables

# package code goes here
export readorg, writeorg

"""

Hlines `|---+...--|` are ignored.

If the first data-row is followed by a hline `|---+...--|` then it is
treated as a header.

Input:

- source: source file or IO stream
- T: eltype of array (default String)
- fillval: what to replace an empty string with.  Needs to be convertible to T

Kwargs:

- HeaderT: eltype of header
- drop: a list of column numbers to drop


Returns:

- (data_cells, header_cells)
"""
function readorg(source, T::Type=String, fillval=""; HeaderT::Type=String, drop=Int[])
    fillval = convert(T,fillval)

    table_line = r"^\s*\|.*\|.*$"
    nl = 0
    hasheader = 0
    header = HeaderT[]
    rowlength = -1
    out = T[]
    look4header = true
    keep = Int[] # which columns to keep
    open(source) do fl
        while !eof(fl)
            st = readline(fl)
            if ismatch(table_line, st)
                m = match(table_line, st)
                sst = strip(m.match)
                if sst[2]=='-' # a hline
                    continue
                end
                fields = split(sst, '|')[2:end-1]
                nl += 1
                if nl==1 # this could be the header and some other initialization
                    rowlength = length(fields)
                    # which columns to drop:
                    tmp = trues(rowlength)
                    tmp[drop] = false
                    keep = (1:rowlength)[tmp]
                    fields = fields[keep]
                    rowlength = length(fields)
                    if !eof(fl)
                        pos = position(fl)
                        st2 = readline(fl)
                        if ismatch(table_line, st2) # read the next line
                            tmp = strip(match(table_line, st2).match)
                            if tmp[2]=='-'
                                append!(header, map(x->convert(String, strip(x)), fields))
                                hasheader = 1
                                continue
                            else
                                seek(fl, pos) # put file pointer back to where it was
                            end
                        end
                    end
                else
                    fields = fields[keep]
                end

                if length(fields)!=rowlength
                    error("Row number $nl has length $(length(fields)) instead of $rowlength")
                end
                append!(out, map(x->parse_convert(T, strip(x), fillval), fields))
            elseif nl>0 # first table is finished, ignore rest of file
                return nothing
            end
        end
        return nothing
    end

    if nl==0
        error("No org-mode table found!")
    end

    out = reshape(out, div(length(out),nl-hasheader), nl-hasheader)
    out = permutedims(out, [2, 1]) # transpose
    return out, header
end

parse_convert{T<:Number}(::Type{T}, x, fillval) =  x=="" ? fillval : parse(T, x)
parse_convert{T}(::Type{T}, x, fillval) =  x=="" ? fillval : convert(T, x)



function writeorg(file, data, header=nothing)
    error("not implemented")
end

end # module
