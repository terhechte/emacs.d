def setup(*a):
    pass

class bufferClass(object):
    name = ""
    number = 0
    def __init__(self, filename):
        self.name = filename
#
class windowClass(object):
    cursor = []
    def __init__(self, x, y):
        self.cursor = [x, y] 

class currentClass(object):
    # Public
    line = ""
    buffer = None
    window = None


    # Private
    filecontents = None
    column = 0

    # Temporary Non-Vim
    row = 0

    def __init__(self, current_row, current_column, filename):
        self.row = current_row
        self.column = current_column
        self.buffer = bufferClass(filename)
        self.window = windowClass(current_row, current_column)

example_files = [ # row, column (just as listed in the window)
    ('example.c', (14, 6)),
    ('example.m', (20, 5)),
    ('StyleMacGameTest2/main.m', (15,16)),
    ('BTMasterViewController.m', (32,18))
]
cf = 3

# test
ax = example_files[cf]
f = ax[0]
row = ax[1][0]
col = ax[1][1]
#current = currentClass(code.split("\n")[row], row, col, f)
current = currentClass(row, col, f)
buffers = [current.buffer,]

def command(cmd):
    #print "Cmd: >> ", cmd
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
        return "/Users/terhechte/Desktop/testapp/testapp/"

    # this is the stuff that's being requested for completion:
    if i == 'a:query':
        return "" #what do to here??
    if i == 'a:completion_start_column':
        return current.column

    # default
    return 0
