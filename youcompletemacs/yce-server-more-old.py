from epc.server import EPCServer

# Create the server for talking to emacs lisp
server = EPCServer(('localhost', 0))

@server.register_function
def echo(*a):
    return ("mathias", "derzweite", "wernsman")

# Start the serving
print "done doing server"
server.print_port()
server.serve_forever()
