  
  # Copyright (C) 2010 oCameLo. All rights reserved.
  
  # coding: UTF-8
  require 'date'

  class CDate
    
    # 根据不同locale保存简体或繁体的数据
    attr_accessor :stems, :branches, :animals, :months, :days, :terms, :leap, :astrologies

    def initialize( )
      # 按年份保存的cache
      @cache = {}
      
      # 检测locale信息
      #locale
      chs

    end

    private

    # 简体
    def chs
      @leap = '闰'

      ## 月名称,建寅
      # 春秋、战国时闰月名十三，秦汉时闰月名后九
      # 最后的那个一是武媚娘搞出来的特例
      @months = ['十一','十二','正','二','三','四','五','六','七','八','九','十'] + ['十三', '后九', '一']

      ## 日名称
      @days = ['初一','初二','初三','初四','初五','初六','初七','初八','初九','初十','十一','十二','十三','十四','十五','十六','十七','十八','十九','二十','廿一','廿二','廿三','廿四','廿五','廿六','廿七','廿八','廿九','三十','卅一']

      # 天干
      @stems = ['甲','乙','丙','丁','戊','己','庚','辛','壬','癸']

      # 地支
      @branches = ['子','丑','寅','卯','辰','巳','午','未','申','酉','戌','亥']

      # 生肖
      @animals = ['鼠','牛','虎','兔','龙','蛇','马','羊','猴','鸡','狗','猪']

      # 节气
      @terms = ['冬至','小寒','大寒','立春','雨水','惊蛰','春分','清明','谷雨','立夏','小满','芒种','夏至','小暑','大暑','立秋','处暑','白露','秋分','寒露','霜降','立冬','小雪','大雪']

      # 星座
      @astrologies = ['摩羯','水瓶','双鱼','白羊','金牛','双子','巨蟹','狮子','处女','天秤','天蝎','射手']
    end

    # 繁体
    def cht
      @leap = '閏'
      @months = ['十一','十二','正','二','三','四','五','六','七','八','九','十'] + ['十三', '後九', '一']
      @days = ['初一','初二','初三','初四','初五','初六','初七','初八','初九','初十','十一','十二','十三','十四','十五','十六','十七','十八','十九','二十','廿一','廿二','廿三','廿四','廿五','廿六','廿七','廿八','廿九','三十','卅一']
      @stems = ['甲','乙','丙','丁','戊','己','庚','辛','壬','癸']
      @branches = ['子','丑','寅','卯','辰','巳','午','未','申','酉','戌','亥']
      @animals = ['鼠','牛','虎','兔','龍','蛇','馬','羊','猴','雞','狗','豬']
      @terms = ['冬至','小寒','大寒','立春','雨水','驚蟄','春分','清明','穀雨','立夏','小滿','芒種','夏至','小暑','大暑','立秋','處暑','白露','秋分','寒露','霜降','立冬','小雪','大雪']
      @astrologies = ['摩羯','水瓶','雙魚','白羊','金牛','雙子','巨蟹','獅子','處女','天秤','天蠍','射手']
    end

    # 使用环境变量获取locale信息
    def locale_env
      if (e = ENV['LANG'] || ENV['LC_ALL']) && e.downcase! then
        case e[0..4]
        when 'zh_sg'
          return :zh_sg
        when 'zh_tw'
          return :zh_tw
        when 'zh_hk'
          return :zh_hk
        when 'zh_mo'
          return :zh_mo
        else
          return :zh_cn
        end
      else
        return :zh_cn
      end
    end

    # 使用Windows API获取locale信息
    def locale_win32api
      begin
        require 'dl'
        require 'dl/import'
        # GetSystemDefaultLCID的返回值可以在下面这里查到
        # http://msdn.microsoft.com/en-us/library/dd318693(v=VS.85).aspx
        # (SUBLANG_ID<<10) + LANG_ID
        lcid = DL.dlopen('kernel32') do |h|
          addr = h.sym('GetSystemDefaultLCID')
          cfunc = DL::CFunc.new(addr, DL::TYPE_INT)
          func = DL::Function.new(cfunc, [DL::TYPE_VOID])
          func.call
        end
        case lcid
        when 0x404 # 台湾
          return :zh_tw
        when 0xc04 # 香港
          return :zh_hk
        when 0x1404 # 澳门
          return :zh_mo
        when 0x1004 # 新加坡
          return :zh_sg
        else # 大陆是0x804
          return :zh_cn
        end
      rescue
        return :zh_cn
      end
    end

    public

    # 根据儒略日数算公历
    def jd2date(jd)
      raise ArgumentError, 'jd cannot be negative.' if jd < 0

      t = jd + 0.5
      z = t.floor
      f = t - z
      
      a = if z < 2299161 then
        z
      else
        t = ((z-1867216.25)/36524.25).floor
        z + 1 + t - (t/4.0).floor
      end
      b = a + 1524
      c = ((b-122.1)/365.25).floor
      d = (365.25*c).floor
      e = ((b-d)/30.6001).floor
      
      day = b - d - (30.6001*e).floor + f
      month = (e < 14 ? e-1 : e-13)
      year = (month > 2 ? c-4716 : c-4715)

      return [year, month, day]
    end

    # 根据公历算儒略日数
    def date2jd(year, month, day)
      raise ArgumentError, 'year cannot be less than -4712' if year < -4712

      if month <= 2 then
        year -= 1; month += 12
      end

      b = if year < 1582 or (year == 1582 and month < 10) or (year == 1582 and month == 10 and day <= 4) then
        0
      else
        a = (year/100.0).floor
        2 - a + (a/4.0).floor
      end

      return (365.25*(year+4716)).floor + (30.6001*(month+1)).floor + day + b - 1524.5
    end

    

    # 设置语言环境
    # loc可为:zh_cn, :zh_sg, :zh_tw, :zh_hk, :zh_mo其中之一
    # 如不给出loc则尝试自动判断
    def locale(loc = nil)
      # 默认采用简体中文
      @loc = :zh_cn

      if loc then
        @loc = loc if loc == :zh_sg or loc == :zh_tw or loc == :zh_hk or loc == :zh_mo
      else # 未给定loc，尝试自动判断
        # 有环境变量则采用
        if ENV['LANG'] || ENV['LC_ALL'] then
          @loc = locale_env
        elsif RUBY_PLATFORM =~ /cygwin|mingw|mswin/ then
          # 无环境变量并在Windows内则使用API
          @loc = locale_win32api
        end
      end

      # 目前不同locale就只有简繁体的区别
      if @loc == :zh_tw or @loc == :zh_hk or @loc == :zh_mo then
        cht
      else
        chs
      end
    end

    # 获取某年的农历数据
    #
    # jd为当年某日的儒略日数
    #
    # 返回一个包括实参对应日期所在年份农历数据的Hash：
    #
    # * :leap => int # 闰月位置
    # * :cd0 => jd # 当年的正月初一
    # * :ym => [] # 农历月名
    # * :zq => {} # 中气表
    # * :hs => [] # 合朔表
    # * :dx => [] # 各月大小
    def calc_year(jd)
      year = jd2date(jd)[0] # jd2date比Date类算起来快
      return @cache[year] if @cache.has_key?(year)

      dat = CCal::GolEph.calc_y(jd - CCal::GolEph::J2000)

      # 找正月初一，即春节
      i = dat[:hs][2] # 一般第三个月为正月
      0.upto(13) do |j|
        next if dat[:ym][j] != 2 || (dat[:leap] == j && j != 0)
        i = dat[:hs][j]
      end
      dat[:cd0] = i

      @cache[year] = dat
      return dat
    end

    # 获取某日的农历数据
    #
    # jd为该日儒略日数，
    #
    # 返回一个包括实参对应日期所在日农历数据的Hash：
    #
    # * :stem => string # 当年天干
    # * :branch => string # 当年地支
    # * :animal => string # 当年生肖
    # * :cmonth => string # 月名
    # * :cmleap => bool # 当月是否为闰月
    # * :cmdays => int # 当月天数，用以判断月大小
    # * :cday => string # 日名
    # * :term => string # 当日所含节气，无节气为nil
    # * :astrology => string # 星座
    #
    def calc_day(jd)
      dat = calc_year(jd)
      jd -= CCal::GolEph::J2000 # 底层代码以2k年起算
      d = {}

      # 干支纪年、生肖
      i = dat[:cd0]
      i -= 365 if jd < i
      i += 5810 ## 计算该年春节与1984年平均春节(立春附近)相差天数估计
      i = (i/365.2422+0.5).floor ## 农历纪年(10进制,1984年起算)
      i += 9000
      # .Net的ChineseLunisolarCalendar类里边
      # 天干翻做Celestial Stem，地支翻作Terrestrial Branch
      d[:stem] = @stems[i%10]
      i = i%12; d[:branch] = @branches[i]; d[:animal] = @animals[i]

      # 干支纪月
      ## 1998年12月7(大雪)开始连续进行节气计数,0为甲子
      i = ((jd-dat[:zq][0])/ 30.43685).floor
      ## 相对大雪的月数计算,mk的取值范围0-12
      i += 1 if i<12 && jd>=dat[:zq][2*i+1]
      ## 相对于1998年12月7(大雪)的月数,900000为正数基数
      i = i + ((dat[:zq][12]+390)/365.2422).floor * 12 + 900000;
      d[:stem_m] = @stems[i%10]; d[:branch_m] = @branches[i%12]

      # 干支纪日
      ## 2000年1月7日起算
      i = jd - 6 + 9000000
      d[:stem_d] = @stems[i%10]; d[:branch_d] = @branches[i%12]

      # 月
      i = ((jd - dat[:hs][0])/30).floor
      i += 1 if i<13 && dat[:hs][i+1]<=jd
      d[:cmleap] = dat[:leap] == i ? true : false # 是否闰月
      d[:cmdays] = dat[:dx][i] # 该月多少天，判断大小月
      d[:cmonth] = @months[dat[:ym][i]]

      d[:imonth] = (dat[:ym][i] - 2) % 12
      d[:iday] = (jd - dat[:hs][i]).floor()

      # 日
      d[:cday] = @days[jd - dat[:hs][i]]

      # 节气
      i = ((jd - dat[:zq][0] - 7)/15.2184).floor
      i += 1 if i < 23 && jd >= dat[:zq][i+1]
      d[:term] = jd == dat[:zq][i] ? @terms[i] : ''

      # 星座
      # 好吧，农历也弄这个蛮无聊的其实
      i = ((jd - dat[:zq][0] - 15)/30.43685).floor
      i += 1 if i<11 && jd>=dat[:zq][2*i+2]
      d[:astrology] = @astrologies[i%12]

      return d
    end

    def from_ccal(cyear, cmonth, cday, leap = false)
      # 后端中正月是2，11月和12月分别是0和1
      cmonth += cmonth > 10 ? -11 : 1
      jd = date2jd(cyear, 1, 1)
      dat = calc_year(jd)
      m = dat[:ym].index(2) # 正月的位置
      n = dat[:ym].index(cmonth) # 目标月的位置
      if n < m then
        # 目标月在正月之前，说明该月属于下一年
        jd += 366
        dat = calc_year(jd)
        n = dat[:ym].index(cmonth)
      end

      if leap then
        # 要找的是一个闰月
        raise "#{cyear} deosn't have a leap month" if dat[:leap] == 0
        raise "wrong leap month number" if dat[:ym][dat[:leap]] != cmonth
        n += 1
      end

      d = jd2date(dat[:hs][n] + cday - 1 + CCal::GolEph::J2000)
      d[2] -= 0.5
      return d
    end


    def to_ccal( dt ) 
      jdt = date2jd( dt.year, dt.month , dt.day )
      return calc_day( jdt );
    end 


    # 时区到经度的对应值
    ZONE2LNG = {-12=>-3.141592653589793, -11=>-2.8797932657906435, -10=>-2.6179938779914944, -9=>-2.356194490192345, -8=>-2.0943951023931953, -7=>-1.832595714594046, -6=>-1.5707963267948966, -5=>-1.3089969389957472, -4=>-1.0471975511965976, -3=>-0.7853981633974483, -2=>-0.5235987755982988, -1=>-0.2617993877991494, 0=>0.0, 1=>0.2617993877991494, 2=>0.5235987755982988, 3=>0.7853981633974483, 4=>1.0471975511965976, 5=>1.3089969389957472, 6=>1.5707963267948966, 7=>1.832595714594046, 8=>2.0943951023931953, 9=>2.356194490192345, 10=>2.6179938779914944, 11=>2.8797932657906435, 12=>3.141592653589793}
    
    # 计算八字
    #
    # 参数为DateTime类型
    #
    # 算八字需要准确的经度，否则时间的部分误差会非常大，这个函数似乎还是删掉的好。
    #
    def bazi(dt)
      zone = (dt.offset*24).to_i
      jd = dt.jd - 0.5 # ruby总是返回整数，减0.5得午夜0时的儒略日数
      jd += (dt.hour+dt.min/60.0)/24.0 # 加上时间，ruby没算这个部分
      jd -= zone/24.0 # 修正时差
      jd -= CCal::GolEph::J2000
      lng = ZONE2LNG[zone] # 根据时区获得近似经度

      jd2 = jd + CCal::GolEph.dt_t(jd) ## 力学时
      w = CCal::GolEph.s_alon(jd2/36525.0, -1) ## 此刻太阳视黄经
      k = ((w/(Math::PI*2)*360+45+15*360)/30.0).floor ## 1984年立春起算的节气数(不含中气)
      jd += CCal::GolEph.pty_zty2(jd2/36525.0)+lng/Math::PI/2 ## 本地真太阳时(使用低精度算法计算时差)

      jd += 13/24.0 ## 转为前一日23点起算
      _d = (jd).floor; _sc = ((jd-_d)*12).floor ## 日数与时辰

      r = []
      v = (k/12.0+6000000).floor; r.push [v%10, v%12]
      v = k+2+60000000; r.push [v%10, v%12]
      v = _d-6+9000000; r.push [v%10, v%12]
      v = (_d-1)*12+90000000+_sc; r.push [v%10, v%12]

      return r
    end
  end

 

