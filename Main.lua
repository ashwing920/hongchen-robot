mclpath=string.match(GetInfo(35),"^.*\\")
print(mclpath)
package.path=mclpath.."\\?.lua;"
package.path=package.path..mclpath.."\\?.luac;"
require"wait"  
require "var"
require "Lingt" --爬塔模块
require "UI"  --界面模块
require "Funcdata"  --数据定义模块
require "Function"  --函数定义模块
require "QuestProtect"  --保护任务模块
dofile (mclpath.."Autoupdate.luac")
print("重新Reload脚本")
http = require("socket.http")
version="1.72"
mclver="1.72"
url = "http://139.155.23.7:8080/"
white=""
whitelist=""
remotever=""
updatelog=""
begintime=os.time()
quest_stop=false
killyf=0 
killlt=0
killlly=0
quest_start_time=0
quest_now_time=0
quest_get_gold=0
quest_ok=false
pot=0
exp=0
neili=0
maxneili=0
skid=1
connecttime=5
isrepair=false
ishungry=false
isgold=false
isbuyarrow=false
isprotect=false
Nottime=false
issleep=false
buyyao=false
waitcmd=""
todaywst=true
wstnow=false

wait.make(function()
	while remotever=="" do
		remotever=http.request(url.."version.txt")
		wait.time(1)
	end
	print("远端版本加载成功!"..remotever)
end)
wait.make(function()
	while white=="" do
		white=http.request(url.."whitelist.txt")
		wait.time(1)
	end
	whitelist = split(white,",")
	print("白名单下载成功!"..#whitelist)
end)
wait.make(function()
	while updatelog=="" do
		updatelog=http.request(url.."updatelog.txt")
		wait.time(1)
	end
	ColourNote ("Red","white",updatelog)
end)

function test()
	EnableGroup("wstpfm", false)
	EnableTimer("wst_ab", false)
	if quest_ok then
		ColourNote ("Green","white","程序已经开始!!!")
		return
	end
	quest_stop=false
	wait.make(function()
		quest_ok=true
		while remotever=="" do
			ColourNote ("Red","white","请耐心等待版本检查!!!")
			wait.time(1)
		end
		wait.clearall()
		if tonumber(remotever)>tonumber(version) then
			ColourNote ("red","white","版本不对，请更新最新"..remotever.."使用")
			return updater() 
		end	
		if var.mclver==nil then var.mclver=0 end
		if tonumber(mclver)>tonumber(var.mclver) then
			ColourNote ("red","white","mcl版本不对，请等待mcl差量更新")
			--GetFile("updatemcl.lua")
			require("updatemcl")
			ColourNote ("red","white","mcl更新完毕")
		end	
		Execute("score;hp")
		if not callpet() then
			print("必须有自己的宠物!@!!!")
			return false
		end
		while whitelist==nil do
			ColourNote ("red","white","请耐心等待授权检查!!!")
			wait.time(1)
		end
		if whitelist~=nil and not cryptinfo() then
			ColourNote ("red","white","未经授权！不得使用")
			return 
		end	
		get_weapon()
		Send("ride "..var.petid)
		for i= 1 ,#weaponlist do
			Send("hide "..weaponlist[i])
			Send("summon "..weaponlist[i])
			wait.time(1)
		end
		Send("get all from long sword")
		ll=wait.regexp("(你找不到.*这样东西。|那不是容器)",2)
		ll=ll or ""
		if string.find(ll,"你找不到") then
			Sendcmd("rideto gc;e;e;s;buy long sword")
			no_busy()
		end
		Execute("get all from sleepbag")
		ll=wait.regexp("(你找不到.*这样东西。|你什么都没有拣起来。)",2)
		ll=ll or ""
		if string.find(ll,"你找不到") then
			Sendcmd("rideto gc;n;w;qu 99 silver")
			no_busy()
			Sendcmd("rideto gc;e;s;buy sleepbag")
			no_busy()
		end
	
		if Questinfo.startime==0 then
			Questinfo.startime=os.time()
			Questinfo.startexp=CharInfo.info.exp
		end
		while not quest_stop and not CharInfo.reboot do
			EnableTriggerGroup("checkbag",true)
			CharInfo.info.Gold=0
			CharInfo.info.food=0
			CharInfo.info.Silver=0
			CharInfo.info.cash=0
			Execute("hp;i;hp -m")
			for i= 1 ,#weaponlist do
				Execute("l "..weaponlist[i])
			end
			no_busy()
			EnableTriggerGroup("checkbag",false)
			if CharInfo.info.poison then
				detoxify()
				no_busy()
				if not callpet() then
					print("必须有自己的宠物!@!!!")
					return false
				end
			end
			Send("get all from "..var.fullitem)
			ll=wait.regexp("(你找不到.*这样东西。|那不是容器)", 5)
			ll= ll or ""
			if not string.find(ll,"那不是容器") then
				Send("tell "..var.dummy.." Warning!!!缺少full药 请检查!!!")
				return
			end
			while CharInfo.info.QX <90 or CharInfo.info.JL<60 do
				fullme()
				no_busy()
			end
--			if CharInfo.info.pot>=CharInfo.info.potlimit and var.fullsk=="yes" then
--				Sendcmd(var.safehouse)
--				fullsk()
--				no_busy()
--			end
			print("gold:"..tostring(CharInfo.info.Gold))
			print("cash:"..tostring(CharInfo.info.cash))
			if CharInfo.info.Gold>2000 then
				if not callpet() then
					print("必须有自己的宠物!@!!!")
					return false
				end
				Sendcmd("rideto gc;n;w;cun 1500 gold")
				no_busy()
			end
			if CharInfo.info.cash >20 then
				if not callpet() then
					print("必须有自己的宠物!@!!!")
					return false
				end
				Sendcmd("rideto gc;n;w;cun 15 cash")
				no_busy()
			end
			if CharInfo.info.Gold<100 and CharInfo.info.cash <10 then
				if not callpet() then
					print("必须有自己的宠物!@!!!")
					return false
				end
				Sendcmd("rideto gc;n;w;qu 299 gold")
				no_busy()
				if CharInfo.info.Silver >1000 then 
					Send("cun "..CharInfo.info.Silver.." silver")
					no_busy()
				end
			end
			if CharInfo.info.hungry then
				print("eateat")
				if CharInfo.info.food<10 then
					if not callpet() then
						print("必须有自己的宠物!@!!!")
						return false
					end
					Sendcmd("rideto gc;n;n;e;buy 100 yuchi zhou")
					no_busy()
				end
				CharInfo.info.hungry=false
				Send("eat yuchi zhou")
				no_busy()
			end
			if CharInfo.info.weaponvalue<30 then
				repair()
				no_busy()
			end
			if tonumber(var.mingsi_lvl)>0 and tonumber(CharInfo.info.Martial)>tonumber(var.mingsi_lvl) then
				mingsi()
			end
			QuestProtect()
			if not todaywst and not quest_stop and Questinfo.count  % 5 ==0 then
				return wstbegin()
			end
		end
		--walkto("rideto beijing;w;w;w;n;n;e;e;e;n;n")
		quest_ok=false
	end)
end

