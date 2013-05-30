from epc.server import EPCServer

import sys

# we extend our path with the python folder
base_path = sys.path[0]
import os
sys.path.append(os.path.join(base_path, "python"))

# in order to be compatible with YCM, all the stuff is in the python subfolder
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

# Code to Process the Autocompletion
# This is a mostly verbatim copy of the youcompleteme.vim
searched_and_results_found = 0


def completionsForQuery(query, use_filetype_completer, completion_start_column):
    global searched_and_results_found 
    completer = None
    if use_filetype_completer:
        completer = ycm_state.GetFiletypeCompleter()
    else:
        completer = ycm_state.GetGeneralCompleter()

    completer.CandidatesForQueryAsync( vim.eval('a:query'), \
                                       int(vim.eval('a:completion_start_column')))

    results_ready = 0
    while not results_ready:
        results_ready = completer.AsyncCandidateRequestReadyInner()
    #
    results = completer.CandidatesFromStoredRequest()
    searched_and_results_found = len(results) != 0
    return {'words': results, 'refresh': 'always'}

@server.register_function
def getCompletionsForQuery (*params):
    tfile, tfolder, tcol, trow = params

    # start a autocompletion
    res = completionsForQuery("", 1, vim.current.row)

    # note, this is where we can clean and sort the results
    values = tuple([wx['word'] for wx in res['words'] if wx.has_key('word')])

    return values

# Start the serving
server.print_port()
server.serve_forever()
