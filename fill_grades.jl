#! /usr/bin/julia
######################################################333
# The program takes as input the new grade template .xlsx file
# provided by the grade entry system in UIUC (May, 2024), and a text
# file of the following format in each line:
#
#   STUDENT_ID_NUM,GRADE
#
# It outputs a filled in grades in template file. For safety, the
# output.xlsx file should be different than the input.
#
# Usage:
#
# julia  fill_grades.jl  input.xlsx  grades.txt  output.xlsx
#
#######################################################################
# After installing julia, do the following:
#
# Run julia from the command line, and type:
#
# julia> import Pkg;Pkg.add("XLSX");Pkg.add("DataFrames"); Pkg.add( "CSV" );
#
#############################################################################
using XLSX, DataFrames, CSV;

function  fill_grade( sh, id_col, grade_col, id, grade )
    rows = size(sh[:])[1];

    for  i in 1:rows
        if  sh[ i, id_col ] == id
            sh[ i, grade_col ] = grade;
            return;
        end
    end
    println( "FAIL to find ", id, " grade: ", grade );
end


function  fill_grades( in_name, grades_file, out_name )
    if  ( ! isfile( in_name ) )
        printf( "Unable to open: ", in_name );
        exit( -1 );
    end
    if  ( ! isfile( grades_file ) )
        printf( "Unable to open: ", grades_file );
        exit( -1 );
    end
    cp( in_name, out_name, force=true );

    csv = CSV.File( grades_file, header=false, types=String )
    grades = DataFrame( csv )

    XLSX.openxlsx( out_name, mode="rw") do xf
        sh = xf[ 1 ];
        dims = size(sh[:]);
        rows = dims[ 1 ];
        cols = dims[ 2 ];

        id_col = -1;
        grade_col = -1;
        for  i in 1:cols
            if  sh[ 1, i ] == "Student ID"
                id_col = i;
            end
            if  sh[ 1, i ] == "Final Grade"
                grade_col = i;
            end
        end
        @assert( ( id_col > 0 ) &&  ( grade_col > 0 ) )

        for i in 1:nrow( grades )
            id = grades[ i, 1 ];
            grade = grades[ i, 2 ];
            fill_grade( sh, id_col, grade_col, id, grade );
        end
        println( "===",  sh[ 2, grade_col ] );
    end
end

# Main

if  length( ARGS ) != 3
    println( "\n\tfill_grades.jl [tempalte.xlsx] [grades.txt] [output.xlsx]\n" );
    exit( -1 );
end

fill_grades( ARGS[ 1 ], ARGS[ 2 ], ARGS[ 3 ] );
