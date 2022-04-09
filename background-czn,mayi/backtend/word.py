# coding:utf-8

import docx
from docx import Document

# docStr = Document("C:\Users\Administrator\Desktop\w.docx") #打开文档
#
# neirong = "";
# for paragraph in docStr.paragraphs:
#     parStr = paragraph.text
#     neirong = neirong + parStr + "\n";
#
#
# print(neirong)

import os
basedir = os.path.abspath(os.path.dirname(__file__))
print(basedir)