

require 'cdate'
require 'goleph.rb'
require 'time'




def main()

	v = {}
	v["天干"] 	= 	[ "甲", "乙", "丙", "丁", "戊", "己", "庚", "辛", "壬", "癸" ]
	v["地支"] 	= 	[ "子", "丑", "寅", "卯", "辰", "巳", "午", "未", "申", "酉", "戌", "亥"]
	v["月"] 		= 	['十一','十二','正','二','三','四','五','六','七','八','九','十']

	v["十二宫"]  = 	[ "命宫", "兄弟", "夫妻", "子女", "财帛", "疾厄", "迁移", "仆役", "官禄", "田宅", "福德", "父母"]
	v["五行"] 	= 	[ "金","木","水","火","土"]
	v["五行局"] 	=	[ "水二","木三","金四","土五","火六" ]

	o = {}
	o["五虎遁"] = [ 2,4,6,8,0,2,4,6,8,0]
	o["五鼠遁"] = [ 0,2,4,6,8,0,2,4,6,8]


	o["五行局"]	= { 
					[ 0,0 ]=>2, [ 1, 1]=>2, #甲子乙丑海中金
					[ 2,2 ]=>4, [ 3, 3]=>4,
					[ 4,4 ]=>0 ,[ 5, 5]=>0,
					[ 6,6 ]=>3 ,[ 7, 7]=>3,
					[ 8,8 ]=>1, [ 9, 9]=>1,
					[ 0,10]=>4, [ 1,11]=>4,
					[ 2,0 ]=>0 ,[ 3, 1]=>0 
				}


	o["长生"] = [ 8, 11, 6, 2, 2 ]
	o["天府"] = [ 4, 3, 2, 1, 0, 11, 10, 9 , 8 ,7 , 6, 5 ]


	if ARGV.length < 1
		puts "Usage: ruby ziwei.rb <datetime>"
		return
	end


	nongli = CDate.new()
	dt = DateTime.parse( ARGV[0] )
	sizhu = nongli.bazi( dt )
	nongdate = nongli.to_ccal( dt );

	#农历
	puts "#{ nongdate[:cmonth] }月 #{ nongdate[:cday]}"


	#八字
	(0...4).each { |i|
		print "#{v["天干"][sizhu[i][0]]}#{v["地支"][sizhu[i][1]]} "
	}
	puts "\n"


	#命宫，身宫
	minggong = (nongdate[:imonth] + 2 - sizhu[3][1])	% 12
	shengong = (nongdate[:imonth] + 2 + sizhu[3][1])  	% 12
			



	#五局
	monthoff = []
	monthoff[0] = o["五虎遁"][  sizhu[0][0] ]
	monthoff[1] = o["五虎遁"][  (sizhu[0][0] + 1) % 10 ]

	effective_monthoff = monthoff[ minggong < 2 ? 1 : 0 ]


	wuxingju = o["五行局"][[ (effective_monthoff + minggong - 2) % 10 ,minggong] ]
	
	print v["五行局"][ wuxingju],"局"
	puts ""
	print v["地支"][ o["长生"][wuxingju] ]," 长生"	
	puts "\n\n"
	

	#紫薇星
	x = 0
	(0...6).each { |i|
		if ( nongdate[:iday] + 1 + i ) % ( wuxingju + 2 ) == 0
			x = i
			break
		end
	}
	y = (nongdate[:iday] + 1 + x) / ( wuxingju + 2 )
	ziweixing = (y + 1 + x) % 12

	#天机，太阳，武曲，天同，廉贞
	tianji 		= (ziweixing - 1) % 12
	taiyang 	= (ziweixing - 3) % 12
	wuqu 		= (ziweixing - 4) % 12
	tiantong 	= (ziweixing - 5) % 12
	lianzhen	= (ziweixing - 8) % 12

	#天府，太阴，贪狼， 巨门，天相，天梁， 七杀， 破军
	tianfu 		= o["天府"][ziweixing]
	taiyin		= (tianfu + 1 ) % 12
	tanlang 	= (tianfu + 2 ) % 12
	jumen		= (tianfu + 3 ) % 12
	tianxiang 	= (tianfu + 4 ) % 12
	tianliang	= (tianfu + 5 ) % 12
	qisha		= (tianfu + 6 ) % 12
	pojun		= (tianfu + 10 ) % 12



	(0...12).each do |i|

		effective_monthoff = monthoff[ i < 2 ? 1 : 0 ]

		print v["天干"][(effective_monthoff + i - 2) % 10],v["地支"][i]," "
		print v["十二宫"][ (12 - (i - minggong )) % 12]
		print "(身)" if i == shengong 
		print "(紫薇星)" if i == ziweixing 

		print "(天机)" if i == tianji 
		print "(太阳)" if i == taiyang 
		print "(武曲)" if i == wuqu 
		print "(天同)" if i == tiantong 
		print "(廉贞)" if i == lianzhen 
		
		print "(天府)" if i == tianfu 
		print "(太阴)" if i == taiyin 
		print "(贪狼)" if i == tanlang 
		print "(巨门)" if i == jumen 
		print "(天相)" if i == tianxiang 
		print "(天梁)" if i == tianliang
		print "(七杀)" if i == qisha
		print "(破军)" if i == pojun
				
			
		puts ""
	end



	




end

main
