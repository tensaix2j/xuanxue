#encoding: utf-8



require_relative 'cdate'
require_relative 'goleph.rb'
require 'time'

def main()

	v = {}

	#              0     1     2     3     4     5     6    7    8     9
	v["天干"] = [ "甲", "乙", "丙", "丁", "戊", "己", "庚", "辛", "壬", "癸" ]
	v["地支"] = [ "子", "丑", "寅", "卯", "辰", "巳", "午", "未", "申", "酉", "戌", "亥"]
	v["贵神"] = [ "贵", "腾", "朱", "六", "勾", "青", "空", "白", "常", "玄", "阴", "后"] 
	v["十神"] = [ "比", "劫", "食", "伤", "才", "财", "杀", "官" , "印", "枭" ] 
	

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


	if ARGV.length < 1
		puts "Usage: ruby bazi.rb <datetime> [<m|f (default:m)>]"
		return
	end

	nongli = CDate.new()

	birthdate 	= DateTime.parse( ARGV[0]  )
	sizhu  		= nongli.bazi( birthdate  )
	gender 		= ARGV[1] ? ARGV[1] == "f" ? -1 : 1 : 1 
		

	rizhu = sizhu[2][0]

	# 顺推或逆推根据 年干 * 性别 , shun = 1 , ni = -1
	shun_or_ni = gender *  v["干阴阳"][ sizhu[0][0] ]
	
	# 计算几时起运, 不能算中气
	birthdate_jieqi = nongli.to_ccal2(birthdate)[:term]
	birthdate_jieqi_index = (v["节气"].index(birthdate_jieqi) + 1) / 2 
	
	
	jieqi = birthdate_jieqi

	d_to_jieqi_change = 0
	h_to_jieqi_change = 0

	(1..30).each { |i_d|
		jieqi = nongli.to_ccal2(birthdate + i_d * shun_or_ni )[:term]
		jieqi_index = ( v["节气"].index(jieqi) + 1 ) / 2
		d_to_jieqi_change += shun_or_ni
		if jieqi_index != birthdate_jieqi_index
			break
		end
	}

	(1..24).each { |i_h|
		jieqi = nongli.to_ccal2( (birthdate + d_to_jieqi_change - shun_or_ni ) + i_h / 24.0 * shun_or_ni )[:term]
		jieqi_index = ( v["节气"].index(jieqi) + 1 ) / 2
		h_to_jieqi_change += shun_or_ni
		if jieqi_index != birthdate_jieqi_index
			break
		end
	}	

	
	#qiyundate = birthdate >> ( d_to_jieqi_change / 3 ) * 12
	#qiyundate = qiyundate >> ( d_to_jieqi_change % 3 ) * 4
	qiyundate = birthdate + (( (d_to_jieqi_change.abs - 1 ) * 24 ) + h_to_jieqi_change.abs  + 11 ) * 5 

	
	
	
	qiyunyear = qiyundate.year
	if qiyundate.month >= 7
		qiyunyear += 1
	end

	current_date  = DateTime.now()
	current_sizhu = nongli.bazi( current_date  )
	

	puts "生日: #{ birthdate }"
	puts "生日节气: #{ birthdate_jieqi }"
	puts "起运: #{ qiyundate }"
	puts "当下: #{ current_date }"
	


	yun_cycle = ( current_date.year - qiyunyear ) / 10 + 1
	sizhu[4] = [] 
	sizhu[4][0] = ( sizhu[1][0] + yun_cycle * shun_or_ni ) % 10
	sizhu[4][1] = ( sizhu[1][1] + yun_cycle * shun_or_ni ) % 12
		
	(0...4).each { |i|
		sizhu[i+5] = current_sizhu[i]
	}

	# 流分
	sizhu[9] = []
	sizhu[9][1] = ( (current_date.hour + 1 ) % 2 ) * 6 + ( current_date.minute / 10 )
	sizhu[9][0] = ( v["推干法"][sizhu[8][0]] + sizhu[9][1] ) % 10
	
	# 流秒 
	sizhu[10] = []
	sizhu[10][1] =  (( current_date.minute % 10 ) * 60 + current_date.second )/ 50
	sizhu[10][0] = ( v["推干法"][sizhu[9][0]] + sizhu[10][1] ) % 10
		

	shishen = []

	(0...11).each { |i|
			
		gan_element = v["干五行"][ sizhu[i][0] ]
		zhi_element = v["支五行"][ sizhu[i][1] ]

		shishen[i] = [] if shishen[i] == nil

		gan_shishen_yinyang    = ( gan_element - rizhu ) % 2
		gan_dist_from_rizhu = ( gan_element - rizhu ) % 10

		shishen[i][0] =    ((( gan_dist_from_rizhu + gan_shishen_yinyang ) /2 ) % 5 ) * 2 + gan_shishen_yinyang 
		

		zhi_shishen_yinyang    = ( zhi_element - rizhu ) % 2
		zhi_dist_from_rizhu = ( zhi_element - rizhu ) % 10

		shishen[i][1] =   ((( zhi_dist_from_rizhu + zhi_shishen_yinyang ) /2 ) % 5 ) * 2 + zhi_shishen_yinyang
		
	}








	printf   "\n\n"
	printf   "本命            | 大  流  流  流  | 流  流  流\n" 
	printf	 "年  月  日  时  | 运  年  月  日  | 时  分  秒\n"
	printf   "--------------------------------------------------\n"

	printf 	 "%s  %s  %s  %s  | %s  %s  %s  %s  | %s  %s  %s\n" , 
								  v["十神"][shishen[0][0]],
							      v["十神"][shishen[1][0]],
							      "日",
							      v["十神"][shishen[3][0]],
								  v["十神"][shishen[4][0]],
							      v["十神"][shishen[5][0]],
							      v["十神"][shishen[6][0]],
							      v["十神"][shishen[7][0]],
							      v["十神"][shishen[8][0]],
							      v["十神"][shishen[9][0]],
							      v["十神"][shishen[10][0]]
							      
							          	


	printf 	 "%s  %s  %s  %s  | %s  %s  %s  %s  | %s  %s  %s\n" ,
								  v["天干"][sizhu[0][0]],
							      v["天干"][sizhu[1][0]],
							      v["天干"][sizhu[2][0]],
							      v["天干"][sizhu[3][0]],
							      v["天干"][sizhu[4][0]],
							      v["天干"][sizhu[5][0]],
							      v["天干"][sizhu[6][0]],
							      v["天干"][sizhu[7][0]],
							      v["天干"][sizhu[8][0]],
							      v["天干"][sizhu[9][0]],
							      v["天干"][sizhu[10][0]]
							      
							      

	printf 	 "%s  %s  %s  %s  | %s  %s  %s  %s  | %s  %s  %s\n" , 
								  v["地支"][sizhu[0][1]],
							      v["地支"][sizhu[1][1]],
							      v["地支"][sizhu[2][1]],
							      v["地支"][sizhu[3][1]],
							      v["地支"][sizhu[4][1]],
							      v["地支"][sizhu[5][1]],
							      v["地支"][sizhu[6][1]],
							      v["地支"][sizhu[7][1]],
							      v["地支"][sizhu[8][1]],
							      v["地支"][sizhu[9][1]],
							      v["地支"][sizhu[10][1]]
							      

	printf 	 "%s  %s  %s  %s  | %s  %s  %s  %s  | %s  %s  %s\n" , 
								  v["十神"][shishen[0][1]],
							      v["十神"][shishen[1][1]],
							      v["十神"][shishen[2][1]],
							      v["十神"][shishen[3][1]],
								  v["十神"][shishen[4][1]],
							      v["十神"][shishen[5][1]],
							      v["十神"][shishen[6][1]],
							      v["十神"][shishen[7][1]],
							      v["十神"][shishen[8][1]],
							      v["十神"][shishen[9][1]],
							      v["十神"][shishen[10][1]]
							       
							     
							      						      
	
	puts "------------------------------------------"				      
	printf   "\n\n大运\n"

	n = 8
	(0...n).each { |i|
		printf "%s  ", ( qiyunyear + i * 10 )
	}
	printf "\n"
	(1..n).each { |i|
		printf "%s    ",v["天干"][  ( sizhu[1][0] + i * shun_or_ni) % 10 ]
	}
	printf "\n"
	(1..n).each { |i|
		printf "%s    ",v["地支"][  ( sizhu[1][1] + i * shun_or_ni ) % 12 ]
	}
	printf "\n\n"
	
end

main









