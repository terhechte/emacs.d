from epc.server import EPCServer
import random

server = EPCServer(('localhost', 0))

@server.register_function
def echo(*a):
    px = random.randint(0, 100)
    return ("ufuoo1@example.com%i" % (px,),
        "ufuoo2@example.com",
        "ufuoo3@example.com",
        "ufuoo42@example.com")

server.print_port()
server.serve_forever()
