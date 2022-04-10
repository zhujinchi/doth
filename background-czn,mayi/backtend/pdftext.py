# coding:utf-8

import PyPDF2

pdffile= open(r'C:\Users\Administrator\Desktop\22\chapter1.pdf','rb')# 读取pdf文件

pdfreader= PyPDF2.PdfFileReader(pdffile)# 读入到

print(pdfreader.numPages)# 读取pdf页数======19

page0= pdfreader.getPage(0)#获取第1页，第一页是0

print(page0.extractText())# 获取第2页的内容，返回的是字符串