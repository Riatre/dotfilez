set history save on
set history size 10000
set history filename ~/.history/gdb

set disassembly-flavor intel

source ~/lib-local/Pwngdb/pwngdb.py
source ~/lib-local/Pwngdb/angelheap/gdbinit.py

define hook-run
python
import angelheap
angelheap.init_angelheap()
end
end

source ~/lib-local/pwndbg/gdbinit.py

python
#import sys
#sys.path.insert(0, '/home/riatre/lib-local/libstdc++/python')
#from libstdcxx.v6.printers import register_libstdcxx_printers
#register_libstdcxx_printers (None)
end

