#!/bin/bash

echo "select window with mouse click"
windowid=`xdotool selectwindow`
windowpos=`xdotool getwindowgeometry $windowid | grep -o "[0-9]*,[0-9]*"`
wx=`echo $windowpos | grep -o "^[0-9]*"`
wy=`echo $windowpos | grep -o "[0-9]*$"`
echo $windowpos
echo $wx
echo $wy
sleep 2
MOUSE_ID=$(xinput --list | grep -i -m 1 'mouse\|alps' | grep -o 'id=[0-9]\+' | grep -o '[0-9]\+')
echo $MOUSE_ID

echo "click top-left corner"
STATE1=$(xinput --query-state $MOUSE_ID | grep 'button\[' | sort)
STATE2=$(xinput --query-state $MOUSE_ID | grep 'button\[' | sort)
while [ "$STATE1" == "$STATE2" ]; do
    sleep 0.1
    STATE2=$(xinput --query-state $MOUSE_ID | grep 'button\[' | sort)
done
echo "clicked"
x1=`xdotool getmouselocation | grep -o "x:[0-9]*" | grep -o "[0-9]*"`
y1=`xdotool getmouselocation | grep -o "y:[0-9]*" | grep -o "[0-9]*"`
echo "x1:" $x1
echo "y1:" $y1
sleep 2

echo "click bottom-right corner"
STATE1=$(xinput --query-state $MOUSE_ID | grep 'button\[' | sort)
STATE2=$(xinput --query-state $MOUSE_ID | grep 'button\[' | sort)
while [ "$STATE1" == "$STATE2" ]; do
    sleep 0.1
    STATE2=$(xinput --query-state $MOUSE_ID | grep 'button\[' | sort)
done
echo "clicked"
x2=`xdotool getmouselocation | grep -o "x:[0-9]*" | grep -o "[0-9]*"`
y2=`xdotool getmouselocation | grep -o "y:[0-9]*" | grep -o "[0-9]*"`
echo "x2:" $x2
echo "y2:" $y2
width="$(($x2-$x1))"
height="$(($y2-$y1))"
echo "width: " $width
echo "height: " $height
relx="$(($x1+wx))"
rely="$(($y1+yx))"
geometry="$width"x"$height"+"$relx"+"$rely"
echo $geometry
echo $windowid

while true; do
    maim -g $geometry -q > jp.png
    echo "screenshot captured"
    tesseract jp.png tout -l jpn 2> /dev/null
    echo "text parsed:"
    sed 's/ //g' tout.txt > tout2.txt
    cat tout2.txt
    ./tokenize.py `cat tout2.txt`
    #trans -brief "`cat tout2.txt`"
    #sleep 1
    #trans -s 日本語 --show-original n "`cat tout2.txt`"
    trans -s 日本語 -brief --show-original Y -i tout2.txt
    sleep 2
#    rm tout.txt tout2.txt jp.png
    sleep 10
done
