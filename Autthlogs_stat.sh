#!/usr/bin/bash
# 21/08/2020
# Logs stats by Josue Martins
# Please run the script in the following way to suppress unecessary outputs.
# ./Autthlogs_stat.sh ~/. 2>/dev/null



#Displaying, which logs files the script is reading data from.
echo "Reading from the following files:";
echo "Size	Name of the file";
find . -name 'authlog' | xargs du -h;

#finding this logs with successfull attempts
find . -name 'authlog' | xargs cat | egrep 'Accepted[[:blank:]]keyboard-interactive/pam[[:blank:]]for | Accepted[[:blank:]]publickey[[:blank:]]for' >> "sample.txt" ;
cat "sample.txt" >> "sample2.txt"; 

#finding logs with failed attempts
find . -name 'authlog' | xargs cat | egrep 'Failed[[:blank:]]none[[:blank:]]for' | egrep -i -v 'illegal|invalid' >> "sample3.txt" ; 
cat "sample3.txt" >> "sample4.txt";

#finding logs with failed attempts by illegal user.
find . -name 'authlog' | xargs cat | egrep 'Failed[[:blank:]]none[[:blank:]]for[[:blank:]]illegal'| egrep -i -v 'Failed[[:blank:]]none[[:blank:]]for[[:blank:]]illegal[[:blank:]]user[[:blank:]]ssh|Failed[[:blank:]]none[[:blank:]]for[[:blank:]]illegal[[:blank:]]user[[:blank:]]telnet|Failed[[:blank:]]none[[:blank:]]for[[:blank:]]illegal[[:blank:]]user[[:blank:]][[:blank:]]from[[:blank:]]'>> "illegal.txt";
cat "illegal.txt" >> "illegal2.txt";

#Jul 23 22:16:03 bear sshd[27716]: Failed none for illegal user telnet 172.19.1.20 from 10.22.135.166 port 3003 ssh2
find . -name 'authlog' | xargs cat | egrep 'Failed[[:blank:]]none[[:blank:]]for[[:blank:]]illegal[[:blank:]]user[[:blank:]]ssh|Failed[[:blank:]]none[[:blank:]]for[[:blank:]]illegal[[:blank:]]user[[:blank:]]telnet'| egrep -i -v 'Failed[[:blank:]]none[[:blank:]]for[[:blank:]]illegal[[:blank:]]user[[:blank:]][[:blank:]]from[[:blank:]] && Failed[[:blank:]]none[[:blank:]]for[[:blank:]]illegal[[:blank:]]user[[:blank:]]ssh|Failed[[:blank:]]none[[:blank:]]for[[:blank:]]illegal[[:blank:]]user[[:blank:]]telnet[[:blank:]][[a-z][A-Z][0-9]]'>> "illegaluser.txt";


#Apr 26 14:35:33 bear sshd[1576]: Failed none for illegal user  from 
#finding users with double space infront of them.
find . -name 'authlog' | xargs cat | egrep 'Failed[[:blank:]]none[[:blank:]]for[[:blank:]]illegal[[:blank:]]user[[:blank:]][[:blank:]]from[[:blank:]]'>> "illegalfrom.txt";


#findling logs with Invalid users and grepping dead hours for them.
find . -name 'authlog' | xargs cat | egrep 'Invalid[[:blank:]]user[[:blank:]]' >> "invalid.txt" ; 
cat "invalid.txt" >> "invalid2.txt"; 
sed -i -e 's/Binary file (standard input) matches//g' "*.txt";


echo "#################################################################";
#this code shows the stats of users attempts
#Total successful attempts by users
awk 'BEGIN {									
print "**User** \t**Total successful attempts by users** \t";

}
{
User[$9]++; 
count[$9]+=$NF;

}
END{
for (var in User)
	print var,"\t\t ------->\t\t",User[var];
	
}
' "sample2.txt" ;
echo "#################################################################";

#Total failed attempts by users
awk 'BEGIN {									
print "**User** \t**Total failed attempts by users** \t";

}
{
User[$9]++;
count[$9]+=$NF;

}
END{
for (var in User)
	if (length(var) != 0)
	print var,"\t\t -------> ",User[var];
	
}
' "sample3.txt" ;
echo "#################################################################";

#Total failed attempts by illegal users 
sed ':a;/user  /{s/user  /user /;ba}' "illegal2.txt" >> "illegalu.txt";

awk 'BEGIN {									
print "**User** \t**Total failed attempts by illegal users** \t";

}
{
User[$11]++;
count[$11]+=$NF;

}
END{
for (var in User)
	if (length(var) != 0)
	print var,"\t\t -------> ",User[var];
	
}
' "illegalu.txt";
echo "#################################################################";
awk 'BEGIN {									
print "**User**\t\t Total failed none for illegal user via ssh or telnet " 
}
{
User[$12]++;
count[$12]+=$NF;

}
END{
for (var in User)
	if (length(var) != 0)
	print var,"\t\t -------> ",User[var];
	
}' "illegaluser.txt";
echo "#################################################################";
awk 'BEGIN {									
print "**User**\t\t Total failed none for illegal user with blank names via the following ips: " 
}
{
User[$12]++;
count[$12]+=$NF;

}
END{
for (var in User)
	if (length(var) != 0)
	print var,"\t\t -------> ",User[var];
	
}' "illegalfrom.txt";

