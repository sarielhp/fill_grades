# fill_grades

The program takes as input the new grade template .xlsx file
provided by the grade entry system in UIUC (May, 2024), and a text
file of the following format in each line:

   STUDENT_ID_NUM,GRADE

 It outputs a filled in grades in template file. For safety, the
 output.xlsx file should be different than the input.

# Usage:

 julia  fill_grades.jl  input.xlsx  grades.txt  output.xlsx

# Installation

 After installing julia, do the following:

 Run julia from the command line, and type:

 julia> import Pkg;Pkg.add("XLSX");Pkg.add("DataFrames"); Pkg.add( "CSV" );
