# jBC/jBASE Features

- Case sensitive keywords and variable names.
- Optional statement labels.
- Code sections accessed by GOSUB.
- IF...THEN..ELSE conditional statement.
- BEGIN CASE...CASE...END CASE conditional statement.
- FOR...NEXT loop.
- DO..WHILE/UNTIL...REPEAT loop.
- External subroutines and functions.
- Weak variables typing; implicit types conversion.
- Dimensioned and dynamic arrays.
- String, number, and date data conversion.
- Patterns matching.
- Unary operators support.
- Single- and multi-byte character sets support.
- Bitwise operations.
- Standard industry encryption algorithms support.
- Named and unnamed COMMON areas.
- Operations with SELECT lists.
- File and record level locking capability; distributed lock system.
- Text files processing.
- Functions for XML processing.
- Manipulations with environment variables.
- Emulation modes for compatibility with numerous MV platforms.
- Practically unlimited data file size (OS limits apply).
- Data files distribution.
- Transactions support.
- Transparent access to jBASE data and dictionary files converted to Oracle, DB2 or MS SQL.
- Possibility to call C or Java code.
- Possibility to execute any jBASE, system or database enquiry command.
- Source code editor - JED (also capable of editing data files).
- Debugger.

# Syntax Features

## Note

In examples presented here and below deleting and creation of temporary file
called F.TEMP is often used, so if you have such file with something valuable
in it in your current directory, backup it first.

## Note 2

OCONV() or FMT() with second parameter 'MCP' is often used; its only purpose is
to convert FM, VM and SM delimiters to a printable form, e.g.:

       V.ARRAY = 1 :@FM: 2 :@VM: 3 :@FM: 4 :@SM: 5
       CRT FMT(V.ARRAY, 'MCP')                ;*   1^2]3^4\5

Where possible, the output is shown in a comment (as it is in the example above).

## Variables visibility and lifetime

