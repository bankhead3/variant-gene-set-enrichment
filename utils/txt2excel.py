#!/usr/bin/python
# 20170127 arb
# convert txt file to excel file

import sys
import os
import re
import xlsxwriter
import string
import pandas as pd

# check input file
assert len(sys.argv) == 2, 'USAGE: ' + sys.argv[0] + ' <TXTFILE>'
inFile1 = sys.argv[1]
assert os.path.isfile(inFile1), inFile1 + ' does not exist!'

outFile1 = inFile1 + '.txt' if not re.findall('.txt$',inFile1) else inFile1.replace('.txt','.xlsx')

df = pd.read_csv(inFile1,sep='\t',encoding='utf-8')

writer = pd.ExcelWriter(outFile1)
df.to_excel(writer,'sheet1',freeze_panes=(1,0),index=False,na_rep = 'NA')

# retrieve worksheet object
worksheet = writer.sheets['sheet1']

# set up autofilter
myLetter = string.ascii_uppercase[len(df.columns)-1]
myRange = 'A1:' + myLetter + '1'
worksheet.autofilter(myRange)

writer.save()
