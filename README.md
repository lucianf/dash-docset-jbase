# jBASE Docset for Dash

- Retrieve `jBC_Programmers_Reference_Guide.md` from a repository like [this one](github.com/lucianf/jbc-language)
- Split the original file into three files:
  - jBC: all sections named "jBC Functions and Statements" (`jbc.md`)
  - System Variables: section "System ("@") Variables" (`sysvar.md`)
  - Categories: top sections between "Syntax Features" and "Data Files" (`categ.md`)
- Ensure the `jbc1.map` file exists.  It provides additional information on what commands are functions/statements.  This file was originally created from the jBASE 3 index page)
- Use the `build.sh` script to create the docset.

The build script will:
- raise markdown level by one (e.g. ## -> #) in each file
- jBC: using the mapping file it will tag each section with the appropriate type (function/statement)
- System Variables, Categories: tagging accordingly (variable/category)
- glue the three files together and using pandoc to create an Epub with TOC
- extract the Epub, remove the unneeded meta files, set the correct TOC title and convert the tags into class attributes
- use `Dashing` to convert the HTML structure into a docset