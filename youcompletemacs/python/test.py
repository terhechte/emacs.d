#import ycm_core
import vim
import sys
from ycm import extra_conf_store
extra_conf_store.CallExtraConfYcmCorePreloadIfExists()
from ycm import base
if not base.CompatibleWithYcmCore():
    print "YouCompleteMe unavailable: ycm_core too old, PLEASE RECOMPILE ycm_core"
    sys.exit()
from ycm.youcompleteme import YouCompleteMe
ycm_state = YouCompleteMe()

#from ycm import vimsupport, youcompleteme
#from ycm.completers.all.omni_completer import OmniCompleter
#from ycm.completers.general.general_completer_store import GeneralCompleterStore

#print "clang support: ", ycm_core.HasClangSupport()

#print dir(youcompleteme)
#cl = youcompleteme.YouCompleteMe()
#print cl
#print dir(cl)
#completer =  cl.GetFiletypeCompleterForFiletype("objc")
#print completer.ShouldUseNowInner(0)

# Global Variables
completefunc = None
l_completefunc = None

old_cursor_position = []
cursor_moved = 0
moved_vertically_in_insert_mode = 0
previous_num_chars_on_current_line = -1
searched_and_results_found = 0
should_use_filetype_completion = 0
completion_start_column = 0


# Re-Implementation of the functions in youcompleteme.vim,
# that are being used for the auto completion
def onCursorHold():
    if not allowedToCompleteInCurrentFile():return
    ycm_state.OnFileReadyToParse()

def allowedToCompleteInCurrentFile():
    return True

def setCompleteFunc():
    global completefunc, l_completefunc

    completefunc = 'youcompleteme#Complete'
    l_completefunc = 'youcompleteme#Complete'
    

def onCursorMovedInsertMode():
    if not allowedToCompleteInCurrentFile():return

    updateCursorMoved()

    if not bufferTextChangedSinceLastMoveInInsertMode():
        return

    identifierFinishedOperations()
    invokeCompletion()
    
def  bufferTextChangedSinceLastMoveInInsertMode():
    global previous_num_chars_on_current_line
    if moved_vertically_in_insert_mode:
        previous_num_chars_on_current_line = -1
        return 0
    num_chars_in_current_cursor_line = len(getline('.'))
    if previous_num_chars_on_current_line == -1:
        previous_num_chars_on_current_line = num_chars_in_current_cursor_line
        return 0
    changed_text_on_current_line = 0
    if num_chars_in_current_cursor_line != previous_num_chars_on_current_line:
        changed_text_on_current_line = 0
    else:
        changed_text_on_current_line = 1
    return changed_text_on_current_line
    
    
def onInsertEnter():
    global old_cursor_position
    if not allowedToCompleteInCurrentFile():
        return
    old_cursor_position = []

def getline(v):
    # return current line
    return "lala"

def getpos(v):
    # return current pos
    return [0, 0]

def updateCursorMoved():
    global cursor_moved, old_cursor_position
    global moved_vertically_in_insert_mode

    current_position = getpos('.')
    cursor_moved = current_position != old_cursor_position

    moved_vertically_in_insert_mode = (old_cursor_position != []) and current_position[1] != old_cursor_position[1]
    old_cursor_position = current_position

def identifierFinishedOperations():
    if not base.CurrentIdentifierFinished():
        return

    ycm_state.OnCurrentIdentifierFinished()


def insideCommentOrString():
    # Still need to flesh this out
    return 0


def insideCommentOrStringAndShouldStop():
    # still need to flesh this out
    return 0

def onBlankLine():
    return not vim.current.line or vim.current.line.isspace()
    

def invokeCompletion():
    if completefunc != 'youcompleteme#Complete':
        return
    if insideCommentOrStringAndShouldStop() or onBlankLine():
        return
    
    # This is tricky. First, having 'refresh' set to 'always' in the dictionary
    # that our completion function returns makes sure that our completion function
    # is called on every keystroke. Second, when the sequence of characters the
    # user typed produces no results in our search an infinite loop can occur. The
    # problem is that our feedkeys call triggers the OnCursorMovedI event which we
    # are tied to. We prevent this infinite loop from starting by making sure that
    # the user has moved the cursor since the last time we provided completion
    # results.
    if not cursor_moved:
        return
    
    # call the completion function
    youcompleteme_complete()

def complete_check():
    # VimScript internal function, have to look up what it does
    return 0

def completionsForQuery(query, use_filetype_completer, completion_start_column):
    global searched_and_results_found 
    completer = None
    if use_filetype_completer:
        completer = ycm_state.GetFiletypeCompleter()
    else:
        completer = ycm_state.GetGeneralCompleter()

    completer.CandidatesForQueryAsync( vim.eval('a:query'), \
                                       int(vim.eval('a:completion_start_column')))

    print "completer:", completer
    results_ready = 0
    while not results_ready:
        results_ready = completer.AsyncCandidateRequestReadyInner()
        if complete_check():
            searched_and_results_found = 0
            return {'words': [], 'refresh': 'always'}
    #
    results = completer.CandidatesFromStoredRequest()
    searched_and_results_found = len(results) != 0
    return {'words': results, 'refresh': 'always'}
        

# This is our main entry point. This is what vim calls to get completions.
def youcompleteme_complete(findstart, base):
    if findstart:
        if not cursor_moved:
            return
        #
        global completion_start_column, should_use_filetype_completion
        completion_start_column = base.CompletionStartColumn()
        should_use_filetype_completion = ycm_state.ShouldUseFiletypeCompleter(completion_start_column)
        if should_use_filetype_completion and not ycm_state.ShouldUseGeneralCompleter(completion_start_column):
            return
        #
        return completion_start_column
    else:
        return completionsForQuery(base, should_use_filetype_completion, completion_start_column)
    
def debugInfo():
    print 'Printing YouCompleteMe debug information...'
    v = ycm_state.DebugInfo()
    for line in v.split("\n"):
        print '-- ', line

#
def forceCompile():
    import time
    if not ycm_state.NativeFiletypeCompletionUsable():
        print "Native filetype completion not supported for current file, cannot force recompilation"
        return 0
    print "Forcing complation"
    ycm_state.OnFileReadyToParse()
    while 1:
        diagnostics_ready = ycm_state.DiagnosticsForCurrentFileReady()
        if diagnostics_ready:
            break
        getting_completions = ycm_state.GettingCompletions()
        if not getting_completions:
            print "Unable to retrieve diagnostics"
            return 0
        time.sleep(0.01)
    return 1
        
    
def showDiagnostics():
    compilation_succeeded = forceCompile()
    if not compilation_succeeded:
        return
    diags = ycm_state.GetDiagnosticsForCurrentFile()
    if len(diags) != 0:
        print diags
    else:
        print "No warnings or errors detected"
        

# testing until we get some working output..
if __name__ == "__main__":
    # try a simple completion
    vim.stored_emacs_values[0] = "BTMasterViewController.m"
    vim.stored_emacs_values[1] = "/Users/terhechte/Desktop/testapp/testapp/"
    vim.stored_emacs_values[2] = 18
    vim.stored_emacs_values[3] = 32
    print "set up"
    print vim.current.filename
    print "---"
    completion_start_column = vim.current.column
    cursor_moved = 1
    should_use_filetype_completion = 1
    res = completionsForQuery("", 1, vim.current.row)
    print [wx['word'] for wx in res['words'] if wx.has_key('word')]
    # import time
    # print "wait..."
    # time.sleep(4.0)
    # t1 = time.time()
    # #now that the cache is hot, we try another wone
    # print len(completionsForQuery("", 1, vim.current.row))
    # print time.time() - t1

    
