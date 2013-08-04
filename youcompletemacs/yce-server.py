from epc.server import EPCServer
from epc.client import EPCClient

import sys


# TODO: Write tests
# add support for unsaved files:
""" python/ycm/completers/cpp/clang_completer.py line 55"""
# implement the query part:
""" CandidatesForQueryAsync() is the main entry point when the user types. For
  "foo.bar", the user query is "bar" and completions matching this string should
  be shown. The job of CandidatesForQueryAsync() is to merely initiate this
  request, which will hopefully be processed in a background thread. You may
  want to subclass ThreadedCompleter instead of Completer directly.
  """

# we extend our path with the python folder
base_path = sys.path[0]
import os
sys.path.append(os.path.join(base_path, "python"))

global ycm_state
import vim
from ycm import extra_conf_store
extra_conf_store.CallExtraConfYcmCorePreloadIfExists()
from ycm import base

if not base.CompatibleWithYcmCore():
    #print "YouCompleteMe unavailable: ycm_core too old, PLEASE RECOMPILE ycm_core"
    sys.exit()

from ycm.youcompleteme import YouCompleteMe

# Create the YouCompleteMe connection
ycm_state = YouCompleteMe()

# Create the server for talking to emacs lisp
server = EPCServer(('localhost', 0))
client = EPCClient()

@server.register_function
def init_client(port):
    client.connect(('localhost', port))

# Code to Process the Autocompletion
# This is a mostly verbatim copy of the youcompleteme.vim
def completionsForQuery(query):
    completer = ycm_state.GetFiletypeCompleter()

    completer.CandidatesForQueryAsync(query, int(vim.eval("a:completion_start_column")))

    results_ready = 0
    while not results_ready:
        results_ready = completer.AsyncCandidateRequestReadyInner()
    
    results = completer.CandidatesFromStoredRequest()
    return {'words': results, 'refresh': 'always'}

@server.register_function
def setModifiedBuffers(*buffers):
    # a simple list of lists
    # ( (buffer-name, modified?, contents), (...

    # first, remove all old values
    for l in (vim.stored_emacs_buffers_name, vim.stored_emacs_buffers_modified, vim.stored_emacs_buffers_content):
        [l.pop() for x in xrange(len(vim.stored_emacs_buffers_name))]
    
    for buffer in buffers:
        vim.stored_emacs_buffers_name.append(buffer[0])
        vim.stored_emacs_buffers_modified.append(int(buffer[1]))
        vim.stored_emacs_buffers_content.append(buffer[2])



@server.register_function
def getCompletionsForQuery (*params):
    tfile, tfolder, tcol, trow = params

    vim.stored_emacs_values[0] = str(tfile)
    vim.stored_emacs_values[1] = str(tfolder)
    vim.stored_emacs_values[2] = trow - 1
    vim.stored_emacs_values[3] = tcol

    # start a autocompletion
    res = completionsForQuery("")

    open("/tmp/px/res", "w").write(str(res))

    # note, this is where we can clean and sort the results
    values = tuple([wx['word'] for wx in res['words'] if wx.has_key('word')])

    if len(values) > 200:
        return tuple(("Too many results",))
    return values

# Start the serving
server.print_port()
server.serve_forever()
