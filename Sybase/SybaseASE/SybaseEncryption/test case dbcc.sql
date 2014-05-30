dbcc traceon(3604)

dbcc mempool("Encrypted Columns Frag", show)

***** summary for fragment pool Encrypted Columns Frag *****
# of allocs  = 49209512
# of frees   = 49209512
# of sleeps  =        0
# of blocks  =        1
# of frags   =        1
min size     =     6144
max size     =   167936

used memory  =      464
(overhead    =      464)
free memory  =     5680
total memory =     6144


select @@version