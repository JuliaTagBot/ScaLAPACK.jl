module BLACS

using ..libscalapack

function get(icontxt::Integer, what::Integer)
    val = Array(Int32, 1)
    ccall((:blacs_get_, libscalapack), Void,
        (Ptr{Int32}, Ptr{Int32}, Ptr{Int32}),
        &icontxt, &what, val)
    return val[1]
end

function gridinit(icontxt::Integer, order::Char, nprow::Integer, npcol::Integer)
    icontxta = Int32[icontxt]
    ccall((:blacs_gridinit_, libscalapack), Void,
        (Ptr{Int32}, Ptr{UInt8}, Ptr{Int32}, Ptr{Int32}),
        icontxta, &order, &nprow, &npcol)
    icontxta[1]
end

function pinfo()
    mypnum, nprocs = Array(Int32, 1), Array(Int32, 1)
    ccall((:blacs_pinfo_, libscalapack), Void,
        (Ptr{Int32}, Ptr{Int32}),
        mypnum, nprocs)
    return mypnum[1], nprocs[1]
end

function gridinfo(ictxt::Integer)
    nprow = Array(Int32, 1)
    npcol = Array(Int32, 1)
    myprow = Array(Int32, 1)
    mypcol = Array(Int32, 1)
    ccall((:blacs_gridinfo_, libscalapack), Void,
        (Ptr{Int32}, Ptr{Int32}, Ptr{Int32}, Ptr{Int32}, Ptr{Int32}),
        &ictxt, nprow, npcol, myprow, mypcol)
    return nprow[1], npcol[1], myprow[1], mypcol[1]
end

gridexit(ictxt::Integer) = ccall((:blacs_gridexit_, libscalapack), Void, (Ptr{Int32},), &ictxt)

exit(cont = 0) = ccall((:blacs_exit_, libscalapack), Void, (Ptr{Int},), &cont)

end