Variable is visible throughout the program or its subroutine (i.e. in
the bounds of particular source code file). To share a variable between
different programs/subroutines pass them as parameters in [CALL](#CALL)
statement or use a named or unnamed [COMMON](#COMMON).

All variables (except ones in COMMON areas) are reset (i.e. become unassigned) upon program end.

See also: [SUBROUTINE](#SUBROUTINE), [ASSIGNED](#ASSIGNED), [UNASSIGNED](#UNASSIGNED).

## To wrap a long line

Use a backslash:

       V.LINE = 'The report for the year ' :@FM: V.YEAR : ', prepared at ' \
            : TIMEDATE()

Or - if line ends with a comma - that's not necessary:

       V.STAT = IOCTL(F.TEST.FILE,
             JIOCTL_COMMAND_FINDRECORD_EXTENDED, V.NAME)

## Several statements on the same line

Use semicolon to delimit several statements on the same line; don't forget about
code readability. You can combine statements with comments (though as soon as
you have a comment, the following statements turn to comments as well):

<!--jBC-->
    V.VAR = 1  ;  V.VAR++  ;  CRT V.VAR
    V.VAR-- ;* comment starts here so no "1" in the output ; CRT V.VAR
    V.VAR-- ; CRT V.VAR  ;* 0 will be displayed

Conditional statements are also supported (though code readability suffers in
the following example):

<!--jBC-->
    var_1 = 1 ; var_2 = 2 ; IF var_1 + var_2 EQ 3 THEN
       CRT var_1, '+', var_2, '= 3'
    END

## Comments

Comments can be defined in different ways:

    * This is a comment
    ! And this is a comment
    REM This is also a comment
    // Even this is a comment
       CRT '1'    ;* this is a comment sharing the same line with some code
       CRT '2'    // yet another way to define a comment
       CRT '3'

## String variables

Strings can be delimited with single quotes, double quotes or backslashes:

       CRT 'QWERTZ'    ;* this is a string
       CRT "QWERTZ"    ;* this is also a string
       CRT 'QWE"RTZ'   ;* and even this is a string
       CRT \QWERTZ\    ;* still this is a string
       * and here a backslash means line continuation
       CRT 'QWE'  \
          : 'RTZ'

To concatenate strings (you could see it in one of examples above), use a
colon:

       a_line = 'QWE' : 'RT'
       CRT a_line                               ;*  QWERT
       * unary concatenation
       a_line := 'Y'
       CRT a_line                               ;*  QWERTY

String can be concatenated with a number without explicit conversion:

       a_line = 'QWERTY'
       a_line := 123
       CRT a_line                               ;*  QWERTY123

To extract a substring from a string use square brackets:

       a_line = 'QWERTY'
       CRT a_line[1,2]                          ;*  QW
       CRT a_line[2]                            ;*  TY
       CRT a_line[-4,2]                         ;*  ER

It's possible to reassign parts of a string using that notation:

       a_string = 'ABC'
       a_string[2,1] = 'Q'
       CRT a_string                             ;* AQC
       a_string[2,1] = 'WER'
       CRT a_string                             ;* AWERC

Strings comparison is done from left to right:

       a_string = 'ABC'
       char_a = 'A'
       char_b = 'B'
       CRT a_string GT char_a       ;* 1
       CRT a_string GT char_b       ;* 0

Other common string operations:

       a_line = 'QWERTY'
       * add quotes around a string
       CRT SQUOTE(a_line[4,999])                ;*  'RTY'
       CRT QUOTE(a_line)                        ;*  "QWERTY"
       * change case
       CRT DOWNCASE(a_line)                     ;*  qwerty
       CRT UPCASE('do it now!')                 ;*  DO IT NOW!
       * get length of a string
       CRT LEN(a_line)                          ;*  6
       * get length of i18n string - number of characters and number of bytes
       a_line := CHAR(353)
       CRT LEN(a_line)                          ;*  7
       CRT BYTELEN(a_line)                      ;*  8
       * repeat string several times
       CRT STR('QWE', 5)                        ;*  QWEQWEQWEQWEQWE
       * dynamic array is also a string
       dyn_array = 'qwe' : @FM : "rty" : @VM : \xYZ\
       CRT LEN(dyn_array)                       ;*  11
       CRT FMT( UPCASE(dyn_array), 'MCP' )      ;*  QWE^RTY]XYZ
       * pad a string
       a_string = 'AWERC'
       CRT '/' : FMT(a_string, '25R') : '/'     ;* /                    AWERC/
       * get ASCII value of a character
       CRT SEQ(a_string[1,1])                   ;* 65 (ASCII code of "A")

## Numeric variables

       V.VAR = 5            ;   CRT V.VAR           ;* 5
       CRT ISDIGIT(V.VAR)                           ;* 1
       V.VAR = V.VAR + 1    ;   CRT V.VAR           ;* 6
       V.VAR ++             ;   CRT V.VAR           ;* 7
       V.VAR += 1           ;   CRT V.VAR           ;* 8
       V.VAR -= 1           ;   CRT V.VAR           ;* 7
       V.VAR =- 1           ;   CRT V.VAR           ;* -1... easy to make a mistake
       CRT ISDIGIT(V.VAR)                           ;* 0 (we have minus now)
       CLEAR
       CRT V.VAR                                    ;* 0
       V.VAR2 = V.VAR++     ; CRT V.VAR2            ;* 0 - old value of V.VAR
       V.VAR3 = ++V.VAR     ; CRT V.VAR3            ;* 2 - value of V.VAR (1) + 1
    * other operators
       CRT 2 * 3                                    ;* 6
       CRT 2 ** 10                                  ;* power of 2 (1024)
       CRT 2 ^ 10                                   ;* same as above
       CRT 7 / 2                                    ;* 3.5
       CRT SQRT(144)                                ;* 12
    * precedence is quite expected
       CRT 7 / 2 + 3                                ;* 6.5
       CRT 7 / (2 + 3)                              ;* 1.4
    * Dot, plus, minus are considered non-numeric - in all emulations
    * dot_not_numeric = true:
       CRT ISDIGIT(-1)                         ;* 0
       CRT ISDIGIT(1.234)                      ;* 0

## Boolean variables

Boolean variables as such don't exist in jBC; the result of a statement like IF (VAR) THEN...
depends on that variable contents:

<!--jBC-->
       IF NOT(unassigned_var) THEN CRT 'Unassigned var is false'
       true_var = 1  ;  false_var = 0
       IF true_var THEN CRT '1 is true'
       IF NOT(false_var) THEN CRT '0 is false'
       a_string = 'YES'
       IF a_string THEN CRT 'Non-empty string is true'
       IF NOT('0.00') THEN CRT '0.00 is false'
       IF NOT('-0.00') THEN CRT '"-0.00" is still false - treated as numeric'
    * and this test depends on PRECISION
       PRECISION 9
       IF NOT('0.00000000000001') THEN CRT '0.00000000000001 is false'  \
             ELSE CRT '0.00000000000001 is true'
       PRECISION 17
       IF NOT('0.00000000000001') THEN CRT '0.00000000000001 is false' \
             ELSE CRT '0.00000000000001 is true with PRECISION 17'
       *------------------------------------------------------------------------
    ANOTHER.METHOD:
    *
      CRT @TRUE
      CRT @FALSE

Compiler warning:

<pre>
    Warning: Variable unassigned_var is never assigned!</pre>

Runtime:

<pre>
    Non-numeric value -- ZERO USED ,
    Variable 'unassigned_var' , Line 1 , Source test.b
    Unassigned var is false
    1 is true
    0 is false
    Non-empty string is true
    0.00 is false
    "-0.00" is still false - treated as numeric
    0.00000000000001 is false
    0.00000000000001 is true with PRECISION 17
    1
    0</pre>

## Dynamic arrays

To assign or extract a field/value/subvalue from a dynamic array,
use string concatenation method (**:**) or angle brackets:

       V.ARRAY = 1 :@FM: 2 :@FM: 3 :@FM: 4 :@VM: 5 :@VM: 6 :@SM: 7
       CRT V.ARRAY<2>               ;* 2
       CRT V.ARRAY<4,3,1>           ;* 6
       V.ARRAY<2> += 1
       CRT V.ARRAY<2>               ;* 3
       V.ARRAY<-1> = 10             ;* adds an element to the end
    * Nesting is allowed:
       V.CNT = 1 :@FM: 3 :@FM: 5
       V.ARRAY<V.CNT<2>> = 77
       CRT FMT(V.ARRAY, 'MCP')      ;* 1^3^77^4]5]6\7^10

