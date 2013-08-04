import re

"""
The simplest conceivable way (right now, to get things to work) to 
get the current buffer, row, col, folder from emacs, is to store
it in a mutable list that is part of the module.
So that subsequent imports will read the updated data
"""

# filename, folder, col, row
stored_emacs_values = ["", "", 0, 0]
# the name of all buffers
stored_emacs_buffers_name = []
# the modified-flag for the buffers
stored_emacs_buffers_modified = []
# if the buffers are modified, their content, otherwise ""
stored_emacs_buffers_content = []

class bufferClass(object):
    def __getattr__(self, name):
        if name == 'name':
            return stored_emacs_values[0]
        else:
            return ""
    def __setattr__(self, name, value):
        if name == 'name':
            stored_emacs_values[0] = value
#
class windowClass(object):
    def __getattr__(self, name):
        if name == "cursor":
            return [stored_emacs_values[3], stored_emacs_values[2]]
        else:
            return None

class currentClass(object):
    buffer = None
    window = None

    def __getattr__(self, name):
        if name == 'column':
            return stored_emacs_values[2]
        elif name == 'row':
            return stored_emacs_values[3]
        elif name == 'filename':
            return stored_emacs_values[0]
        else:
            return ""

    def __init__(self):
        self.window = windowClass()
        self.buffer = bufferClass()

    def setFilename(self, filename):
        stored_emacs_values[0] = filename


def command(cmd):
    #print "Cmd: >> ", cmd
    open("/tmp/px/command", "a").write(cmd)
    pass

def eval(i):
    #print "Asking for: ", i
    """ ycm uses this function to get the configuration values """
    if i == "g:ycm_global_ycm_extra_conf":
        return ""
    if i == 'g:ycm_filetype_specific_completion_to_disable':
        return 0
    if i ==  'ycm_add_preview_to_completeopt':
        return 0
    if i ==  'ycm_complete_in_comments':
        return 0
    if i ==  'ycm_complete_in_strings':
        return 1
    if i ==  'ycm_collect_identifiers_from_comments_and_strings':
        return 0
    if i ==  'ycm_max_diagnostics_to_display':
        return 30
    if i ==  'ycm_confirm_extra_conf':
        return 1
    if i ==  'ycm_extra_conf_globlist':
        return []
    if i == 'g:ycm_min_num_of_chars_for_completion':
        return 2
    if i == 'g:ycm_max_diagnostics_to_display':
        return 0
    if i == 'g:ycm_filepath_completion_use_working_dir':
        return 1 
    if i == 'g:ycm_semantic_triggers':
        return {
         'c' : ['->', '.'],
         'objc' : ['->', '.'],
         'ocaml' : ['.', '#'],
         'cpp,objcpp' : ['->', '.', '::'],
         'perl' : ['->'],
         'php' : ['->', '::'],
         'cs,java,javascript,d,vim,ruby,python,perl6,scala,vb,elixir,go' : ['.'],
         'lua' : ['.', ':'],
         'erlang' : [':'],
       }
    if i ==  'ycm_cache_omnifunc':
        return 1
    if i == '&filetype':
        return 'objc'
    if i == 'getcwd()':
        return stored_emacs_values[1]
        #return "/Users/terhechte/Desktop/testapp/testapp/"
    if i == 'a:query':
        return ""
    if i == 'a:completion_start_column':
        return stored_emacs_values[2]
    # we check if the buffer is modified
    match = re.match("getbufvar\(([0-9])", i)
    if match and len(match.groups()) > 0:
        number = int(match.groups()[0])
        try:
            return stored_emacs_buffers_modified[number]
        except:
            print "Could not find buffer", number
            return 0

    # default
    return 0

#current_file = "BTMasterViewController.m" # filename
#current_row = 30
#current_col = 12
current = currentClass()
buffers = [current.buffer,]
