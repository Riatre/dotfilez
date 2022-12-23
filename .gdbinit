set history save on
set history size 10000
set history filename ~/.gdbhist

set disassembly-flavor intel
add-auto-load-safe-path /usr/share/go-1.*/src/runtime/runtime-gdb.py
add-auto-load-safe-path /home/riatre/.rustup/toolchains/*-x86_64-unknown-linux-gnu/lib/rustlib/etc/

python
class IgnoreErrorsCommand (gdb.Command):
    '''Execute a single command, ignoring all errors.
Only one-line commands are supported.
This is primarily useful in scripts.'''

    def __init__ (self):
        super (IgnoreErrorsCommand, self).__init__ ("ignore-errors",
                                                    gdb.COMMAND_OBSCURE,
                                                    # FIXME...
                                                    gdb.COMPLETE_COMMAND)

    def invoke (self, arg, from_tty):
        try:
            gdb.execute (arg, from_tty)
        except:
            pass

IgnoreErrorsCommand ()
end

python
import os
if os.getenv("GDB_GEF"):
    gdb.execute("ignore-errors source ~/lib/gef/gef.py")
elif not os.getenv("GDB_BARE"):
    gdb.execute("ignore-errors source ~/lib/pwndbg/gdbinit.py")
end

