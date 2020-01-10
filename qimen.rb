#encoding: utf-8

# Work in Progress...

require_relative 'cdate'
require_relative 'goleph.rb'
require 'time'

def main()

	v = {}

	#              0     1     2     3     4     5     6    7    8     9     10    11
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



	# 阳遁
	#上　　　　　中　　　　　下
	#冬至一七四　小寒二八五　大寒三九六
	#立春八五二　雨水九六三　惊蛰一七四
	#春分三九六　清明四一七　谷雨五二八	
	#立夏四一七　小满五二八　芒种六三九

	# 阴遁
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

	# 4 9 2
	# 3 5 7
	# 8 1 6
	#			    0, 1, 2, 3, 4, 5, 6, 7, 8, 9
	v["宫顺时"] =  [ 0, 8, 7, 4, 9, 2, 1, 6, 3, 2 ]
	v["宫逆时"] =  [ 0, 6, 9, 8, 3, 2, 7, 2, 1, 4 ]


	#			        0,     1,     2,      3,       4,   5,     6,      7,      8,      9
	v["九星"]     =  [ "" ,"天蓬", "天芮", "天冲",   "天辅", "", "天心" ,"天柱", "天任" , "天英" ]
	v["八神"]     =  [ "直符", "腾蛇", "太阴" ,"六合", "白虎" ,"玄武" ,"九地" ,"九天" ]
	v["八门"]     =  [ "" ,   "休门",  "死门" ,   "伤门"  ,  "杜门" ,"",  "开门",    "惊门",  "生门" , "景门"]

					#  "子"   "戌" "申" "午" "辰" "寅"
	v["旬支"]	  =  [  0,    10,   8 ,  6 ,  4,   2 ]

	                 	#申子辰     寅午戌     亥卯未      巳酉丑
	v["三合"]     		= [ [8,0,4] , [2,6,10] , [11,3,7] , [5,9,1] ]
	v["三合马星"]     	= [ 8,6,2,4, 8,6,2,4, 8,6,2,4 ]

	#甲子旬中戌亥空；甲寅旬中子丑空；甲辰旬中寅卯空；
 	#甲午旬中辰巳空；甲申旬中午未空；甲戌旬中申酉空
	v["空亡"] 			= [ [6], [7,2] , [9,2] , [4] , [3,8] , [1,8] ]	

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
		if yangyindun == 0
			dipan[ (((ju - 1) + i ) % 9 ) + 1 ] = v["三奇六仪"][i]
		else
			dipan[ (((ju - 1) - i ) % 9 ) + 1 ] = v["三奇六仪"][i]
		end
	}

	
	# 3. # 2. 天盘 口诀： 符首定在地盘时干上。
	tianpan = [0]
	fushou  = ((( (sizhu[3][0] - sizhu[3][1]) % 12 ) / 2 ) + 4 ) % 10
	
	d_start = t_start = ori_d_start = 0

	(1..9).each { |i|
		# i is gong index
		
		if dipan[i] == fushou
			d_start = i
			ori_d_start = i
			d_start = 2 if d_start == 5
			t_start = i if sizhu[3][0] == 0
		end	
		if dipan[i] == sizhu[3][0]
			t_start = i
			t_start = 2 if t_start == 5
			tianpan[i] = fushou
		end
	}




	t_i = v["宫顺时"][t_start]
	d_i = v["宫顺时"][d_start]
	
	(0...8).each { |i|
		tianpan[ t_i ] = dipan[d_i]
		d_i = v["宫顺时"][d_i]
		t_i = v["宫顺时"][t_i]
	}


	#4. 安九星： 值符随时干走

	jiuxing = [0]*10
	t_start = 2 if t_start == 5
	jiuxing[t_start] = d_start



	
	bashen  = [0]*10
	bashen[t_start] =  0


	# 5. 八门根据 值使 

	# 旬支
	xunzhi   		=  v["旬支"][ ((sizhu[3][0] - sizhu[3][1]) % 12 )  / 2  ]

	steps_to_take 	=  ( sizhu[3][1] - xunzhi ) % 12  

	# 值使 走几步 
	if yangyindun == 0 
		# 旬支 到 时支 几步 ？
		#steps_to_take 	=  ( sizhu[3][1] - xunzhi ) % 12  
		t2_start = (( ( ori_d_start - 1 ) + steps_to_take ) % 9 ) + 1
	else 
		#steps_to_take 	=  ( xunzhi - sizhu[3][1]  ) % 12  
		t2_start = (( ( ori_d_start - 1 ) - steps_to_take ) % 9 ) + 1
	end
	t2_start = 2 if t2_start ==5 	


	bamen = [0] * 10
	bamen[t2_start] = d_start

	t_i 	= v["宫顺时"][t_start]
	t_i_rev = v["宫逆时"][t_start]
	t2_i    = v["宫顺时"][t2_start]

	xing_i = d_start


	(1..7).each { |i|
		xing_i = v["宫顺时"][xing_i]
		jiuxing[t_i] = xing_i
		bamen[t2_i]  = xing_i
		if yangyindun == 0
			bashen[t_i]  = i
		else 
			bashen[t_i_rev] = i
		end
		t_i 	= v["宫顺时"][t_i]
		t_i_rev = v["宫逆时"][t_i_rev]
		t2_i 	= v["宫顺时"][t2_i]		
	}

	ma_xing_pos = v["三合马星"][sizhu[3][1]]
	ma_xing 	= ["  "] * 9
	ma_xing[ ma_xing_pos ] = "马"

	jiaxun = (( (sizhu[3][0] - sizhu[3][1]) % 12 ) / 2 )  % 10
	kong_wang   = ["    "] * 9 
	v["空亡"][jiaxun].each { |gong_index|
		kong_wang[gong_index] = "空亡"
	}
	

	# Printing...

	# Print Bazi
	(0...4).each { |i|
		print "#{v["天干"][sizhu[i][0]]}#{v["地支"][sizhu[i][1]]} "
	}

	# Print relevant infos
	printf "\n"
	printf "%s%s局 \n" , ["阳","阴"][yangyindun] , ju
	printf "节气: %s\n", subject_jieqi
	printf "旬首: 甲%s ,  符首: %s , 值符: %s, 值使: %s\n" , v["地支"][xunzhi] , v["天干"][fushou]  , v["九星"][d_start],  v["八门"][d_start]
			
	puts "\n\n"


	# Print 9 gong

	printf "          %s|            %s|          %s\n" , v["天干"][tianpan[4]], v["天干"][tianpan[9]], v["天干"][tianpan[2]] 
	printf "          %s|            %s|          %s\n" , v["天干"][dipan[4]]  , v["天干"][dipan[9]]  , v["天干"][dipan[2]] 
	printf "%s        |%s          |%s        \n" 		, v["八神"][bashen[4]], v["八神"][bashen[9]], v["八神"][bashen[2]]
	
	printf "%s        |%s          |%s        \n" 		, v["九星"][jiuxing[4]], v["九星"][jiuxing[9]], v["九星"][jiuxing[2]]
	printf "%s        |%s          |%s        \n" 		, v["八门"][bamen[4]], v["八门"][bamen[9]], v["八门"][bamen[2]]
	printf "%s          |              |%s          \n" , ma_xing[4],ma_xing[2]
	printf "%s        |%s              |%s        \n" 		, kong_wang[4], kong_wang[9],kong_wang[2]
	printf "            |              |            \n"
	printf "%s          |%s            |%s          \n" , v["宫"][4],v["宫"][9],v["宫"][2]
	

	printf "----------------------------------------\n"
	printf "          %s|              |          %s\n" , v["天干"][tianpan[3]],   v["天干"][tianpan[7]] 
	printf "          %s|            %s|          %s\n" , v["天干"][dipan[3]]  , v["天干"][dipan[5]]  , v["天干"][dipan[7]] 
	printf "%s        |              |%s        \n" 		, v["八神"][bashen[3]],   v["八神"][bashen[7]]
	
	printf "%s        |              |%s        \n" 		, v["九星"][jiuxing[3]],   v["九星"][jiuxing[7]]
	printf "%s        |              |%s        \n" 		, v["八门"][bamen[3]],   v["八门"][bamen[7]]
	printf "%s        |              |%s        \n" 		, kong_wang[3], kong_wang[7]
	printf "            |              |            \n"
	printf "            |              |            \n"
	printf "            |              |            \n"
	printf "%s          |%s            |%s          \n" , v["宫"][3],v["宫"][5],v["宫"][7]
	

	printf "----------------------------------------\n"
	
	printf "          %s|            %s|          %s\n" , v["天干"][tianpan[8]], v["天干"][tianpan[1]], v["天干"][tianpan[6]] 
	printf "          %s|            %s|          %s\n" , v["天干"][dipan[8]]  , v["天干"][dipan[1]]  , v["天干"][dipan[6]] 
	printf "%s        |%s          |%s        \n" 		, v["八神"][bashen[8]], v["八神"][bashen[1]],   v["八神"][bashen[6]]
	
	printf "%s        |%s          |%s        \n" 		, v["九星"][jiuxing[8]], v["九星"][jiuxing[1]], v["九星"][jiuxing[6]]
	printf "%s        |%s          |%s        \n" 		, v["八门"][bamen[8]],  v["八门"][bamen[1]],    v["八门"][bamen[6]]
	printf "%s          |              |%s          \n" , ma_xing[8],ma_xing[6]
	printf "%s        |%s          |%s        \n" 		, kong_wang[8], kong_wang[1],kong_wang[6]
	printf "            |              |            \n"
	printf "%s          |%s            |%s          \n" , v["宫"][8],v["宫"][1],v["宫"][6]
	

end

main









