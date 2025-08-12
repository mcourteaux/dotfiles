from pathlib import Path
import sys
sys.path.append(str(Path(__file__).resolve().parent))

import stack_trace_simplifier_and_colorer
import std_custom_printers

import eigen_printers
eigen_printers.register_eigen_printers(None)
