mclpath=string.match(GetInfo(35),"^.*\\")
print(mclpath)
package.path=mclpath.."\\?.lua;"
package.path=package.path..mclpath.."\\?.luac;"
require"wait"  
require "var"
--require "Skilldata"
require "addxml"
dofile (mclpath.."Lingt.luac")
dofile (mclpath.."UI.luac")
dofile (mclpath.."Funcdata.luac")
dofile (mclpath.."QuestProtect.luac")  --保护任务模块
dofile (mclpath.."Autoupdate.luac")
dofile (mclpath.."Questxuemo.luac")
http = require("socket.http")
version="2.00"
mclver="2.00"
url = "http://139.155.23.7:8080/"
remotever=""
mykey=""
wait.make(function()
	while mykey=="" do
		mykey=http.request(url.."EncryPt.txt")
		wait.time(1)
	end
end)
wait.make(function()
	while remotever=="" do
		remotever=http.request(url.."version.txt")
		wait.time(1)
	end
	print("远端版本加载成功!"..remotever)
end)
dofile (mclpath.."Function.luac")
world.Open(mclpath.."\\output.mcl")
logwin=GetWorld("chat")
Activate()
white=""
vip=""
whitelist=""
viplist=""
updatelog=""
begintime=os.time()
quest_stop=true
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
sklist=split(var.list_skill,",")
skdata={}
final_questfinish=false
dingdie=false
wait.make(function()
	while white=="" do
		white=http.request(url.."whitelist.txt")
		wait.time(1)
	end
	whitelist = split(white,",")
	print("白名单下载成功!"..#whitelist)
end)
wait.make(function()
	while vip=="" do
		vip=http.request(url.."vip.txt")
		wait.time(1)
	end
	viplist = split(vip,",")
	print("VIP名单下载成功!"..#viplist)
end)
wait.make(function()
	while updatelog=="" do
		updatelog=http.request(url.."updatelog.txt")
		wait.time(1)
	end
	ColourNote ("Red","white",updatelog)
end)
function testreg(str)
local s="忘忧无花果"
	s1,s2=string.find(s,'(.+).[粒颗](.+)')
	print(s1)
	print(s2)
end
addxml.timer{
	enabled="n",
	group="dog",
	name='watchdog',
	minute="2",
	active_closed="y",
	script='crashdump',
}
function reloadsklist()
	sklist=split(var.list_skill,",")
	print("技能列表重新载入完毕..."..#sklist)
end
function test()
	EnableGroup("wstpfm", false)
	EnableGroup("wst", false)
	EnableGroup("killnpc", false)
	EnableGroup("maze", false)
	EnableGroup("give", false)
	EnableGroup("get", false)
	EnableTrigger("medie", true)
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
		Execute("score;hp;skills")
		if not callpet() then
			print("必须有自己的宠物!@!!!")
			return false
		end
--		while whitelist==nil do
--			ColourNote ("red","white","请耐心等待授权检查!!!")
--			wait.time(1)
--		end
--		if whitelist~=nil and not cryptinfo() then
--			ColourNote ("red","white","未经授权！不得使用")
--			return 
--		end	
--		if viplist~=nil and vipinfo() then
--			dofile (mclpath.."Questxuemo.luac")  --血魔任务模块	
--		end	
		CharInfo.info.weaponvalue=0
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
		end
		while not quest_stop and not CharInfo.reboot do
			EnableTriggerGroup("checkbag",true)
			CharInfo.info.Gold=0
			CharInfo.info.food=0
			CharInfo.info.Silver=0
			CharInfo.info.cash=0
			Execute("hp;i;hp -m")
			CharInfo.info.weaponvalue=0
			CharInfo.repair=false
			for i= 1 ,#weaponlist do
				Execute("l "..weaponlist[i].." of me")
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
				logwin:ColourNote ("yellow","",os.date("%Y-%m-%d %H:%M:%S",os.time()).." "..CharInfo.info.id.." 缺少full药")
				EnableTimer("watchdog", false)
				return
			end
			while tonumbera(CharInfo.info.QX,"CharQX") <90 or tonumbera(CharInfo.info.JL,"CharJL")<60 do
				fullme()
				no_busy()
			end
			if var.tianshu=="yes" and not CharInfo.info.protect then
				Send("tell "..var.dummy.." Warning!!!检查到没有天书保护!!!")
				logwin:ColourNote ("yellow","",os.date("%Y-%m-%d %H:%M:%S",os.time()).." "..CharInfo.info.id.." 没有天书保护")
				EnableTimer("watchdog", false)
				return
			end
--			if CharInfo.info.pot>=CharInfo.info.potlimit and var.fullsk=="yes" then
--				Sendcmd(var.safehouse)
--				fullsk()
--				no_busy()
--			end
			print("gold:"..tostring(CharInfo.info.Gold))
			print("cash:"..tostring(CharInfo.info.cash))
			if tonumbera(CharInfo.info.Gold,"CharGold")>2000 then
				if not callpet() then
					print("必须有自己的宠物!@!!!")
					return false
				end
				Sendcmd("rideto gc;n;w;cun 1500 gold")
				no_busy()
			end
			if tonumbera(CharInfo.info.cash,"CharCash") >20 then
				if not callpet() then
					print("必须有自己的宠物!@!!!")
					return false
				end
				Sendcmd("rideto gc;n;w;cun 15 cash")
				no_busy()
			end
			if tonumbera(CharInfo.info.Gold,"CharGold")<100 and tonumbera(CharInfo.info.cash,"CharCash") <10 then
				if not callpet() then
					print("必须有自己的宠物!@!!!")
					return false
				end
				Sendcmd("rideto gc;n;w;qu 299 gold")
				no_busy()
				if tonumbera(CharInfo.info.Silver,"CharSilver") >1000 then 
					Send("cun "..CharInfo.info.Silver.." silver")
					no_busy()
				end
			end
			if CharInfo.info.hungry then
				print("eateat")
				if tonumbera(CharInfo.info.food,"Charfood")<10 then
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
			if CharInfo.repair or CharInfo.info.weaponvalue==0 then
				repair()
				no_busy()
			end
			if tonumbera(var.mingsi_lvl,"mingsi_lvl")>0 and tonumbera(CharInfo.info.Martial,"CharMartial")>tonumbera(var.mingsi_lvl,"mingsi_lvl") then
				mingsi()
			end
			if var.questtype=="protect" then
				QuestProtect()
			end
			if var.questtype=="xuemo" then
				if var.cantouch~="yes" then
					ColourNote ("red","white","作为终极任务，没有10兵说的过去？")
					return false
				end
--				if not vipinfo() then
--					ColourNote ("red","white","请先申请成为VVVVVVVIP！！！")
--					return false
--				end				
				QuestXuemo()
			end
			if not todaywst and not quest_stop  then
				if var.questtype=="protect" and Questinfo.count  % 5 ==0 then
					return wstbegin()
				end
				if var.questtype=="xuemo" then
					return wstbegin()
				end
			end
		end
		--walkto("rideto beijing;w;w;w;n;n;e;e;e;n;n")
		quest_ok=false
	end)
end

