# -*- coding: utf-8 -*-
"""
Created on Mon Jun 15 15:46:57 2020

@author: Sundara Vel Selvaraj
"""
import re
from datetime import datetime

def prog1(string):
    '''
    Program to match a string that has an a followed by zero 
    or more b's
    '''
    pattern='ab*'
    matched=re.search(pattern,string)
    match=re.findall(pattern,string)
    if matched:
        return f"Match found for a string that has an a followed by zero or more b's: {match}"
    else:
        return "Match not found"
    
def prog2(string):
    '''
    Program to find sequences of one upper case letter followed
    by lower case letters
    '''
    pattern="[A-Z][a-z]+"
    match=re.findall(pattern,string)
    print(f"Found sequences of one upper case letter followed by lower case letters: {match}")

def prog3(string):
    '''
    Program to match a string that has an 'a' followed 
    by anything, ending in 'b' 
    '''
    pattern="a.*?b$"
    matched=re.search(pattern,string)
    match=re.findall(pattern,string)
    if matched:
        return f"Match found for a string that has an 'a' followed by anything, ending in 'b': {match}"
    else:
        return "Match not found"

def prog4(string):
    '''
    Program to match a word containing 'z', not start or end of the word
    '''
    pattern="\Bz\B"
    matched=re.search(pattern,string)
    #match=re.findall(pattern,string)
    if matched:
        return "Match found for a word containing 'z', not start or end of the word"
    else:
        return "Match not found"

def prog5(string):
    '''
    Program to split a string with multiple delimiters 
    '''
    pattern=',|;|\n|\t|\*'
    return re.split(pattern,string)

def prog6(string):
    '''
    Program to find all adverbs and their positions in a given sentence 
    '''
    if re.search(r"\w+ly",string):
        for match in re.finditer(r"\w+ly", string):
            print(f'Found english adverb: "{match.group(0)}" and their start and end positions are: {match.start()}, {match.end()}')
    if re.search(r"\w+ment",string):
        for match in re.finditer(r"\w+ment", string):
            print(f'Found french adverb: "{match.group(0)}" and their start and end positions are: {match.start()}, {match.end()}')

def prog7(string):
    '''   
    Program to find all Dates in a text
    '''
    try:
        #match = re.search(r'(\d+/\d+/\d+)',string)
        match=re.search(r'[\d]{1,2}(\.|-|/)[\d]{1,2}(\.|-|/)[\d]{4}',string)
        date=match.group()
        date=re.sub(r'(\.|-|/)','/',date)
        day,month,year=date.split('/')
        if int(month)<=12:
            french_date=datetime.strptime(date,"%d/%m/%Y")
            french_format=french_date.strftime("%d-%m-%Y")
            print(f'French format:{french_format}')
            eng_date=french_date.strftime("%m-%d-%Y")
            print(f'English Format:{eng_date}')
        else:
            eng_date = datetime.strptime(date, "%m/%d/%Y")
            eng_format=eng_date.strftime("%m-%d-%Y")
            print(f'English Format:{eng_format}')  
            french_format=eng_date.strftime("%d-%m-%Y")
            print(f'French format:{french_format}')
    except ValueError:
        print("Date not found")
            
#To match a string that has an a followed by zero or more b's
print(prog1('abig'))
#To find sequences of one upper case letter followed by lower case letters
prog2('Kaisens Data company')
#To match a string that has an 'a' followed by anything, ending in 'b' 
print(prog3('aerob'))
#To match a word containing 'z', not start or end of the word
print(prog4('fizy'))
#To split a string with multiple delimiters
print(prog5('Kaisens data\nExpert Big data;Datascience,Courbevoie'))
#To find all adverbs and their positions in a given sentence
prog6('Kaisens data are efficiently providing big data solutions')
prog6('Le Kaisens data fournissent efficacement des solutions de Big Data')
#To find all Dates in a text
prog7('The date is 29.2.2020')





