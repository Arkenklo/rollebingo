#!/bin/bash

XMAX=5
SIZE=150px
FILE=bingolista
#if [ ! -f "$1" ]; then
#	echo no such file: "$1"
#	exit 1
#fi

echo -ne "Content-Type: text/html; charset=utf-8\r\n\r\n"

echo '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
</head>'
echo "<style>
table
{
	border-collapse:collapse;
}
table, td, th
{
	border:1px solid black;
	overflow: hidden;
}
td
{
	width: $SIZE;
	height: $SIZE;
	max-width: $SIZE;
	max-height: $SIZE;
}
</style>"

echo '<h1>ROLLEBINGO!</h1>'
echo '<table border=\"1\">'

echo '<tr>'
x=-1
sort -R < $FILE | while read i; do
	x=$(expr $x + 1)
	if [ $x -eq $XMAX ]; then
		echo "</tr>
		<tr>"
		x=0
	fi
	echo "<td>$i</td>"
done

echo "</tr></table>
</html>"

