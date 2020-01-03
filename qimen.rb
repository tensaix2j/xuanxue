#encoding: utf-8

# Work in Progress...

require_relative 'cdate'
require_relative 'goleph.rb'
require 'time'

def main()

	v = {}

	#              0     1     2     3     4     5     6    7    8     9
	v["天干"] = [ "甲", "乙", "丙", "丁", "戊", "己", "庚", "辛", "壬", "癸" ]
	v["地支"] = [ "子", "丑", "寅", "卯", "辰", "巳", "午", "未", "申", "酉", "戌", "亥"]
	
	#               0      1      2     3     4      5      6     7      8     9
	v["五行"] = ["阳木","阴木","阳火","阴火","阳土","阴土","阳金","阴金","阳水","阴水"]

	v["干五行"] = [ 0,  1,  2,  3,  4,  5,  6,  7,  8,  9 ]
	v["支五行"] = [ 8,  5,  0,  1,  4,  3,  2,  5,  6,  7,  4,  9]

	v["支藏干"] = [ 
					[9],
					[5,9,7],
					[0,2,4],
					[1],
					[4,1,9],
					[2,6,4],
					[3,5],
					[5,3,1],
					[6,8,4],
					[7],
					[4,7,3],
					[8,0] 
				]
	
	v["干阴阳"] = [ 1,  -1, 1 , -1, 1, -1, 1, -1, 1, -1 ]			
	v["支阴阳"] = [ 1,  -1, 1 , -1, 1, -1, 1, -1, 1, -1 , 1 , -1 ]				
	
	v["推干法"] = [ 0, 2, 4 , 6, 8, 0, 2, 4, 6, 8 ]
	v["节气"]   = ['冬至','小寒','大寒','立春','雨水','惊蛰','春分','清明','谷雨','立夏','小满','芒种','夏至','小暑','大暑','立秋','处暑','白露','秋分','寒露','霜降','立冬','小雪','大雪']

	#  三奇六仪:  戊、己、庚、辛、壬、癸、丁、丙、乙
	#    w.r.t  天干 index
	v["三奇六仪"] = [ 4,5,6,7,8,9 , 3,2,1 ]

	#上　　　　　中　　　　　下
	#冬至一七四　小寒二八五　大寒三九六
	#立春八五二　雨水九六三　惊蛰一七四
	#春分三九六　清明四一七　谷雨五二八	
	#立夏四一七　小满五二八　芒种六三九

	#上　　　　　中　　　　　下
	#夏至九三六　小暑八二五　大暑七一四
	#立秋二五八　处暑一四七　白露九三六
	#秋分七一四　寒露六九三　霜降五八二
	#立冬六九三　小雪五八一　大雪四七一

	v["三元"] = [ [1,7,4] , [2,8,5] , [3,9,6],
			     [8,5,2] , [9,6,3] , [1,7,4],
			     [3,9,6] , [4,1,7] , [5,2,8],
			     [4,1,7] , [5,2,8] , [6,3,9],
			     [9,3,6] , [8,2,5] , [7,1,4],
			     [2,5,8] , [1,4,7] , [9,3,6],
			     [7,1,4] , [6,9,3] , [5,8,2],
			     [6,9,3] , [5,8,1] , [4,7,1]
			    ]


	v["宫"] = [ "", "坎","坤","震", "巽","中","乾","兑","艮","离" ] 		    

	

	nongli = CDate.new()

	subject_date 			= ARGV[0]? DateTime.parse( ARGV[0]  ) : DateTime.now()
	sizhu  					= nongli.bazi( subject_date  )
	subject_jieqi 			= nongli.to_ccal2(subject_date)[:term]
	subject_jieqi_index		= v["节气"].index(subject_jieqi)

	sanyuan 	= v["三元"][subject_jieqi_index]
	yangyindun 	= subject_jieqi_index / 12

	nth_day = 0
	(1..30).each { |i_d|
		jieqi = nongli.to_ccal2(subject_date - i_d )[:term]
		if jieqi != subject_jieqi
			break
		end
		nth_day += 1
	}

	sanyuan_index = nth_day / 5
	ju = sanyuan[sanyuan_index]




	# 2. 地盘

	dipan = []
	(0...9).each { |i|
		dipan[ (((ju - 1) + i ) % 9 ) + 1 ] = v["三奇六仪"][i]
	}

	# 3. # 2. 天盘 口诀： 符首定在地盘时干上。
	tianpan = [0,0,0,0,0,0,0,0,0,0]
	fushou  = ((( (sizhu[3][0] - sizhu[3][1]) % 12 ) / 2 ) + 4 ) % 10



	(1..9).each { |i|
		if dipan[i] == sizhu[3][0]
			tianpan[i] = fushou
		end	
	}








	# Print bazi first
	(0...4).each { |i|
		print "#{v["天干"][sizhu[i][0]]}#{v["地支"][sizhu[i][1]]}  "
	}
	printf "\n"
	printf "符首 %s\n" , v["天干"][fushou]
	puts "\n\n"


	# Print 9 gong

	printf "          %s|            %s|          %s\n" , v["天干"][tianpan[4]], v["天干"][tianpan[9]], v["天干"][tianpan[2]] 
	printf "          %s|            %s|          %s\n" , v["天干"][dipan[4]]  , v["天干"][dipan[9]]  , v["天干"][dipan[2]] 
	printf "            |              |            \n"
	printf "            |              |            \n"
	printf "            |              |            \n"
	printf "%s          |%s            |%s          \n" , v["宫"][4],v["宫"][9],v["宫"][2]
	printf "----------------------------------------\n"
	printf "          %s|            %s|          %s\n" , v["天干"][tianpan[3]], v["天干"][tianpan[5]], v["天干"][tianpan[7]] 
	printf "          %s|            %s|          %s\n" , v["天干"][dipan[3]]  , v["天干"][dipan[5]]  , v["天干"][dipan[7]] 
	printf "            |              |            \n"
	printf "            |              |            \n"
	printf "            |              |            \n"
	printf "%s          |%s            |%s          \n" , v["宫"][3],v["宫"][5],v["宫"][7]
	printf "----------------------------------------\n"
	printf "          %s|            %s|          %s\n" , v["天干"][tianpan[8]], v["天干"][tianpan[1]], v["天干"][tianpan[6]] 
	printf "          %s|            %s|          %s\n" , v["天干"][dipan[8]]  , v["天干"][dipan[1]]  , v["天干"][dipan[6]] 
	printf "            |              |            \n"
	printf "            |              |            \n"
	printf "            |              |            \n"
	printf "%s          |%s            |%s          \n" , v["宫"][8],v["宫"][1],v["宫"][6]
	

end

main









