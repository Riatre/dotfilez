set history save on
set history size 10000
set history filename ~/.history/gdb

set disassembly-flavor intel

source ~/.peda/peda.py
#source ~/lib-local/pwndbg/gdbinit.py


python
import sys
sys.path.insert(0, '/home/riatre/lib-local/libstdc++/python')
from libstdcxx.v6.printers import register_libstdcxx_printers
#register_libstdcxx_printers (None)
end


