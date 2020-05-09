ColourNote ("Green","black", "爬塔模块加载成功...")
Wstinfo={
	startime=0,
	endtime=0,
	level=0,
	direction="",
	startexp=0,
	}

------------------------------爬塔相关
wst_flag=true
wst_pass_num=11
--你再等等吧，现在周不通正在灵感北塔.第三百二十一层全力闯关中！
--杨小邪嘿嘿一笑，悄悄塞给你六张灵符。你一溜烟跑上楼梯去了。
function wstreset()
	todaywst=false
	wst_flag=true
	wstnow=false
end
function wstfullme()
	local ll
	Send("hp")
	no_busy()
	if CharInfo.info.QX<50 or CharInfo.info.JL<60 then
		Send("get all from "..var.fullitem)
		ll=wait.regexp("(你找不到.*这样东西。|那不是容器)", 2)
		ll= ll or ""
		if string.find(ll,"那不是容器") and var.wstfull=="yes" then
			Send("eat "..var.fullitem)
		end
		no_busy()
	else
		if CharInfo.info.neili<CharInfo.info.maxneili*0.5 then 
			if var.cantouch=="yes" then
				Sendcmd("mtc0;yun refresh")
			end
		end
		heal()
	end
end
function wstbegin()
		local ss0="rideto kaifeng;set wimpy 0;eu;ed;n;w;enter;xia;hp"
		local wst_enter={"westup", "eastup","southup","northup","up"}
--		if not vipinfo() then
--			wst_enter={"westup", "eastup","southup","northup"}
--		end
		EnableGroup("wst")
		wuchi_get=false
		wst_flag=true
		quest_ok=false
		wait.clearall()
		wait.make(function()
			local ss, ll, ww
			--Send("jifa force freezing-force")
			--wait.regexp("你改用另一种内功", 3)
			Execute("score;hp;hp -m")
			no_busy()
			wstfullme()
			if not callpet() then
				print("必须有自己的宠物!@!!!")
					return false
			end
			Sendcmd(ss0)
			while next(wst_enter) do
				ss=table.remove(wst_enter)
				Send(ss)
				ll, ww=wait.regexp("^(你再等等吧|杨小邪嘿嘿一笑|本日闯关你已经试过了)", 10)
				ll=ll or ""
				if string.find(ll, "等等") then
					no_busy()
				elseif string.find(ll,"本日闯关你已经") then
					todaywst=true
					no_busy()
					Send("out")	
					wait.clearall()
					return test()
				elseif string.find(ll,"杨小邪嘿嘿一笑") then
					EnableTimer("watchdog", false) --爬塔关狗
					no_busy()
					Wstinfo.startime=os.time()
					Wstinfo.startexp=CharInfo.info.exp
					Wstinfo.direction=ss
					wstnow=true
					logwin:ColourNote ("yellow","",os.date("%Y-%m-%d-%H-%M-%S",os.time()).." "..CharInfo.info.id.." 开始爬塔:"..ss)
					return
				end
			end
			Send("out")	
			Wstinfo.startexp=0
			wait.clearall()
			return test()
		end)
end
function wstfangqiexp()
	local limit=var.maxexp*0.1+300000
	if CharInfo.info.exp>var.maxexp+limit then
		Sendcmd("fangqi exp;hp")
		no_busy()
	else
		return false
	end
	return true
end
function wstend(name, line, mch)
		wait.make(function()
			EnableGroup("wst", false)
            EnableGroup("wstpfm", false)
			no_busy()
			Sendcmd("out")
			wstnow=false
			callpet()
			--icheck()
			wait.time(2)
			Execute("ww")
			--uniaa_team()
			--me.delay(2)
			--Execute("rr;jifa force beiming-shengong")
			--wait.regexp("你改用另一种内功", 3)
			wstfullme()
			todaywst=true
			wait.clearall()
			Wstinfo.level=mch[1]
			Wstinfo.endtime=os.time()
			logwin:ColourNote ("yellow","",os.date("%Y-%m-%d %H:%M:%S",os.time()).." "..CharInfo.info.id.." 结束爬塔:"..Wstinfo.level)
			while wstfangqiexp() do
				Send("hp")
				wait.time(1)
				no_busy()
			end
			Sendcmd("rideto gc;n;e;enter "..var.dummy)
			EnableTriggerGroup("give",true)
			Send("id")
			wait.time(1)
			EnableTriggerGroup("give",false)
			no_busy()
			CharInfo.info.weaponvalue=0
			return test()
		end)
end--function

function wstdie(name, line, mch)
	local go
    EnableTimer("wst_ab", false)
	EnableGroup("wstpfm", false)
	print(mch[1])
	if mch[1]== "一" then
		wst_flag= false;
	end;
	wait.make(function()
		if wst_flag then
			no_busy()
			--if wuchi_get then
			--	get_equ()
			--	wuchi_get=false
			--end
			Execute("hp;get 1 from 0")
			wait.regexp("^[> ]*你找不到", 10)
			if neili<maxneili/2 then
				wait.time(2)
				wstfullme()
			end
			--me.shenguang(2)
			--me.hanmo(3)
			repeat
				Send("follow qiu tu")
				ll=wait.regexp("^(你决定开始跟随|这里没有)",1)
				ll=ll or ""
				if string.find(ll,"你决定开始跟随") then
					wait.time(1)
				end
			until string.find(ll,"这里没有")
			no_busy()
			Execute("ww;special power;special hatred;u")
			EnableGroup("wstpfm")
		else
			no_busy()
			repeat
				Send("follow qiu tu")
				ll=wait.regexp("^(你决定开始跟随|这里没有)",1)
				ll=ll or ""
				if string.find(ll,"你决定开始跟随") then
					wait.time(1)
				end
			until string.find(ll,"这里没有")
			no_busy()
			Send("knock zhong")
		end
	end)
end
function wstjudge(name, line, mch)
    EnableTimer("wst_ab", false)
	EnableGroup("wstpfm", false)
	wst_pass_num=tonumber(mch[1])
	print("wstpass:"..wst_pass_num)
	wait.make(function()
		if wst_pass_num>1 and wst_flag then
			no_busy()
			if wst_pass_num<9 then
				Send("use fly knife")
			end
			Execute("hp;get 1 from 0")
			wait.regexp("^[> ]*你找不到", 10)
			if CharInfo.info.neili<CharInfo.info.maxneili/2 then
				if var.cantouch=="yes" then
					Sendcmd("mtc0;yun refresh")
				else
					wait.time(2)
					wstfullme()
				end
			end
			for i= 1 ,#weaponlist do
				--Send("hide "..weaponlist[i])
				Send("summon "..weaponlist[i])
				Send("get "..weaponlist[i])
				wait.time(1)
			end
			Execute("ww;special power;special hatred;u")
			EnableGroup("wstpfm")
		else
			no_busy()
			Send("knock zhong")
		end
	end)
end

function wstgo_next()
	wstjudge("", "", {wst_pass})
end
function wstabnormal()
	-- wait.make(function()
		-- EnableGroup("pfm", false)
		-- wait.clearall()
		-- local ll=wait.regexp("^你情急之下大喝一声掏", 180)
		-- me.fighting(2)
		-- Send("smell mu")
		-- wait.time(5)
		-- Send("knock zhong")
	-- end)
    EnableTimer("wst_ab")
end