echo "#################################################################";

#Total failed attempts by illegal users

awk 'BEGIN {									
print "**User** \t**Total failed attempts by invalid users** \t";

}
{
User[$8]++;
count[$8]+=$NF;

}
END{
for (var in User)
	if (length(var) != 0)
	print var,"\t\t -------> ",User[var];
	
}
' "invalid2.txt" ;

echo "#################################################################";


#this code shows the stats on attempts by IP.
#Total successful attempts by IPs
awk 'BEGIN {									
print "**IP ** \t**Total successful attempts by IPs** \t";

}
{
IPs[$11]++;
count[$11]+=$NF;

}
END{
for (var in IPs)
	if (length(var) != 0)
	print var,"\t\t -------> ",IPs[var];
	
}
' "sample2.txt" ;

echo "#################################################################";

#Total failed attempts by IPs
awk 'BEGIN {									
print "**IP ** \t**Total failed attempts by IPs** \t";

}
{
IPs[$11]++;
count[$11]+=$NF;

}
END{
for (var in IPs)
		if (length(var) != 0)
		print var,"\t\t -------> ",IPs[var];
	
}
' "sample3.txt" ;
echo "#################################################################";

#Total failed attempts by IPs via illegal users.
awk 'BEGIN {									
print "**IP ** \t**Total failed attempts by IPs via illegal users** \t";

}
{
IPs[$13]++;
count[$13]+=$NF;



}
END{
for (var in IPs)
	if ((length(var) != 0)&&(length(var) != 4))	
	print var,"\t\t -------> ",IPs[var];
	
}
' "illegal2.txt" ;
echo "##################################################################";

#Total failed attempts by ip from invalid users.
awk 'BEGIN {									
print "**IP ** \t**Total failed attempts by ip from invalid users** \t";

}
{
IPs[$10]++;
count[$10]+=$NF;

}
END{
for (var in IPs)
	if (length(var) != 0)
	print var,"\t\t -------> ",IPs[var];
	
}
' "invalid2.txt" ;

echo "#################################################################";

#this code shows the stats on attempts by hours

cat "sample2.txt" | tr ":" " " >>"sample22.txt";

awk 'BEGIN {									
print "**Hours ** \t**Total successful attempts by hour** \t";

}
{
hours[$3]++;
count[$3]+=$NF;

}
END{
for (var in hours)
	if (length(var) != 0)
	print var,"\t\t -------> ",hours[var];
	
}
' "sample22.txt" ;

cat "sample3.txt" | tr ":" " " >>"sample33.txt";
sed -i -e 's/Binary file (standard input) matches//g' "sample33.txt";

echo "#################################################################";

awk 'BEGIN {									
print "**Hours ** \t**Total failed attempts by hour** \t";

}
{
hours[$3]++;
count[$3]+=$NF;

}
END{
for (var in hours)
	if (length(var) != 0)
	print var,"\t\t -------> ",hours[var];
	
}
' "sample33.txt" ;
echo "#################################################################";

cat "illegal2.txt" | tr ":" " " >>"illegal4.txt";
sed -i -e 's/Binary file (standard input) matches//g' "illegal2.txt";
sed -i -e 's/Binary file (standard input) matches//g' "illegal4.txt";
awk 'BEGIN {									
print "**Hours ** \t**Total failed attempts by hour for illegal users** \t";

}
{
hours[$3]++;
count[$3]+=$NF;

}
END{
for (var in hours)
	if (length(var) != 0)
	print var,"\t\t -------> ",hours[var];
	
}
' "illegal4.txt" ;
echo "#################################################################";

cat "invalid2.txt" | tr ":" " " >>"invalid22.txt";
sed -i -e 's/Binary file (standard input) matches//g' "invalid22.txt";

awk 'BEGIN {									
print "**Hours ** \t**Total failed attempts by hour from invalid users** \t";

}
{
hours[$3]++;
count[$3]+=$NF;

}
END{
for (var in hours)
	if (length(var) != 0)
	print var,"\t\t -------> ",hours[var];
	
}
' "invalid22.txt" ;
echo "#################################################################";
#Please remove the temporary files because if they stay in the diretory.
#They will affect the values on the stats.


rm "sample.txt";
rm "sample2.txt";
rm "sample22.txt";
rm "sample3.txt";
rm "sample33.txt";
rm "sample4.txt";
rm "illegal.txt";
rm "illegal2.txt";
rm "illegal4.txt";
rm "illegaluser.txt";
rm "invalid.txt";
rm "invalid2.txt";
rm "invalid22.txt";
############################### THE END###################################


