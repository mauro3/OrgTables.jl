module OrgTables
import FileIO

# package code goes here

parse_convert{T<:Number}(::Type{T}, x, fillval) =  x=="" ? fillval : parse(T, x)
parse_convert{T}(::Type{T}, x, fillval) =  x=="" ? fillval : convert(T, x)

"""

Hlines `|---+...--|` are ignored.

If the first data-row is followed by a hline `|---+...--|` then it is
treated as a header.

Input:

- source: source file or IO stream
- tablenr: which table to read (default first ==1)
- T: eltype of array (default String)
- fillval: what to replace an empty string with.  Needs to be convertible to T

Kwargs:

- HeaderT: eltype of header
- drop: a list of column numbers to drop


Returns:

- (data_cells, header_cells)
"""
orgformat = FileIO.@format_str("ORG-MODE")
FileIO.add_format(orgformat, (), ".org", [:OrgTables, FileIO.LOAD])

function FileIO.load(f::FileIO.File{orgformat};
                     T=String,
                     fillval="",
                     tablenr=1,
                     HeaderT=String,
                     drop=Int[])
    source = f.filename
    fillval = convert(T,fillval)

    table_line = r"^\s*\|.*\|.*$"
    nl = 0
    hasheader = 0
    header = HeaderT[]
    rowlength = -1
    out = T[]
    look4header = true
    keep = Int[] # which columns to keep
    cur_tablenr = 0
    intable = false
    open(source) do fl
        while !eof(fl)
            st = readline(fl)
            if ismatch(table_line, st)
                if intable==false
                    # first line of a new table
                    intable=true
                    cur_tablenr += 1
                end
                if cur_tablenr!=tablenr
                    # not the table we want to read
                    continue
                end
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
            elseif intable
                # reached the end of a table
                intable = false
                if cur_tablenr==tablenr
                    # just read the table which was to read
                    break
                end
            end
        end
    end

    if cur_tablenr<tablenr
        error("No $tablenr-th org-mode table found!")
    end

    out = reshape(out, div(length(out),nl-hasheader), nl-hasheader)
    out = permutedims(out, [2, 1]) # transpose
    return out, header

end

end # module
