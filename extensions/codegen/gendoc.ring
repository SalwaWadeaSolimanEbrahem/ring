# Generate Documentation from Configuration File
# Author : Mahmoud Fayed <msfclipper@yahoo.com>
# Date : 2016.09.22

#==========   Expect the next input
# C_OUTPUTFILE = "qtclassesdoc.txt"
# C_CHAPTERNAME = "RingQt Classes Reference"
# cFile = read("qt.cf")
# lStart = False		# False = Classes Doc.   True = Functions Doc.
#===============================================


aList = str2list(cFile)

cOutput = ".. index:: " + windowsnl() 
cOutput += "     single: "+C_CHAPTERNAME+"; Introduction" + windowsnl() + windowsnl()
cOutput += "========================" + windowsnl()
cOutput += C_CHAPTERNAME + windowsnl()
cOutput += "========================" + windowsnl() + windowsnl()


for x = 1 to len(aList) 
	cLine = trim(aList[x])
	if left(lower(cLine),7)="<class>"		 
		lStart = True
		x++
		do 
			cLine = trim(aList[x])
			if left(cLine,5) = "name:"
				cClassName = trim(substr(cLine,6)) + " Class"
				cOutput += Windowsnl() + ".. index::" + windowsnl()  
				cOutput +="	pair: "+C_CHAPTERNAME+"; "
				cOutput += cClassName + WindowsNl()

				cOutput += windowsnl() + cClassName + windowsnl()
				cOutput += Copy("=",len(cClassName)) + windowsnl() + windowsnl()
			ok
			if left(cLine,7) = "parent:"
				cClassName = trim(substr(cLine,8)) 
				cOutput += windowsnl() + "Parent Class : " + cClassName + WindowsNl() + WindowsNl()
			ok
			if left(cLine,5) = "para:"
				cClassName = trim(substr(cLine,6)) 
				cOutput += windowsnl() + "Parameters : " + cClassName + WindowsNl() + WindowsNl()
			ok

			x++
		again left(lower(cLine),8) !="</class>"
		loop
	ok
	if left(lower(cLine),9)="<comment>"		 
		x++
		do 
			cLine = trim(aList[x])
			x++
		again left(lower(cLine),10) !="</comment>"
		loop
	ok
	avoidblock("code")
	avoidline("register")
	avoidline("filter")

	if lStart
		if (cLine != NULL ) and len(cLine) > 1
			cLine = substr(cLine,"@","_")
			cOutput += "* " + cLine + windowsnl()
		ok
	ok
next

write(C_OUTPUTFILE,cOutput)
system(C_OUTPUTFILE)


func avoidblock cStr

	if left(lower(cLine),len(cStr)+2)="<"+cStr +">"		 
		x++
		do 
			cLine = trim(aList[x])
			x++
		again left(lower(cLine),len(cStr)+3) !="</"+cStr+">"
		loop
	ok

func avoidline cStr
	if ( left(lower(cLine),len(cStr)+2)="<"+cStr + ">" ) or ( left(lower(cLine),len(cStr)+3)="</"+cStr + ">"  )
		loop
	ok
