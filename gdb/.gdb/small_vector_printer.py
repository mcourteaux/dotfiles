import gdb

class SmallVectorPrinter:
    """Print a small_vector custom type."""
    def __init__(self, val):
        self.val = val
        # Extract template argument T from the type name
        # e.g., "small_vector<int, 10>" -> T is "int"
        self.type_t = val.type.template_argument(0)
        self.size = int(val['size'])

    def to_string(self):
        return f"small_vector of size {self.size}"

    def children(self):
        # Get the address of the raw char buffer 'buf'
        buf_addr = self.val['buf'].address
        # Cast the buffer address to a pointer of type T*
        t_ptr_type = self.type_t.pointer()
        typed_ptr = buf_addr.cast(t_ptr_type)

        # Yield each active element up to 'size' as a key-value pair
        for i in range(self.size):
            element = (typed_ptr + i).dereference()
            yield f"[{i}]", element

    def display_hint(self):
        return 'array'

def lookup_small_vector(val):
    # Strip typedefs, qualifiers, references, and pointers to find the core type
    type_tag = val.type.unqualified().strip_typedefs().tag
    if type_tag and (type_tag.startswith("small_vector<")
                     or type_tag.startswith("neonraw::utils::small_vector<")):
        return SmallVectorPrinter(val)
    return None

# Register the pretty printer globally in GDB
gdb.pretty_printers.append(lookup_small_vector)
