#!/bin/bash

# Uses dashing, pandoc
# github.com/technosophos/dashing
# pandoc.org

FILE_J_ORIG=jbc.md
FILE_J=${FILE_J_ORIG}.typed
FILE_S_ORIG=sysvar.md
FILE_S=${FILE_S_ORIG}.typed
FILE_C_ORIG=categ.md
FILE_C=${FILE_C_ORIG}.typed
FILE_TMP=docset.md

cp -f $FILE_J_ORIG $FILE_J
cp -f $FILE_S_ORIG $FILE_S
cp -f $FILE_C_ORIG $FILE_C
rm -f $FILE_TMP

# --- JBC.MD ---

# Assign function/statement as per mapping
cat jbc1.map | while read i; do

    IFS=':' read -r -a DETAILS <<< "$i"
    NAME="${DETAILS[0]}"
    TYPE=${DETAILS[1]:-builtin}

    NAME=$(echo ${NAME} | sed -e 's/[\/&]/\\&/g')

    sed -i "" "s/^# ${NAME}\$/# ${NAME} %${TYPE}%/g" $FILE_J

done

# Fill in exceptions
sed -i "" -e '/^# .*%.*/b' -e 's/^# \(.*\)$/# \1 %exception%/g' $FILE_J

# --- SYSVAR.MD ---

# Assign variable
sed -i "" -e '/^# .*%.*/b' -e 's/^# \(.*\)$/# \1 %variable%/g' $FILE_S

# --- CATEG.MD ---

# Assign variable
sed -i "" -e '/^# .*%.*/b' -e 's/^# \(.*\)$/# \1 %category%/g' $FILE_C

cat $FILE_C $FILE_S $FILE_J >> $FILE_TMP

pandoc -f markdown-citations --toc-depth=1 -t epub -o jbc.epub $FILE_TMP

rm -rf epub; mkdir epub; cd epub; unzip ../*.epub
rm -rf META-INF/  content.opf  mimetype  title_page.xhtml  toc.ncx
sed -i "" 's/UNTITLED/Functions and Statements/g' nav.xhtml

sed -i "" 's/<\(.*\)>\(.*\) %\(.*\)%/<\1 class="\3">\2/g' *xhtml
cd ..

rm -rf jBASE.docset
dashing build -s epub/

#rm -rf $FILE_J $FILE_S $FILE_C $FILE_TMP epub/