Note that array elements are numbered starting from 1 rather that 0.

## Dimensioned arrays

Dimensioned arrays use parentheses:

       DIM V.VALUES(30000)            ;* size it
       MAT V.VALUES = 0               ;* assign 0 to all elements
       V.X = SYSTEM(2) - 15  ; V.Y = SYSTEM(3) - 5
       DIM V.SCREEN(V.X, V.Y)         ;* can be 2-dimensional
       V.SCREEN(1, 1) = 123           ;* here goes assignment

## Other notes

"=" character can be used both for assignment and for a comparison,
though it's possible to use "EQ" in the latter case:

       V.STRING = 'ABC'
       IF V.STRING = 'ABC' THEN CRT 'YES'
       IF V.STRING EQ 'ABC' THEN CRT 'YES AGAIN'

"Non-equal" can either be "#", "!", "<>" or "NE":

       a_string = 'ABC'
       IF a_string #  'A' THEN CRT 'Not an "A"'
       IF a_string NE 'B' THEN CRT 'Not a "B"'
       IF a_string ! 'C' THEN CRT 'Not even a "C"'
       IF a_string <> 'D' THEN CRT 'Surprisingly, but neither a "D"'

IF...ELSE construct can be used without THEN:

       V.STRING = 'ABC'
       IF V.STRING NE 'ABC' ELSE CRT 'YES'

### Differences between emulations

For T24 emulation should always be **prime**, however for porting the code it's
crucial to understand the differences.

See several examples below.

The following
code will run successfully under **prime** emulation and will fail under **ros**:

       ret_code = GETENV('JBCEMULATE', jbc_emu)   ;   CRT jbc_emu
       dyn_array = 3 :@AM: 7
       dyn_array += 4
       CRT FMT(dyn_array, 'MCP')

Runtime:

<pre>
    prime
    7^7</pre>

<pre>
    ros
    Non-numeric value -- ZERO USED ,
    Variable 'dyn_array' , Line     3 , Source test.b
    Trap from an error message, error message name = NON_NUMERIC</pre>

*Setting in Config_EMULATE: ***no_value_maths = false|true**

Next program outputs *<>* under **prime** and *<0>* under **seq**
emulation. In the latter case there will be zero-sized file *report.txt* after
program termination. So if, for example, nothing was written to a report
under **prime** emulation (or, in fact, any other except **seq**),
there will be no output file left after that.

Source code:

       dir_name = '.'
       file_name = 'report.txt'
       DELETESEQ dir_name, file_name ELSE NULL
       *
       OPENSEQ dir_name, file_name TO f_report THEN NULL
       CRT '<' : DIR(file_name)<1> : '>'

*Setting in Config_EMULATE: ***openseq_creates = false|true**

The following program outputs *1* under **prime** emulation and *0*
under **r83**, thus showing that common variables can be assigned or
unassigned upon declaration of COMMON area:

       COMMON /MY.COMM/ var_1, var_2
       *
       CRT ASSIGNED(var_1)

*Setting in Config_EMULATE: ***named_common = unassigned|null|zero**

The next program outputs *A^1^2^3^4^5* under **seq** or **r83**
emulations; under others (that do add additional
delimiter even if one exists at the end of an array in question) the output
will be: *A^^1^2^3^4^5*.

Source code:

       dyn_array = 'A' : @FM
       FOR i = 1 TO 5
          dyn_array<-1> = i
       NEXT i
       CRT OCONV(dyn_array, 'MCP')

*Setting in Config_EMULATE: ***no_extra_delimiter = false|true**

