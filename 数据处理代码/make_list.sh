a=/hwfssz1/ST_EARTH/P18Z10200N0112/USER/hucankun/project/soybean_16s/smsj
for i in $( ls $a )
do
   if [ $( echo ${i:0:6} ) == "Desert" ]
   then
      b=/hwfssz1/ST_EARTH/P18Z10200N0112/USER/hucankun/project/soybean_16s/smsj/$i/forward
      c=$( echo ${i:7:3} )
      if [ ! -d list/$c ];then
         mkdir -p list/$c
         touch list/$c/$i.sample.list 
      fi
      for j in $( ls $b )
      do
         j=$( echo ${j%%.*} )
         echo "$j" >> list/$c/$i.sample.list
         echo "$j" >> $c.sample.list
      done
   fi
done



