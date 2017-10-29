set history save on
set history size 10000
set history filename ~/.history/gdb

set disassembly-flavor intel
add-auto-load-safe-path /usr/share/go-1.8/src/runtime/runtime-gdb.py

source ~/lib-local/pwndbg/gdbinit.py

python
end