The following *READV* example outputs *REC1* (i.e. record key) when is
run under **jbase** emulation and *3* (i.e. fields count) under, e.g.,
**ap** or **r83**:

       OPEN 'F.TEMP' TO f_temp THEN
          ret_error = ''
          CLEARFILE f_temp SETTING ret_error
          IF ret_error NE '' THEN
             CRT 'ERROR ' : ret_error
             STOP
          END
       END ELSE
          EXECUTE 'CREATE-FILE DATA F.TEMP 1 101 TYPE=J4'
          OPEN 'F.TEMP' TO f_temp ELSE ABORT 201, 'F.TEMP'
       END
       *
       out_record = 'LINE 1' :@FM: 'LINE 2' :@FM: 'LINE 3'
       WRITE out_record TO f_temp, 'REC1'
       *
       READV in_record FROM f_temp, 'REC1', 0 ELSE
          CRT 'Read error'
          STOP
       END
       *
       CRT in_record

*Setting in Config_EMULATE: ***readv0 = key|dcount|binary**

Some settings are effective at runtime, others apply during compilation.
For example, the following program compiles successfully under **prime**
emulation and runs successfully after that under all emulations.
However, it's not possible to compile it under, say, **jbase** emulation.
Reason of error - redimensioning of an array.

Code:

       DIMENSION dyn_array(10)
       MAT dyn_array = '!'
       dyn_array(5) = '?'
       FOR i = 1 TO 10
          CRT dyn_array(i):          ;* !!!!?!!!!!
       NEXT i
       DIM dyn_array(15)
       dyn_array(15) = '...'
       CRT dyn_array(15)

Compilation under **jbase** emulation:

<pre>
    [error 1        (32)] "test.b", 7 (offset 18)  near ")":
    Array dyn_array has already been DIMensioned
    &nbsp;
    1 error was found</pre>

*Setting in Config_EMULATE: ***resize_array = false|true**

Another example:

<!--jBC-->
    * number of seconds past midnight
       CRT SYSTEM(12)   ;* e.g. 30938703.4097 under prime, 309387 under ros

For more settings see *Config_EMULATE* and *Config_EMULATE.txt*
files in your TAFC/config folder.

# Guidelines for Writing Source Code

## Recommendations (not rules)

*Note: some examples in this documentation don't fully follow these rules - they were taken from other sources or it's done intentionally to illustrate some language features.*

- All variables are to be in lower case and in the lower_case_and_underscore_naming style.

- Use only one style of quotes for strings, e.g.: "QWERT" (double quotes, preferable) or 'QWERT' (single quotes). Mix them only if it's really required, e.g.:

       CRT '"Yes Minister", ' : "that's what I said."

- Always use one space after the comma and never before the comma.

- Never use space after '(' and before ')' (exception is when code is more readable with it).

- Never put multiple commands on a single line and separate them by ";", except for short similar statements, like:

       var_1 = 1  ;  var_2 = 2  ;  var_3 = 3

- Don't put trailing ';' at the end of the lines.

- Never convert ints to boolean implicitly:

Instead of:

       IF INDEX(...) THEN

always write:

       IF INDEX(...) NE 0 THEN

Same goes for strings. Instead of:

       var = 'ABC'
       IF var THEN  ;* code continues here

Use:

       IF var NE '' THEN  ;* code continues here

- Never hardcode program or subroutine name in error messages etc. Use SYSTEM(40) instead.

- Always supply meaningful error messages with sufficient additional information.

- Don't comment what you do; comment why.

- Don't mix tabs with spaces, use either former or latter.

- Don't use characters with ASCII code above 126 in the source. To form strings with such characters use CHAR() or load them from external file or table.

- Use CR (ASCII 10) for line ends rather than CR+LF.

- For statements like INCLUDE, $INSERT use zero indent; for all other code - 3 spaces of initial indent and 3 spaces to indent each FOR...NEXT, LOOP...REPEAT contents etc.

- Wrap lines that are longer than 80 characters (use a backslash or comma at the end where the latter is applicable). It's a good idea to move line continuation(s) even more than 3 positions to the right, e.g.:

       current_date = DATE()
       current_day = OCONV(current_date, 'DD')
       current_month = OCONV(current_date, 'DM')
       ansi_date =  OCONV(current_date, 'DY') : '-'    \
             : FMT(current_month, 'R0%2' )   : '-'     \
             : FMT(current_day, 'R0%2' )
       CRT ansi_date                             ;* e.g. 2013-03-08

- Use spaces around "=":  not "var=1" but "var = 1".

- Use "=" for assignment only; for comparisons use "EQ".

- Don't use IF..ELSE without THEN.

- Avoid GOTO, RETURN TO as much as possible.

