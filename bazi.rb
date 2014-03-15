#encoding: utf-8



require_relative 'cdate'
require_relative 'goleph.rb'
require 'time'

def main()

	v = {}
	v["天干"] = [ "甲", "乙", "丙", "丁", "戊", "己", "庚", "辛", "壬", "癸" ]
	v["地支"] = [ "子", "丑", "寅", "卯", "辰", "巳", "午", "未", "申", "酉", "戌", "亥"]
	v["贵神"] = [ "贵", "腾", "朱", "六", "勾", "青", "空", "白", "常", "玄", "阴", "后"] 

	v["五行"] = ["金","木","水","火","土"]

	v["干五行"] = [ 1, 1,  3, 3, 4, 4, 0, 0, 2, 2 ]
	v["支五行"] = [ 2, 4,  1, 1, 4, 3, 3, 4, 0, 0, 4 ,2 ]

	v["支藏五行"] = [ [2],[4,0,2],[1,3,4],[1],[4,2,1],[3,4,0],[3,4],[4,1,3],[0,2,4],[0],[4,0,3],[2,1] ]
		

	if ARGV.length < 1
		puts "Usage: ruby bazi.rb <datetime>"
		return
	end

	nongli = CDate.new()


	sizhu = nongli.bazi( DateTime.parse( ARGV[0] ) )
	wuxingcount = {}
	zichangwuxingcount = {}

	(0...4).each { |i|

		gan_element = v["干五行"][sizhu[i][0]]
		zhi_element = v["支五行"][sizhu[i][1]]

		puts "#{v["天干"][sizhu[i][0]]} (#{v["五行"][gan_element]}) #{v["地支"][sizhu[i][1]]} (#{v["五行"][zhi_element]})"

		wuxingcount[ gan_element ] = 0 if wuxingcount[ gan_element ] == nil
		wuxingcount[ gan_element ] += 1
		wuxingcount[ zhi_element ] = 0 if wuxingcount[ zhi_element ] == nil
		wuxingcount[ zhi_element ] += 1

		v["支藏五行"][sizhu[i][1]].each { | zce | 

			zichangwuxingcount[ zce ] = 0 if zichangwuxingcount[ zce ] == nil
			zichangwuxingcount[ zce ] += 1
		}
	}

	puts "\n五行\t干支\t支藏\t总数"
		
	(0..4).each { |element| 

		puts "#{v["五行"][element]}\t#{wuxingcount[element].to_i}\t#{zichangwuxingcount[element].to_i}\t#{wuxingcount[element].to_i + zichangwuxingcount[element].to_i }"
		
	}
	



end

main









