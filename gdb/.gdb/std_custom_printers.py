import gdb
import re

std_function_regex = re.compile("^std::function<.*>$")
class StdFunctionPrinter:
    def __init__(self, val):
        self.__val = val

    def to_string(self):
        return self.__val.type.tag + " = \033[34m" + str(self.__val["_M_invoker"].address) + "\033[0m"

    def display_hint(self):
        return 'struct'

class StdMutexPrinter:
    def __init__(self, val):
        self.__val = val

    def to_string(self):
        return "std::mutex"

    def display_hint(self):
        return 'struct'

def std_function_lookup_function(val):
    lookup_tag = val.type.tag
    if lookup_tag is None:
        return None
    if std_function_regex.match(lookup_tag):
        return StdFunctionPrinter(val)
    if lookup_tag == "std::mutex":
        return StdMutexPrinter(val)
    return None

gdb.pretty_printers.append(std_function_lookup_function)