- Use named COMMON rather than unnamed.

- Don't use numeric line labels like:

       001 A = 0
       002 A += 1
       003 IF A LT 5 THEN GOTO 002 ELSE CRT A

- Avoid ambiguity with IF...AND...OR, use parentheses. In the following example code lines 2, 3 and 4 are the same (except parentheses); only second IF is true:

       var_1 = 1  ; var_2 = 2  ; var_3 = 3 ; var_4 = 4
       IF var_1 EQ 1 OR var_2 EQ 20 AND var_3 EQ 30 OR var_4 EQ 40 THEN CRT 1
       IF var_1 EQ 1 OR (var_2 EQ 20 AND var_3 EQ 30 OR var_4 EQ 40) THEN CRT 2
       IF (var_1 EQ 1 OR var_2 EQ 20) AND (var_3 EQ 30 OR var_4 EQ 40) THEN CRT 3

- Use only one method of writing "not equal" (preferably "NE").

(See the second example in chapter ["Other notes"](#Other_notes).)

# Environment Variables

## Minimum set of variables necessary to start development

Windows:

<pre>
    set TAFC_HOME=[path to installed TAFC]
    set JBCGLOBALDIR=%TAFC_HOME%
    set PATH=%TAFC_HOME%\bin;[path to C Compiler]\bin;%PATH%
    set JBCEMULATE=[your emulation; for T24 should be prime]
    set INCLUDE=[path to C Compiler]\include;%INCLUDE%
    set LIB=[path to C Compiler]\lib;%LIB%
    set JBCBASETMP=tmp_workfile</pre>

Unix/Linux:

<pre>
    export TAFC_HOME=[path to installed TAFC]
    export JBCGLOBALDIR=$TAFC_HOME
    export PATH=$TAFC_HOME/bin:$PATH
    export JBCEMULATE=[your emulation; for T24 should be prime]
    TTYNO=`tty | cut  -f4 -d\/`
    export JBCBASETMP=$HOME/jBASEWORK/tmp_$TTYNO
    export LD_LIBRARY_PATH=$TAFC_HOME/lib:/usr/ccs/lib:/usr/lib:/lib
    (Linux)
    export LIBPATH=$TAFC_HOME/lib:/usr/ccs/lib:/usr/lib
    (AIX)
    export SHLIB_PATH=$TAFC_HOME/lib:${SHLIB_PATH:-/usr/lib:/lib}
    (HP-UX)</pre>

## Customize work folders and files location

Main dictionary location (usually points to VOC file):

<pre>
    JEDIFILENAME_MD</pre>

Path to SYSTEM file (normally located in [path to installed TAFC]/src):

<pre>
    JEDIFILENAME_SYSTEM</pre>

Default path to jBASE data files:

<pre>
    JEDIFILEPATH</pre>

Location where programs will be put after compilation:

<pre>
    JBCDEV_BIN</pre>

The folder where shared libraries for compiled subroutines are located:

<pre>
    JBCDEV_LIB</pre>

Path to jBASE spooler folder:

<pre>
    JBCSPOOLERDIR</pre>

The folder where saved lists are placed:

<pre>
    JBCLISTFILE</pre>

Where to look for libraries containing compiled subroutines:

<pre>
    JBCOBJECTLIST</pre>

Could be several entries, e.g.:

Windows:

<pre>
    set JBCOBJECTLIST=%HOME%\lib;%HOME%\t24lib</pre>

Unix/Linux:

<pre>
    export JBCOBJECTLIST=$HOME/lib:$HOME/t24lib</pre>

If a subroutine presents in more than one location (which can be caused by
changing JBCDEV_LIB environment variable or accidental duplication of a
subroutine name) then the earlier location has the preference. See jshow output:

<pre>
    jshow -c ACCOUNT
    Subroutine:          C:\r11\bnk\bnk.run\lib\lib2.dll
                         jBC ACCOUNT version 11.0 Thu Sep 06 22:09:46 2012
                         jBC ACCOUNT source file ETC.BP
    Subroutine (DUP!!):  C:\r11\bnk\bnk.run\t24lib\acm_accountopening\lib0.dll
                         jBC ACCOUNT version 11.0 Fri Apr 29 14:43:35 2011
                         jBC ACCOUNT source file source/R11.000/win32_TAFCR11GA</pre>

In situation like that DECATALOG is to be used:

<pre>
    DECATALOG ETC.BP ACCOUNT
    Object ACCOUNT decataloged successfully
    Library C:\r11\bnk\bnk.run\lib\lib2.dll rebuild okay</pre>

<pre>
    jshow -c ACCOUNT
    Subroutine:          C:\r11\bnk\bnk.run\t24lib\acm_accountopening\lib0.dll
                         jBC ACCOUNT version 11.0 Fri Apr 29 14:43:35 2011
                         jBC ACCOUNT source file source/R11.000/win32_TAFCR11GA</pre>

## Runtime errors handling

This variable allows to suppress error messages and/or a program entering the debugger when divide by
zero is encountered:

<pre>
    JBASE_ERRMSG_DIVIDE_BY_ZERO</pre>

This variable allows to suppress error messages and/or a program entering the debugger when non-numeric
variable is used in an equation:

<pre>
    JBASE_ERRMSG_NON_NUMERIC</pre>

This variable allows to suppress error messages and/or a program entering the debugger when uninitialized
variable is used in an equation:

<pre>
    JBASE_ERRMSG_ZERO_USED</pre>

## Regional settings

Locale setting:

<pre>
    JBASE_LOCALE</pre>

In which codepage data is displayed (e.g. utf8, windows-1251 etc;
doesn't apply to how data is stored):

<pre>
    JBASE_CODEPAGE</pre>

Time zone:

<pre>
    JBASE_TIMEZONE
    E.g. Europe/London.</pre>

Setting this variable to 1 means utf-8 environment
(requires data files conversion when changed):

<pre>
    JBASE_I18N</pre>

## Diagnostics and tracing

Being set to 1 redirects stderr to stdout (useful to catch errors to COMO output):

<pre>
    JBC_STDERR</pre>

Being set to 1 stipulates creation of a core dump when the session crashes:

<pre>
    JBC_CORE_DUMP</pre>

jBASE tracing options:

<pre>
    JDIAG</pre>

E.g.:

<pre>
    set JDIAG=trace=JVM,CALLJ
    set JDIAG=TRACE=INDEX</pre>

## Other

Being set to 1 improves performance when distributed files are used:

<pre>
    JBASE_DISTRIB_FASTSCAN</pre>

Being set to 1 prevents all parts of a distributed file to be opened as soon as the stub had
been:

<pre>
    JEDI_DISTRIB_DEFOPEN</pre>

Terminal type (e.g. ntcon, vt220 etc):

<pre>
    TERM</pre>

# Compilation

## Introduction to BASIC...CATALOG and jcompile

<pre>
    BASIC MY.BP TEST.SUB
    &nbsp;
    TEST.SUB
    BASIC_1.c
    Source file TEST.SUB compiled successfully</pre>

<pre>
    CATALOG MY.BP TEST.SUB
    &nbsp;
    TEST.SUB
    Object TEST.SUB cataloged successfully
    Library $HOME\lib\lib0.dll rebuild okay</pre>

<pre>
    jcompile test.b
    &nbsp;
    Warning: Variable DIV.AMT2 is never assigned!
    test.c</pre>

Compilation results in appearance of an object and executable files
(sample for Windows):

<pre>
    test.obj
    test.dll
    test.exe</pre>

**See program information**:

<pre>
    jshow -c test
    &nbsp;
    Executable:          C:\r11\BATfiles\test.dll
                         jBC main() version 11.0 Thu Dec 06 23:35:34 2012
                         jBC main() source file unknown
    Executable (DUP!!):  C:\r11\BATfiles\test.exe
                         jBC main() version 11.0 Thu Dec 06 23:35:34 2012
                         jBC main() source file unknown</pre>

If the code is recompiled very often then it might happen that the older version
of executable code
still resides in shared memory and the result of changes wouldn't be seen immediately.
In this case "-E" option of jcompile can be used to build executable only
and not the shared library, e.g.:

<pre>
    jcompile -E test.b</pre>

And then test.dll isn't created. The final compilation is of course to be done
without "-E" option. Also - without shared library CHAIN statement might work
not as expected and persistence of COMMON areas won't be supported.

**See commands** used by compiler:

<pre>
    jcompile -v test.b
    &nbsp;
    cl /nologo /DWIN32 /MD /W2 /GR /EHa -c -IC:\TAFC\include -DJBC_OPTLEVEL2 test.c
    ...
    cl /nologo /DWIN32 /MD /W3 /GR /EHa /GF /Zi /F5000000 -D_LARGEFILE_SOURCE ...</pre>

**Conditional compilation**:

       V.VAR = 1
       CRT 'Version ':
    #ifdef VER1
       CRT V.VAR:
    #else
       CRT V.VAR + 1:
    #endif
       CRT ' finished'

<pre>
    jcompile -DVER1 test.b
    test.c
    &nbsp;
    test
    Version 1 finished</pre>

<pre>
    jcompile test.b
    test.c
    &nbsp;
    test
    Version 2 finished</pre>

**To look at C code** rather than to create executables "-S" option can be used
(files test.c and test.j will be created for test.b source).

Full information about jcompile options - "jcompile -H".

# Data Files

## Introduction to jBASE/TAFC data files

The most widely used formats for data files nowadays are "J4" and "JR".
The former has size limitation (up to 2Gb if OS-level limits allow that)
and needs resizing on regular basis though when it's properly sized it's
faster. "JR" - "resilient" - doesn't have size limitation and
doesn't need resizing.

The following examples serve as a brief introduction to jBASE data storage.
They can be executed in jshell prompt or (except JED - it makes no sense)
in a jBC program or subroutine (using EXECUTE/PERFORM).

## Create/delete hashed file

Create both data and dictionary:

<pre>
    CREATE-FILE F.SAMPLE 101 1
    &nbsp;
    [ 417 ] File F.SAMPLE]D created , type = J4
    [ 417 ] File F.SAMPLE created , type = J4</pre>

If the file already exists, the error message appears:

<pre>
    [ 413 ] File name DICT F.SAMPLE already exists</pre>

Delete hashed file (both data and dictionary):

<pre>
    DELETE-FILE F.SAMPLE</pre>

Create hashed file (data only):

<pre>
    CREATE-FILE DATA F.SAMPLE 101 1
    &nbsp;
    [ 417 ] File F.SAMPLE created , type = J4</pre>

Create hashed file (dictionary only):

<pre>
    CREATE-FILE DICT F.SAMPLE 101 1
    &nbsp;
    [ 417 ] File F.SAMPLE]D created , type = J4</pre>

## Create and list the data

Put some data to file:

<pre>
    JED F.SAMPLE REC1
    &nbsp;
    0001 Field one
    0002 Field two
    0003 Field three</pre>

Press Esc; then type FI to save the record.

List file contents:

<pre>
    LIST F.SAMPLE
    &nbsp;
    F.SAMPLE......
    &nbsp;
    REC1
    &nbsp;
    1 Records Listed</pre>

No dictionary; we see only @ID. Raw output:

<pre>
    CT F.SAMPLE
    &nbsp;
    REC1
    001 Field one
    002 Field two
    003 Field three</pre>

As an alternative, we can use standard correlatives:

<pre>
    LIST F.SAMPLE &lowast;A1 &lowast;A2 &lowast;A3
    &nbsp;
    F.SAMPLE......   &lowast;A1...........   &lowast;A2...........   &lowast;A3...........
    &nbsp;
    REC1             Field one        Field two         Field three</pre>

## Adding dictionary items

Add a dictionary item to assign the name to a field:

<pre>
    JED DICT F.SAMPLE FLD1
    &nbsp;
    0001 D
    0002 1
    0003
    0004 FIELD 1 HEADER
    0005 10L
    0006 S
    0007</pre>

Use field name in a query:

<pre>
    LIST F.SAMPLE FLD1
    &nbsp;
    F.SAMPLE......   FIELD 1 HEADER
    &nbsp;
    REC1             Field one
    &nbsp;
    1 Records Listed</pre>

<pre>
    LIST F.SAMPLE WITH FLD1 EQ ''
    &nbsp;
     No Records Listed</pre>

In default view we still dont have it:

<pre>
    LIST F.SAMPLE
    &nbsp;
    F.SAMPLE......
    &nbsp;
    REC1</pre>

Set the field to be seen by default:

<pre>
    JED DICT F.SAMPLE @
    &nbsp;
    0001 PH
    0002 @ID FLD1</pre>

See the result:

<pre>
    LIST F.SAMPLE
    &nbsp;
    F.SAMPLE......   ID..................   FIELD 1 HEADER
    &nbsp;
    REC1             REC1                   Field one</pre>

## Change of size and format, statistics, properties

See file statistics:

<pre>
    jstat -v F.SAMPLE
    &nbsp;
    File C:\r11\bnk\bnk.run\F.SAMPLE
    Type=J4 , Hash method = 5
    Created at Tue Nov 20 19:38:25 2012
    Groups = 101 , Frame size = 4096 bytes , Secondary Record Size = 8192 bytes
    Restore re-size parameters : (none)
    File size = 417792 bytes , Inode = 29838 , Device = Id 24915
    Last Accessed Tue Nov 20 19:50:30 2012 , Last Modified Tue Nov 20 19:50:30 2012
    Backup = YES , Log = YES , Rollback = YES , Network = NO
    Record Count = 1 , Record Bytes = 45
    Bytes/Record = 45 , Bytes/Group = 0
    Primary file space:   Total Frames = 101 , Total Bytes = 45
    Secondary file space: Total Frames = 0 , Total Bytes = 0</pre>

### NOTE

101 - number of groups - was defined when file was created.

Add more records:

<pre>
    COPY FROM F.SAMPLE REC1,REC2
    &nbsp;
    1 records copied</pre>

Try to resize the file:

<pre>
    jrf -V F.SAMPLE
    &nbsp;
    ...
    Downsizing skipped from modulo 101 to 3.</pre>

Resize it anyway:

<pre>
    jrf -VD F.SAMPLE
    &nbsp;
    ...
    Downsizing from modulo 101 to 3</pre>

Change file type to JR:

<pre>
    jrf -H6 F.SAMPLE</pre>

See statistics now:

<pre>
    jstat -v F.SAMPLE
    &nbsp;
    File Type       = JR,        Hash method = 5, Created = Tue Nov 20 19:56:00 2012
    Frame size      = 4096,        OOG Threshold   = 2048
    File size       = 8192, Freespace       = 0 frames
    Internal Modulo = 3/7/11,      External Modulo = 13
    Inode no.       = 29838,       Device no.      = 24915
    Accessed        = Tue Nov 20 19:56:13 2012, Modified  = Tue Nov 20 19:56:13 2012
    Backup  = YES, Log      = YES, Rollback        = YES,  Secure updates  = NO
    Deallocate pointers : NO       Deallocate frames NO
    Revision level  = 2
    Record Bytes    = 82,   Record Count    = 2
    Bytes/Record    = 41,   Bytes/Group     = 82
    Data Frames     = 1,    Ptr Frames      = 0
    OOG Bytes       = 0,    OOG Frames      = 0
    Sum Squares     = 3362, Std Dev Mean    = 41</pre>

Turn on secure updates:

<pre>
    jchmod +S F.SAMPLE</pre>

Check the result:

<pre>
    jstat -v F.SAMPLE
    &nbsp;
    ...
    Backup  = YES, Log      = YES,  Rollback        = YES,  Secure updates  = YES
    ...</pre>

Delete a record:

<pre>
    DELETE F.SAMPLE REC2
    &nbsp;
    1 record(s) deleted.</pre>

Add data sections:

<pre>
    CREATE-FILE F.SAMPLE,TWO TYPE=JR
    &nbsp;
    [ 417 ] File F.SAMPLE]MTWO created , type = JR</pre>

