


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
	v["长生"] 	= 	[ "长生" ,"沐浴" ,"冠带", "临官", "帝旺", "衰", "病", "死", "墓", "绝" ,"胎" ,"养"]

	o = {}
	o["五虎遁"] = [ 2,4,6,8,0,2,4,6,8,0]
	o["五鼠遁"] = [ 0,2,4,6,8,0,2,4,6,8]


	o["五行局"]	= { 
					[ 0,0 ] =>2, [ 0, 1] =>2, [ 0,6 ] =>2, [ 0, 7] =>2, 
					[ 1,0 ] =>2, [ 1, 1] =>2, [ 1,6 ] =>2, [ 1, 7] =>2, 
					[ 0,2 ] =>0, [ 0, 3] =>0, [ 0,8 ] =>0, [ 0, 9] =>0, 
					[ 1,2 ] =>0, [ 1, 3] =>0, [ 1,8 ] =>0, [ 1, 9] =>0, 
					[ 0,4  ]=>4, [ 0, 5 ]=>4, [ 0,10 ]=>4, [ 0, 11]=>4, 
					[ 1,4  ]=>4, [ 1, 5 ]=>4, [ 1,10 ]=>4, [ 1, 11]=>4, 
										
					[ 2,0 ] =>0, [ 2, 1] =>0, [ 2,6 ] =>0, [ 2, 7] =>0, 
					[ 3,0 ] =>0, [ 3, 1] =>0, [ 3,6 ] =>0, [ 3, 7] =>0, 
					[ 2,2 ] =>4, [ 2, 3] =>4, [ 2,8 ] =>4, [ 2, 9] =>4, 
					[ 3,2 ] =>4, [ 3, 3] =>4, [ 3,8 ] =>4, [ 3, 9] =>4, 
					[ 2,4  ]=>3, [ 2, 5 ]=>3, [ 2,10 ]=>3, [ 2, 11]=>3, 
					[ 3,4  ]=>3, [ 3, 5 ]=>3, [ 3,10 ]=>3, [ 3, 11]=>3, 
					
					[ 4,0 ] =>4, [ 4, 1] =>4, [ 4,6 ] =>4, [ 4, 7] =>4, 
					[ 5,0 ] =>4, [ 5, 1] =>4, [ 5,6 ] =>4, [ 5, 7] =>4, 
					[ 4,2 ] =>3, [ 4, 3] =>3, [ 4,8 ] =>3, [ 4, 9] =>3, 
					[ 5,2 ] =>3, [ 5, 3] =>3, [ 5,8 ] =>3, [ 5, 9] =>3, 
					[ 4,4  ]=>1, [ 4, 5 ]=>1, [ 4,10 ]=>1, [ 4, 11]=>1, 
					[ 5,4  ]=>1, [ 5, 5 ]=>1, [ 5,10 ]=>1, [ 5, 11]=>1, 

					[ 6,0 ] =>3, [ 6, 1] =>3, [ 6,6 ] =>3, [ 6, 7] =>3, 
					[ 7,0 ] =>3, [ 7, 1] =>3, [ 7,6 ] =>3, [ 7, 7] =>3, 
					[ 6,2 ] =>1, [ 6, 3] =>1, [ 6,8 ] =>1, [ 6, 9] =>1, 
					[ 7,2 ] =>1, [ 7, 3] =>1, [ 7,8 ] =>1, [ 7, 9] =>1, 
					[ 6,4  ]=>2, [ 6, 5 ]=>2, [ 6,10 ]=>2, [ 6, 11]=>2, 
					[ 7,4  ]=>2, [ 7, 5 ]=>2, [ 7,10 ]=>2, [ 7, 11]=>2, 
					
					[ 8,0 ] =>1, [ 8, 1] =>1, [ 8,6 ] =>1, [ 8, 7] =>1, 
					[ 9,0 ] =>1, [ 9, 1] =>1, [ 9,6 ] =>1, [ 9, 7] =>1, 
					[ 8,2 ] =>2, [ 8, 3] =>2, [ 8,8 ] =>2, [ 8, 9] =>2, 
					[ 9,2 ] =>2, [ 9, 3] =>2, [ 9,8 ] =>2, [ 9, 9] =>2, 
					[ 8,4  ]=>0, [ 8, 5 ]=>0, [ 8,10 ]=>0, [ 8, 11]=>0, 
					[ 9,4  ]=>0, [ 9, 5 ]=>0, [ 9,10 ]=>0, [ 9, 11]=>0, 
					
				}


	o["长生"] = [ 8, 11, 6, 2, 2 ]
	o["天府"] = [ 4, 3, 2, 1, 0, 11, 10, 9 , 8 ,7 , 6, 5 ]

	o["天魁"] 	= [  1,  0, 11,11, 1,0,   1,6,5,5   ]
	o["天钺"] 	= [  7,  8,  9, 9, 7,8,   7,2,3,3   ]
	o["禄存"] 	= [  2, 3,  5, 6 ,5,   6, 8,9, 11, 0]   

	o["火星"]	= [ 2,  3,1, 9,  2, 3,1, 9,  2, 3,1, 9  ]
	o["铃星"] 	= [ 10,10,3,10, 10,10,3,10, 10,10,3,10  ]

	o["天马"] 	= [ 2,11,8,5, 2,11,8,5, 2,11,8,5  ]


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

	changshen_off = o["长生"][wuxingju]
	puts "\n\n"
	

	# 14 主星
	

	# 紫薇 ,天机, 太阳, 武曲, 天同. 廉贞
	x = 0
	(0...6).each { |i|
		if ( nongdate[:iday] + 1 + i ) % ( wuxingju + 2 ) == 0
			x = i
			break
		end
	}
	y = (nongdate[:iday] + 1 + x) / ( wuxingju + 2 )
	ziwei = (y + 1 + x) % 12

	
	tianji 		= (ziwei - 1) % 12
	taiyang 	= (ziwei - 3) % 12
	wuqu 		= (ziwei - 4) % 12
	tiantong 	= (ziwei - 5) % 12
	lianzhen	= (ziwei - 8) % 12

	# 天府，太阴，贪狼， 巨门，天相，天梁， 七杀， 破军
	tianfu 		= o["天府"][ziwei]
	taiyin		= (tianfu + 1 ) % 12
	tanlang 	= (tianfu + 2 ) % 12
	jumen		= (tianfu + 3 ) % 12
	tianxiang 	= (tianfu + 4 ) % 12
	tianliang	= (tianfu + 5 ) % 12
	qisha		= (tianfu + 6 ) % 12
	pojun		= (tianfu + 10 ) % 12





	# 14 吉凶星

	# 7 吉星
	# 左辅， 右弼， 文曲， 文昌， 天魁， 天月， 禄存
	zuofu = (4 + nongdate[:imonth]) % 12
	youbi = (10 - nongdate[:imonth]) % 12
	wenqu = (4 + sizhu[3][1] ) % 12
	wenchang = (10 - sizhu[3][1]) % 12
	tiankui = o["天魁"][sizhu[0][0]] 
	tianyue = o["天钺"][sizhu[0][0]]
	lucun = o["禄存"][sizhu[0][0]]



	# 7 凶星
	# 擎羊，陀螺， 火星，铃星 ,地空，地劫, 七杀
	qingyang = (lucun + 1) % 12
	tuoluo   = (lucun - 1) % 12
	huoxing  = (o["火星"][sizhu[0][1]] + sizhu[3][1]) % 12
	lingxing  = (o["铃星"][sizhu[0][1]] + sizhu[3][1]) % 12
	dikong  = (11 - sizhu[3][1]) % 12
	dijie   = (11 + sizhu[3][1]) % 12


	# 杂耀星
	# 天马， 红鸳， 天喜 ， 孤辰 ，寡宿, 天刑， 天姚， 天德， 年解
	tianma  = o["天马"][sizhu[0][1]]
	hongyuan = (3 - sizhu[0][1]) % 12	
	tianxi  = (hongyuan + 6) % 12

	trio_grp = ((sizhu[0][1] + 1) % 12) / 3
	trio_grp_next = [2,5,8,11]
	trio_grp_prev = [10,7,4,1]
	guchen 	= trio_grp_next[trio_grp]
	guasu 	= trio_grp_prev[trio_grp]

	tianxing = (9 + nongdate[:imonth])  % 12
	tianyao  = (1 + nongdate[:imonth])  % 
	tiande  = (9 + sizhu[0][1]) % 12
	nianjie = (10 - sizhu[0][1]) % 12


	(0...12).each do |i|

		effective_monthoff = monthoff[ i < 2 ? 1 : 0 ]
		gan = (effective_monthoff + i - 2) % 10

		print v["天干"][gan],v["地支"][i]," "
		print v["十二宫"][ (12 - (i - minggong )) % 12]

		print " ",v["长生"][ (i - changshen_off) % 12 ]," "

		print "(身)" if i == shengong 
		print "(紫薇星)" if i == ziwei 

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
				
		print "(左辅)" if i == zuofu
		print "(右弼)" if i == youbi
		print "(文曲)" if i == wenqu
		print "(文昌)" if i == wenchang
		print "(天魁)" if i == tiankui
		print "(天钺)" if i == tianyue
		print "(禄存)" if i == lucun

		print "(擎羊)" if i == qingyang
		print "(陀螺)" if i == tuoluo
		print "(火星)" if i == huoxing
		print "(铃星)" if i == lingxing
		print "(地空)" if i == dikong
		print "(地劫)" if i == dijie
		
		print "(天马)" if i == tianma
		print "(红鸳)" if i == hongyuan
		print "(天喜)" if i == tianxi
		print "(孤辰)" if i == guchen
		print "(寡宿)" if i == guasu
		print "(天刑)" if i == tianxing
		print "(天姚)" if i == tianyao
		print "(天德)" if i == tiande
		print "(年解)" if i == nianjie
												
							
		puts ""
	end



	




end

main
