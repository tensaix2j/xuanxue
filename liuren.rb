#encoding: utf-8



require_relative 'cdate'
require_relative 'goleph.rb'
require 'time'


def main(  )

	v = {}
	v["天干"] = [ "甲", "乙", "丙", "丁", "戊", "己", "庚", "辛", "壬", "癸" ]
	v["地支"] = [ "子", "丑", "寅", "卯", "辰", "巳", "午", "未", "申", "酉", "戌", "亥"]
	v["贵神"] = [ "贵", "腾", "朱", "六", "勾", "青", "空", "白", "常", "玄", "阴", "后"] 

	o = {}
	o["月将"] = [  1, 0 , 11, 10, 9 , 8 ,7 ,6, 5, 4, 3, 2  ]
	o["贵神昼"] 	= [  1,  0, 11,11, 1,0,   1,6,5,5   ]
	o["贵神夜"] 	= [  7,  8,  9, 9, 7,8,   7,2,3,3   ]
	o["人元"]    = [ 0, 2,4 ,6 ,8 , 0,2 ,4 ,6 ,8 ]

	if ( ARGV.length < 2 ) 
		puts "Usage <date time now> <a random number>"
		return 
	end


	nongli = CDate.new()


	#起四柱
	sizhu = nongli.bazi( DateTime.parse( ARGV[0] ) )
	(0...4).each { |i|
		puts "#{v["天干"][sizhu[i][0]]}#{v["地支"][sizhu[i][1]]}"
	}

	#起地分
	difen = ARGV[1].to_i
	print "地分:",v["地支"][difen],"\n"


	#起月将
	yuejiang_o 	=  o["月将"][ sizhu[1][1]  ] 
	print "月将:",v["地支"][ yuejiang_o   ],"\n"

	#起将神
	jiangshen = ( difen + yuejiang_o - sizhu[3][1] ) % 12
	print "将神:",v["地支"][ jiangshen   ],"\n"


	#起贵神
	guishen_o 	= o["贵神昼"][ sizhu[2][0] ]
	guishen 	= (difen - guishen_o) % 12
	print "贵神:",v["贵神"][ guishen ],"\n"


	#起人元
	renyuan = o["人元"][ sizhu[2][0] ]
	print "人元:",v["天干"][ (difen + renyuan) % 10 ],"\n"

	#将干
	print "将干:",v["天干"][ (jiangshen + renyuan) % 10 ],"\n"


	#神干
	print "神干:",v["天干"][ (difen + renyuan) % 10 ],"\n"

end

main 