<pre>
    CREATE-FILE F.SAMPLE,THREE TYPE=JR
    &nbsp;
    [ 417 ] File F.SAMPLE]MTHREE created , type = JR</pre>

Create a record in a section:

<pre>
    JED F.SAMPLE,TWO REC5
    &nbsp;
    0001 Section 2/1
    0002 Section 2/2
    0003 Section 2/3</pre>

See that all sections use the same dictionary:

<pre>
    LIST F.SAMPLE,TWO
    &nbsp;
    F.SAMPLE,TWO..    ID..................    FIELD 1 HEADER
    &nbsp;
    REC5              REC5                    Section 2/1</pre>

<pre>
    LIST F.SAMPLE,THREE
    &nbsp;
    F.SAMPLE,THREE    ID..................    FIELD 1 HEADER
    &nbsp;
     No Records Listed</pre>

### NOTE

File F.SAMPLE still reports 1 record in it; here's the difference
between having several data sections and a distributed file.

## UD type

Folders are also treated like data files (type UD); flat files in them -
like records. This allows, for example, use JED to edit source code.
Data can be copied transparently between hashed
files and folders. Some examples:

Create the folder:

<pre>
    CREATE-FILE DATA TEST.BP TYPE=UD
    &nbsp;
    [ 417 ] File TEST.BP created , type = UD</pre>

Create a program:

<pre>
    JED TEST.BP PROG1
    &nbsp;
    0001 CRT 2*2</pre>

Save file. Compile and run it:

<pre>
    BASIC TEST.BP PROG1
    &nbsp;
    PROG1
    BASIC_3.c
    Source file PROG1 compiled successfully</pre>

<pre>
    CATALOG TEST.BP PROG1
    &nbsp;
    PROG1
    Object PROG1 cataloged successfully</pre>

<pre>
    PROG1
    &nbsp;
    4</pre>

Copy data:

<pre>
    COPY FROM F.SAMPLE TO TEST.BP REC1
    &nbsp;
    1 records copied</pre>

Edit file REC1 in TEST.BP folder with any text editor so it now looks like:

<pre>
    Field one - updated
    Field two
    Field three</pre>

Copy it back to hashed file:

<pre>
    COPY FROM TEST.BP TO F.SAMPLE REC1 OVERWRITING
    &nbsp;
    1 records copied</pre>

See the result:

<pre>
    LIST F.SAMPLE
    &nbsp;
    F.SAMPLE......     ID..................   FIELD 1 HEADER
    &nbsp;
    REC1               REC1                   Field one - up
                                              dated</pre>

