ColourNote ("Green","black", "函数库加载成功...")
function queststop()
	quest_stop=true
	EnableTimer("watchdog", false)
end
------------迷宫部分--------------------
function maze_format()
	EnableTriggerGroup("maze",true)
	while not quest_stop do
		no_busy()
		Send("mazemap")
		ll=wait.regexp("^[> ]*(地图说明|系统气喘嘘地|这里不是迷宫区域)",2)
		ll=ll or ""
		if string.find(ll,"地图说明") then
			break
		elseif string.find(ll,"这里不是迷宫区域") then
			logwin:ColourNote("yellow","",os.date("%Y-%m-%d %H:%M:%S",os.time()).." "..CharInfo.info.id.." 进入副本失败，重启任务")
			quest_ok=false
			CharInfo.info.fbtime=os.time()
			return test()
		end
		wait.time(2)
	end
	Sendcmd(var.yunpower)
	Send("set brief 4")
	wait.regexp("^设定环境变数：brief = 4",2)
	EnableTriggerGroup("maze",false)
end
function maze_init()   --迷宫初始化
    local i;
    for i=1,64 do
       MyMaze.data[i]="";
    end;
    for i=1,64 do
       MyMaze.flag[i]=0;
    end;
    MyMaze.path="";
    MyMaze.line=0;
	for i=1,8 do
	MyMaze.out[i]=0
	end
	MyMaze.loc=0;
end;
function maze_exitid(dex,dir)  --从位置dex往dir方向走的下一个位置
    if dir=="n" then 
       dex=dex-8;
    end;
    if dir=="s" then
       dex=dex+8;
    end;
    if dir=="w" then
       dex=dex-1;
    end;
    if dir=="e" then
       dex=dex+1;
    end;
    if dex>64 then
       return 0;
    end;
    if dex<1 then
       return 0;
    end;
    return dex;
end;
function maze_addexit(dex,dir)         --添加dex位置dir方向的出口
    if MyMaze.data[dex]=="" then
       MyMaze.data[dex]=dir;
    else
       MyMaze.data[dex]=MyMaze.data[dex]..dir;
    end;
	--Note("data:"..dex.." dir:"..dir)
end; 
function maze_setmaze1(a,b,str)  --^│(..)(..)(..)(..)(..)(..)(..)(..)(..)(..)(..)(..)(..)(..)(..)│
local aaa
	--Note("line"..MyMaze.line)
  for i=0,7 do
	aaa=i*2+1
	  --Note(aaa..":"..str[aaa])
      if str[aaa]=="│" then
        maze_addexit(MyMaze.line*8+i+1,"s");
		if MyMaze.line<7 then
			maze_addexit(MyMaze.line*8+i+8+1,"n");
		end
      end;
   end;
	MyMaze.line=MyMaze.line+1;
end;
function maze_setmaze2(a,b,str)  --├(.*)┼(.*)┼(.*)┼(.*)┼(.*)┼(.*)┼(.*)┼(.*)┤
  for i=0,7 do
	  if str[i*2+1]=="●" then 
		if MyMaze.line==0 then
			MyMaze.loc=99;
			--Note("入口:"..MyMaze.loc)
		end
		if MyMaze.line==7 then
			MyMaze.outloc=MyMaze.line*8+i+1
			--Note("出口:"..MyMaze.outloc)
		end
	  end
      if i>0 and str[i*2]=="─" then
        maze_addexit(MyMaze.line*8+i,"e");
        maze_addexit(MyMaze.line*8+i+1,"w");
      end;
  end
	local lin,sty
	lin = GetLinesInBufferCount();
	sty = GetLineInfo(lin, 11);
	 for i=1,sty do
		if GetStyleInfo(lin,i,10) then
			MyMaze.loc=(GetStyleInfo(lin,i,3)-1) /4+1+MyMaze.line*8
		end
	end
	--Note("当前位置:"..MyMaze.loc)
	--Note("迷宫出口"..MyMaze.outloc)
end;
function maze_getpath(loc,des)           --计算从loc位置往des位置的路径，保存在path变量中
    local nex,dir;
	if loc==99 then
		loc=5
	end
	if des==99 then
		des=5
	end
    if loc==des then 
       return;
    end;
    MyMaze.flag[loc]=1;
	--Note("loc"..loc.."des"..MyMaze.data[loc])
    for i=1,string.len(MyMaze.data[loc]) do
       dir=string.sub(MyMaze.data[loc],i,i);
       nex=maze_exitid(loc,dir);
	   --Note("Nex:"..nex.."Dir:"..dir)
       if nex==des then
          MyMaze.path=MyMaze.path..dir; 
          return 1;
       end;
       if MyMaze.flag[nex]==0 then
          MyMaze.flag[nex]=1;      
          if maze_getpath(nex,des)==1 then
             MyMaze.path=MyMaze.path..string.sub(MyMaze.data[loc],i,i);
			 --Note("path:"..MyMaze.path)
             return 1;
          end;
		else
			--Note("Nex:"..nex.."走过")
       end;
    end;
	--Note("path:"..MyMaze.path)
    return 0;   
end;
function maze_walkto(dex,sec)  --从当前位置往dex位置走动,协程里调用
    MyMaze.path="";
	if MyMaze.loc==dex then
		return
	end
	if sec==nil then 
		sec=0
	end
	for i=1,64 do
    MyMaze.flag[i]=0;
    end;
	Note("当前位置:"..MyMaze.loc)
	Note("迷宫出口"..MyMaze.outloc)
    maze_getpath(MyMaze.loc,dex);
	Note("路径:"..MyMaze.path)
	if MyMaze.loc==99 then
		Send("s");
		MyMaze.loc=5
	end	
	walkto_spilt(sec);  
	if dex==99 then
		Send("n");
		MyMaze.loc=99
	end	
end;
function walkto_spilt(sec)
             local pathlen,pat;
	         pathlen=string.len(MyMaze.path)
				if pathlen>15 then
					for i=pathlen,pathlen-14,-1 do
						pat=string.sub(MyMaze.path,i,i)
						Send(pat)
						if pat=="w" then
							MyMaze.loc=MyMaze.loc-1
						elseif pat=="e" then
							MyMaze.loc=MyMaze.loc+1
						elseif pat=="s" then
							MyMaze.loc=MyMaze.loc+8
						else
							MyMaze.loc=MyMaze.loc-8
						end
					end
					MyMaze.path=string.sub(MyMaze.path,1,pathlen-15)
				else
					for i=pathlen,1,-1 do
						pat=string.sub(MyMaze.path,i,i)
						Send(pat)
						if pat=="w" then
							MyMaze.loc=MyMaze.loc-1
						elseif pat=="e" then
							MyMaze.loc=MyMaze.loc+1
						elseif pat=="s" then
							MyMaze.loc=MyMaze.loc+8
						else
							MyMaze.loc=MyMaze.loc-8
						end
					end
					MyMaze.path=""
				end
				Send("say 小心遇到鬼！！")
				wait.regexp("你说道：小心遇到鬼！！",12)
				if sec>0 then
					wait.time(sec)
					no_busy()
				end
				if MyMaze.path~="" then
					walkto_spilt(sec)
				end
end;

function maze_search(loc)         --从loc遍历迷宫并回到loc的路径，保存在path中
    local nex,dir,dirr;
    dirr="";
    MyMaze.flag[loc]=1;
    for i=1,string.len(MyMaze.data[loc]) do
        dir=string.sub(MyMaze.data[loc],i,i);
        nex=maze_exitid(loc,dir);
        if MyMaze.flag[nex]==1 then
           dirr=string.sub(MyMaze.data[loc],i,i);
        end;
        if MyMaze.flag[nex]==0 then
           MyMaze.flag[nex]=1;
           MyMaze.path=MyMaze.path..dir;
           maze_search(nex);        
        end;
    end;
    MyMaze.path=MyMaze.path..dirr;
end;
----------------------迷宫结束-------------------------
function cryptinfo()
	local i
	if whitelist==nil then return end
	for i=1,#whitelist do
		if CharInfo.info.id==whitelist[i] then
			ColourNote ("red","white", CharInfo.info.id.."已获得VIP授权！欢迎使用")
			return true
		end
	end
	return false	
end
function vipinfo()
	local i
	if viplist==nil then return false end
	for i=1,#viplist do
		if CharInfo.info.id==viplist[i] then
			ColourNote ("red","white", CharInfo.info.id.."已获得VVVVIP授权！欢迎使用")
			return true
		end
	end
	return false	
end
function statistics(name,line,wildcards)
	if name=="getexp" or name=="getexp2" then
		Questinfo.exp=Questinfo.exp+tonumber(chtonum(wildcards[1]))
	elseif name =="getpot" or name =="getpot2" then
		Questinfo.pot=Questinfo.pot+tonumber(chtonum(wildcards[1]))
	elseif name =="gettihui" or name =="gettihui2" then
		Questinfo.tihui=Questinfo.tihui+tonumber(chtonum(wildcards[1]))
	end
end
function Questcount()
	Questinfo.count=Questinfo.count+1
end
function GetAverageExp()
	local t=os.time()-Questinfo.startime
	local l=math.floor((Questinfo.exp/t)*60*60)
	return l
end
function GetAverageCount()
	local t=os.time()-Questinfo.startime
	local l=string.format("%.2f", (Questinfo.count/t)*60*60)         --1.93 修改效率保留2位小数 
	return l
end
function GetAveragePot()
	local t=os.time()-Questinfo.startime
	local l=math.floor((Questinfo.pot/t)*60*60)
	return l
end
function disconserver()   --断线杀func
	local ll
	if var.superman=="yes" and CharInfo.disevent=="mequest" then
		CharInfo.disevent="normal"
		return
	end
	Disconnect()
	i=0
	Connect()
	while not IsConnected() and i<=60 do
		wait.time(1)
		i=i+1
		Connect()
	end
	CharInfo.disevent="normal"
	Execute(var.id..";"..var.passw..";y")
	ll=wait.regexp("^(重新连线完毕|你连线进入|请输入密码：重新连线完毕)",3)
	ll=ll or ""
	if string.find(ll,"连线进入") then
		return test()
	end
end
-------------连接事件函数
function connserver()
	local ll                                                 
	if quest_stop then   --程序停止状态 不重连
		return 
	end
	if CharInfo.disevent~="normal" then 
		print("disevent:"..CharInfo.disevent)
		return 
	end
	wait.clearall()
	wait.make(function()
		Connect()
		i=0
		while not IsConnected() do
			wait.time(1)
			Connect()
		end
		Execute(var.id..";"..var.passw..";y")
		ll=wait.regexp("(重新连线完毕|你连线进入)",3)
		ll=ll or ""
		if string.find(ll,"连线进入") then
			CharInfo.reboot=false
		end
		quest_ok=false
		return test()
	end)
end
--------------------血魔专用函数---------------------
function loopkill(id)
	local i=1
	local ll
	while true do
		Send("kill "..id.." "..i)
		ll=wait.regexp("^(> )*(你对着|你对著|这里没有这个人|你正在和人家生死相扑呢|你上一个动作没有完成)",1)
		ll=ll or ""
		if string.find(ll,"这里没有这个人") then
			break
		end
		i=i+1
	end
end
function xuemo_killsearch() --血魔副本追杀小怪
	local num,pat,aa,bb,patnext
	Note("开始追杀:"..xuemo.kill_npc)
	MyMaze.path=""
	for i=1,64 do
        MyMaze.flag[i]=0;
    end;
	maze_search(MyMaze.loc)
	repeat
		--print(MyMaze.path)
		num=string.len(MyMaze.path)
		pat=string.sub(MyMaze.path,1,1)
		if pat=="w" then
			MyMaze.loc=MyMaze.loc-1
		elseif pat=="e" then
			MyMaze.loc=MyMaze.loc+1
		elseif pat=="n" then
			MyMaze.loc=MyMaze.loc-8
		else
			MyMaze.loc=MyMaze.loc+8
		end
		if MyMaze.loc ~= 29 and MyMaze.loc ~= 64 and MyMaze.loc ~= 8 then
			Send(pat)
			MyMaze.path=string.sub(MyMaze.path,2,num)
		else
			if num>1 then
				patnext=string.sub(MyMaze.path,2,2)
				print("next:"..patnext)
				if patnext=="w" then
					MyMaze.loc=MyMaze.loc-1
				elseif patnext=="e" then
					MyMaze.loc=MyMaze.loc+1
				elseif patnext=="n" then
					MyMaze.loc=MyMaze.loc-8
				else
					MyMaze.loc=MyMaze.loc+8
				end
				Send(pat)
				print("跳过中心点直接到:"..MyMaze.loc)
				Send(patnext)
				MyMaze.path=string.sub(MyMaze.path,3,num)
			end
		end
		Send("set no_teach 1")
		aa,bb=wait.regexp("(\\(鬼气\\)\\s+\("..xuemo.kill_npc..")\\(\(.*\)\\)|设定环境变数：no_teach = 1)",4)
		aa=aa or ""
		print(aa)
		if string.find(aa,"鬼气") then	
				kill_npc(bb[3])       
				no_busy()
				Sendcmd("mtc0;yun refresh")
		end
		print("目标:"..xuemo.kill_npc)
		if xuemo.kill_npc=="目标"  or not quest_ok then
				return
		end
		no_busy()
	until num==1
end
--***************************************************************************************


function xuemo_delnpc(name,b,str)
    if name=="killjs" then
		if string.find(xuemo.kill_npc,"僵尸") then
			xuemo.kill_npc=string.gsub(xuemo.kill_npc,"|僵尸","");	--"骷髅|幽灵|僵尸"
		end
	end;
	if name=="killkl" then
		if string.find(xuemo.kill_npc,"骷髅") and not (string.find(xuemo.kill_npc,"骷髅法师") or string.find(xuemo.kill_npc,"骷髅武士"))then
			xuemo.kill_npc=string.gsub(xuemo.kill_npc,"|骷髅","");
		end
	end;
	if name=="killyl" then
		if string.find(xuemo.kill_npc,"幽灵") then
			xuemo.kill_npc=string.gsub(xuemo.kill_npc,"|幽灵","");
		end
	end;
	if name=="killss" then
		if string.find(xuemo.kill_npc,"尸煞") then
			xuemo.kill_npc=string.gsub(xuemo.kill_npc,"|尸煞","");     --"骷髅武士|骷髅法师|幽冥之眼|幽冥之火|血僵尸|尸煞"
		end
	end;
    if name=="killxjs" then
		if string.find(xuemo.kill_npc,"血僵尸") then
			xuemo.kill_npc=string.gsub(xuemo.kill_npc,"|血僵尸","");
		end
	end;
	if name=="killymzh" then
		if string.find(xuemo.kill_npc,"幽冥之火") then
			xuemo.kill_npc=string.gsub(xuemo.kill_npc,"|幽冥之火","");
		end
	end;
	if name=="killymzy" then
		if string.find(xuemo.kill_npc,"幽冥之眼") then
			xuemo.kill_npc=string.gsub(xuemo.kill_npc,"|幽冥之眼","");
		end
	end;
	if name=="killklfs" then
		if string.find(xuemo.kill_npc,"骷髅法师") then
			xuemo.kill_npc=string.gsub(xuemo.kill_npc,"|骷髅法师","");
		end
	end;
	if name=="killklws" then
		if string.find(xuemo.kill_npc,"骷髅武士") then
			xuemo.kill_npc=string.gsub(xuemo.kill_npc,"|骷髅武士","");
		end
	end;
	Note(name.."调用,killnpc="..xuemo.kill_npc)
end;
function xuemo_del_npc(name,b,str)
    if name=="killjs" then
		if string.find(xuemo.kill_npc,"僵尸") then
			xuemo.kill_npc=string.gsub(xuemo.kill_npc,"|僵尸","");	--"骷髅|幽灵|僵尸"
		end
	end;
	if name=="killkl" then
		if string.find(xuemo.kill_npc,"骷髅") and not (string.find(xuemo.kill_npc,"骷髅法师") or string.find(xuemo.kill_npc,"骷髅武士"))then
			xuemo.kill_npc=string.gsub(xuemo.kill_npc,"|骷髅","");
		end
	end;
	if name=="killyl" then
		if string.find(xuemo.kill_npc,"幽灵") then
			xuemo.kill_npc=string.gsub(xuemo.kill_npc,"|幽灵","");
		end
	end;
	if name=="killss" then
		if string.find(xuemo.kill_npc,"尸煞") then
			xuemo.kill_npc=string.gsub(xuemo.kill_npc,"|尸煞","");     --"骷髅武士|骷髅法师|幽冥之眼|幽冥之火|血僵尸|尸煞"
		end
	end;
    if name=="killxjs" then
		if string.find(xuemo.kill_npc,"血僵尸") then
			xuemo.kill_npc=string.gsub(xuemo.kill_npc,"|血僵尸","");
		end
	end;
	if name=="killymzh" then
		if string.find(xuemo.kill_npc,"幽冥之火") then
			xuemo.kill_npc=string.gsub(xuemo.kill_npc,"|幽冥之火","");
		end
	end;
	if name=="killymzy" then
		if string.find(xuemo.kill_npc,"幽冥之眼") then
			xuemo.kill_npc=string.gsub(xuemo.kill_npc,"|幽冥之眼","");
		end
	end;
	if name=="killklfs" then
		if string.find(xuemo.kill_npc,"骷髅法师") then
			xuemo.kill_npc=string.gsub(xuemo.kill_npc,"|骷髅法师","");
		end
	end;
	if name=="killklws" then
		if string.find(xuemo.kill_npc,"骷髅武士") then
			xuemo.kill_npc=string.gsub(xuemo.kill_npc,"|骷髅武士","");
		end
	end;
	Note(name.."调用,killnpc="..xuemo.kill_npc)
end;
--------------------血魔专用结束---------------------
-----------------------------晕倒处理线程
function wakeup()
	local i,miss
	wait.clearall()
	CharInfo.disevent="mewakeup"
	Disconnect()
	CharInfo.Combat.FaintCount=CharInfo.Combat.FaintCount+1
	wait.make(function()
		while os.time()-CharInfo.info.faintime<120 do 
			wait.time(1)
		end
		Connect()
		i=0
		while not IsConnected() and i<=60 do
			wait.time(1)
			i=i+1
			Connect()
		end
		Execute(CharInfo.info.id..";"..var.passw..";y")
		wait.regexp("(重新连线完毕|你连线进入)",3)
		Execute("halt;hp")
		Send("eat "..var.fullitem)
		no_busy()
		if not callpet() then
			print("必须有自己的宠物!!!")
			return
		end
		detoxify()
		fullme()
		quest_ok=false
		return test()
	end)
end
function tonumbera(s,t)
	if tonumber(s) ==nil then
		ColourNote ("Red","white","Variable:["..t.."] is nil!!!please check this mcl Variable!!!!")
		return 0
	else
		return tonumber(s)
	end
end
--------------------------------------------------------------------------------------
function testgo()
	wait.make(function()
		walkto("rideto songshan;nu;ne;u;nu;nu;nu;nu;wu;nw")
	end)
end
function testvar()
	print(var.dummy)
end

function givedummy(name,line,mch)
	if mch ~= nil then
		if mch[1] ~= nil and mch[2]~=nil then
			local s=string.gsub(mch[1], "^%s*(.-)%s*$", "%1")
			local i=string.gsub(mch[2], "^%s*(.-)%s*$", "%1")
			print(s..","..i)
			if string.find(table.concat(gift,","),s) then
				if var.questtype=="xuemo" then
					Send("give "..i.." to idler")
				else
					Send("give "..i.." to "..var.dummy)
				end
			end
		end
	end
	--Send("set no_teach 1")
end
function mingsi()
	local mingsipath="rideto songshan;nu;ne;u;nu;nu;nu;nu;wu;nw"
	walkto(mingsipath)
	Send("mingsi")
	wait.regexp("^[> ]*(你耗费了武学修养|什么)",60)
	no_busy(1)
end
function dispel()
	local ll
	no_busy()
	Send("yun dispel")
	ll=wait.regexp("^[> ]*(你的内力不足|你调息完毕|你调息良久|结果你没发现自己有任何异常)",5)
	ll=ll or ""
	if string.find(ll,"内力不足") then
		if var.cantouch=="yes" then
			Sendcmd("mtc0;yun refresh")
		else
			Send("sleep")
			wait.regexp("^[> ]*你一觉醒来，只觉精力充沛。该活动一下了。",30)
		end	
		return dispel()
	elseif string.find(ll,"结果你没发现") then
		no_busy()
		return
	else
		CharInfo.info.poison=true
	end
	no_busy()
end
function detoxify()
	if not callpet() then
		print("必须有自己的宠物!@!!!")
		return false
	end
	if os.time()-CharInfo.Combat.fbtime<115 then
		logwin:ColourNote ("yellow","white",os.date("%Y-%m-%d %H:%M:%S",os.time()).." "..CharInfo.info.id.." 副本cd 前往擂台!")
		Sendcmd("rideto gc;w;w;w;w;s;leitai")
		wait.time(122-(os.time()-CharInfo.Combat.fbtime))
		return detoxify()
	end
	if CharInfo.info.exp<2000000 then
		Sendcmd("rideto gc;n;n;w;w;w;w;xia")
	else
		Sendcmd("rideto gc;n;n;w;w;w;n;xia")
	end
	CharInfo.Combat.PoisonCount=CharInfo.Combat.PoisonCount+1
	Send("enter door")
	local ll,ww=wait.regexp("(天牢入口$|墓园入口$|为了降低游戏CPU负担|你还需要等)",5)
	ll=ll or ""
	while string.find(ll,"游戏") or string.find(ll,"需要") do
		wait.time(5)
		Send("enter door")
		ll,ww=wait.regexp("(天牢入口$|墓园入口$|为了降低游戏CPU负担|你还需要等)",5)
		ll=ll or ""
	end
	CharInfo.Combat.fbtime=os.time()
	CharInfo.info.poison=false
end
function fullme()
	local ll
	Send("hp")
	no_busy()
	if CharInfo.info.QX<50 or CharInfo.info.JL<60 then
		Send("get all from "..var.fullitem)
		ll=wait.regexp("(你找不到.*这样东西。|那不是容器)", 2)
		ll= ll or ""
		if string.find(ll,"那不是容器") then
			Send("eat "..var.fullitem)
			logwin:ColourNote ("red","white",os.date("%Y-%m-%d %H:%M:%S",os.time()).." "..CharInfo.info.id.." 濒死吃药")
		else
			Send("tell "..var.dummy.." Warning!!!缺少full药 请检查!!!")
		end
		no_busy()
	else
		if CharInfo.info.neili<CharInfo.info.maxneili*0.5 then 
			if var.cantouch=="yes" then
				Sendcmd("mtc0;yun refresh")
			else
				Send("sleep")
				wait.regexp("^[> ]*(你一觉醒来，只觉精力充沛。该活动一下了|这里不是你能睡的地方)",30)
			end
		end
		heal()
	end
end
--***************************************************************以下函数在协程中调用
function trim(str)
	return string.gsub(str, "%s+", "")
end
function crashdump()
	local lin,text,path
	text=""
	path=mclpath..CharInfo.info.id
	print(path)
	logwin:ColourNote ("red","white",os.date("%Y-%m-%d %H:%M:%S",os.time()).." "..CharInfo.info.id.." 出现异常！dump log！")
	wait.make(function()
		if var.isdump == "yes" then
			OpenLog(path.."\\"..os.date("%Y-%m-%d-%H-%M-%S",os.time())..".txt", true)
			if not IsLogOpen() then
				os.execute("mkdir "..path)
				OpenLog(path.."\\"..os.date("%Y-%m-%d-%H-%M-%S",os.time())..".txt", true)
				if not IsLogOpen() then
					Note("创建LOG文件夹失败")
					return
				end
			end
			lin=GetLinesInBufferCount()
			for i=lin-5000,lin do
				text=GetLineInfo(i,1)
				if text~= nil and text~="" then
					WriteLog(text)
				end
			end
			CloseLog()
		end
	end)
end
function checkme(name,line,wildcards)
	if name=="skfull" then
		local argidx=3
		if string.find(wildcards[0],"> ") then 
			argidx=4
		end
		if skdata[wildcards[argidx]]==nil  then 
			logwin:ColourNote ("white","",os.date("%Y-%m-%d %H:%M:%S",os.time()).." "..CharInfo.info.id.." 发现未注册sk:"..wildcards[argidx])
			return
		end
		if #sklist==0 then       --如果技能列表full完成 判断是不是增加maxexp 阈值
			if var.upexp>0 then  
				var.maxexp=var.maxexp+var.upexp
				logwin:ColourNote ("white","",os.date("%Y-%m-%d %H:%M:%S",os.time()).." "..CharInfo.info.id.." maxexp阈值放开"..var.upexp.." maxexp设置为:"..var.maxexp)
				sklist=split(var.list_skill,",")
			end
			return
		end
		for i,v in ipairs(sklist) do
			if v == skdata[wildcards[argidx]] and CharInfo.info.exp+50000 >var.maxexp then
				table.remove(sklist, i)
				if #sklist==0 then       --如果技能列表full完成 判断是不是增加maxexp 阈值
					if var.upexp>0 then  
						var.maxexp=var.maxexp+var.upexp
						logwin:ColourNote ("white","",os.date("%Y-%m-%d %H:%M:%S",os.time()).." "..CharInfo.info.id.." maxexp阈值放开"..var.upexp)
						sklist=split(var.list_skill,",")
					end
				end
				print("remove "..skdata[wildcards[argidx]])
			end
		end
	end
	if name == "nomana" then
		if var.cantouch=="yes" then
			Execute("mtc0;yun refresh")
		end
	end
	if name=="bug" then
		Questinfo.bugcount=Questinfo.bugcount+1
		logwin:ColourNote ("red","",os.date("%Y-%m-%d %H:%M:%S",os.time()).." "..CharInfo.info.id.." 成功获得一个bug点")
--		if Questinfo.bugcount% 10 ==0 then
--			Send("bug transfer 1 to idler ")
--		end
	end
	if name=="bugfailed" then
		Questinfo.bugfailed=Questinfo.bugfailed+1
		logwin:ColourNote ("red","",os.date("%Y-%m-%d %H:%M:%S",os.time()).." "..CharInfo.info.id.." 吃到一颗过期烧麦")
	end
	if name == "poison" then
		CharInfo.info.poison = true
		logwin:ColourNote ("blue","white",os.date("%Y-%m-%d %H:%M:%S",os.time()).." "..CharInfo.info.id.." 中毒")
	end
	if name == "danger" or  name == "danger1" then
		if var.wstfull~="yes" and wstnow then
			return
		end
		Execute("eat "..var.fullitem)
		logwin:ColourNote ("red","white",os.date("%Y-%m-%d %H:%M:%S",os.time()).." "..CharInfo.info.id.." 濒死吃药")
	end
	if name=="hungry" then
		CharInfo.info.hungry=true
	end
	if name=="mefaint" then
		wait.clearall()
		logwin:ColourNote ("red","white",os.date("%Y-%m-%d %H:%M:%S",os.time()).." "..CharInfo.info.id.." 濒死晕倒")
		EnableTimer("watchdog", false)
		quest_stop=true
		quest_ok=false
		CharInfo.disevent="mefaint"
		Disconnect()
		CharInfo.info.faintime=os.time()
		wakeup()
	end
	if name=="medie" then
		wait.clearall()
		logwin:ColourNote ("red","white",os.date("%Y-%m-%d %H:%M:%S",os.time()).." "..CharInfo.info.id.." 死亡")
		EnableTimer("watchdog", false)
		EnableTrigger("medie", false)
		quest_stop=true
		quest_ok=true
		crashdump()
		Execute("quit;quit;quit")
		CharInfo.disevent="medie"
		DoAfterSpecial(2,Disconnect(),12)
	end
end
function loadskill(name,line,wildcards)
	print(trim(wildcards[3]),wildcards[4])
	skdata[trim(wildcards[3])]=wildcards[4]
end
function checknpc(name,line,wildcards)
	if name=="faint" or  name=="faint1" or name=="faint2" then
		print("faint")
		Questinfo.killer.faint=true
	elseif name=="die" then
		print("die")
		Questinfo.killer.die=true
	elseif name=="npccome" then
		if wildcards[2]=="黑衣人" then
			Questinfo.killer.id=CharInfo.info.id.."'s heiyi ren"
		elseif wildcards[2]=="邪派高手" then
			Questinfo.killer.id=CharInfo.info.id.."'s xiepai gaoshou"
		end
	end
end
function walkto(path)
	local flag=false
	local ciflag=false
	local t=utils.split(path, ';')
	local i=1
	while i<=#t do
		Execute(t[i]..";set no_teach 6")
		local ll,ww=wait.regexp("^[> ]*(设定环境变数：no_teach = 6|你的动作还没有完成，不能移动。|这个方向没有出路|康府侍卫一把拦住你|衙役.*喝道|要刺墙不用家伙|你奋力一跃|你纵身而起|你使劲儿一蹦)",3)
		ll=ll or ""
		--print(ll)
		if string.find(ll,"没有出路") then
			print("路径出错")
			break
		elseif string.find(ll,"要刺墙不用家伙") then
			ciflag=true
			Execute("wield long sword")
		elseif string.find(ll,"康府侍卫") then
			kill_npc("shi wei")
		elseif string.find(ll,"衙役") then
			kill_npc("ya yi")
		elseif string.find(ll,"你的动作还没有完成") or string.find(ll,"你奋力一跃") or string.find(ll,"你纵身而起")  or string.find(ll,"你使劲儿一蹦") then
			wait.time(0.5)			
		elseif string.find(ll,"no_teach = 6") then
			wait.time(0.1)
			i=i+1
		end
	end
	print(table.concat(t,","))
	Execute("set no_teach 3")
	if ciflag then
		Execute("unwield long sword")
	end
	return flag
end
function checkfight()
	Send("come")
	local ll=wait.regexp("(你要让什么野兽跟随你？|一边打架一边驯兽？你真是活腻了！)",2)
	ll=ll or ""
	if string.find(ll,"打架") then
		return true
	end
	return false
end
function no_busy(sec)
	local flag=0
	local ll, ww
	local kk=false
	if sec and sec <30 then
		wait.time(sec)
	end
	repeat
		Send("halt")
		ll, ww=wait.regexp("你(现在不忙|现在.*停不下来|身行向后一跃|心随意转|一觉醒来|现在正忙着)",10)
		ll=ll or ""
		--Note(ll)
		if string.find(ll, "不忙")  or string.find(ll,"心随意转") then
			return true
		elseif string.find(ll,"身行向后一跃") then
			if var.questtype=="xuemo" and not wstnow then
				if var.superman ~="yes" then
					CharInfo.disevent="mequest" 
					disconserver()
				else
					Sendcmd(var.pfm_all)
					no_busy()
				end
			else
				flag=flag+1
				wait.time(1)
			end
		else
			if sec==99 and string.find(ll,"停不下来") then
				if var.questtype=="xuemo" and final_questfinish then
					return
				end
				if checkfight() then
					CharInfo.disevent="mequest" 
					disconserver()
				end
			end
			flag=flag+1
			wait.time(1)
		end
	until kk or flag>60
	return false
end
function pairsByKeys(t)
    local a = {}
    for n in pairs(t) do a[#a + 1] = n end
    table.sort(a)
    local i = 0
    return function ()
        i = i + 1
        return a[i], t[a[i]]
    end
end
function xuemo_finishfinal()
	final_questfinish=true
	Send("report")
end
function ding_die()
	dingdie=true
end
function xuemoget(name,line,mch)
	if mch ~= nil then
		if mch[1] ~= nil and mch[2]~=nil then
			local s=string.gsub(mch[1], "^%s*(.-)%s*$", "%1")
			local i=string.gsub(mch[2], "^%s*(.-)%s*$", "%1")
			print(s..","..i)
			if string.find(table.concat(gift,","),s) then
				Send("get "..i)
			end
		end
	end
	--Send("set no_teach 1")
end
function killidhere(name,line,mch)
	local npcidx
	if mch ~= nil then
		if mch[1] ~= nil and mch[2]~=nil then
			local s=string.gsub(mch[1], "^%s*(.-)%s*$", "%1")
			local i=string.gsub(mch[2], "^%s*(.-)%s*$", "%1")
			npcidx=1
			--print("npc表:"..tostring(#npc))
			if #npc>0 then
				for k,v in ipairs(npc) do
					if k>0 then
						if v.id==i then
							npcidx=npcidx+1
						end
					end
				end
			end
			if string.find(s,"墓园入口") then 
				crashdump()
				logwin:ColourNote("red","white",os.date("%Y-%m-%d %H:%M:%S",os.time()).." "..CharInfo.info.id.." 任务失败:"..Questinfo.Questname)
				quest_ok=false
				CharInfo.info.fbtime=os.time()
				return test()
			end
			if string.find(table.concat(ghost,","),","..s..",") then
				local _npc={id=i,name=s,idx=npcidx}
				Send("kill ".._npc.id.." "..npcidx)
				print(_npc.name..",".._npc.id..","..npcidx)
				table.insert(npc,_npc)
			end
		end
	end
	--Send("set no_teach 1")
end
function kill_npc(npcname)
     local ll,ww
	 repeat
	 Send("kill "..npcname)
	 ll,ww=wait.regexp("(你对着|你对著|这里没有这个人|你正在和人家生死相扑呢|你上一个动作没有完成|看清楚一点，那并不是活物|你看了看晕倒在地|你现在没有力气战斗了。)",30)
	 ll=ll or ""
	 if string.find(ll,"喝道") or string.find(ll,"晕倒") then
		Sendcmd(var.pfm_all)
		wait.time(1)
	 elseif string.find(ll,"正在和人家") then
		Sendcmd(var.pfm_all)
		wait.time(1)
	 elseif string.find(ll,"没有完成") then
		Sendcmd(var.pfm_all)
		wait.time(1)
	elseif string.find(ll,"没有力气") then
		Sendcmd("yun regenerate;yun recover")
	 else
		print("npc over"..ll)
		return true
	 end
	 
	 until false
	 
end
function kill_boss(npcname,charname)
     local ll,ww
	 Send("jiali max")
	 repeat
		Send("push "..npcname.." to up")
		ll=wait.regexp("^[> ]*(你要推开谁|你看了看|这人现在没有知觉|人家现在正在打架呢)",2)
		ll=ll or ""
		print(ll)
		if string.find(ll,"你要推开谁") then
			return true
		elseif string.find(ll,"这人现在没有知觉") then
			Sendcmd("kill "..npcname)
			Sendcmd(var.pfm_all)
			no_busy()
			wait.time(1)
		else
			Sendcmd("exert regenerate;exert recover")
			Sendcmd("kill "..npcname)
			Sendcmd(var.pfm_boss)
			CharInfo.disevent="mequest"
			disconserver()
			if npcname=="skeleton lich" then
				no_busy(99)
			else
				no_busy()
			end
			Sendcmd("mtc0;yun refresh")
		end
	 until false
	 Send("jiali 1")
end
function kill_search()
	local num,pat,aa,bb,patnext,step
	step=0
	Note("开始追杀:"..xuemo.kill_npc)
	MyMaze.path=""
	for i=1,64 do
        MyMaze.flag[i]=0;
    end;
	maze_search(MyMaze.loc)
	repeat
		--print(MyMaze.path)
		num=string.len(MyMaze.path)
		pat=string.sub(MyMaze.path,1,1)
		print("当前loc:"..MyMaze.loc)
		if pat=="w" then
			MyMaze.loc=MyMaze.loc-1
		elseif pat=="e" then
			MyMaze.loc=MyMaze.loc+1
		elseif pat=="n" then
			MyMaze.loc=MyMaze.loc-8
		else
			MyMaze.loc=MyMaze.loc+8
		end
		if MyMaze.loc ~= 29 and MyMaze.loc ~= 64 and MyMaze.loc ~= 8 then
			Send(pat)
			MyMaze.path=string.sub(MyMaze.path,2,num)
		else --ewsn
			if num>1 then
				patnext=string.sub(MyMaze.path,2,2)
				print("next:"..patnext)
				if patnext=="w" then
					MyMaze.loc=MyMaze.loc-1
				elseif patnext=="e" then
					MyMaze.loc=MyMaze.loc+1
				elseif patnext=="n" then
					MyMaze.loc=MyMaze.loc-8
				else
					MyMaze.loc=MyMaze.loc+8
				end
				Send(pat)
				print("跳过中心点直接到:"..MyMaze.loc)
				Send(patnext)
				print("当前path:"..MyMaze.path)
				MyMaze.path=string.sub(MyMaze.path,3,num)
				print("剩余path:"..MyMaze.path)
			end
		end
		Send("set no_teach 1")
		aa,bb=wait.regexp("(\\(鬼气\\)\\s+\("..xuemo.kill_npc..")\\(\(.*\)\\)|设定环境变数：no_teach = 1)",4)
		aa=aa or ""
		if string.find(aa,"鬼气") then	
			wait.regexp("^(> )*(看起来.*想杀死你|.*和你一碰面|.*一眼瞥见你|.*对著你一声大喝|.*和你仇人相见)",2)
				CharInfo.disevent="mequest"
				disconserver()
				loopkill(bb[3])
				kill_npc(bb[3])       
				no_busy()
				Sendcmd("mtc0;yun refresh")
		end
		print(xuemo.kill_npc)
		if xuemo.kill_npc=="目标"  or not quest_ok then
				return
		end
		step=step+1
		if step % 10 ==0 then
			wait.time(1)
		end
		no_busy()
	until num==1
end
function get_all()
	if MyMaze.enemydown then
		Send("look")
		wait.time(1)
		for i=1,6 do
			Send("get gold from corpse "..i)
		end
	end
end
function sell_equip(equip)
	local ll,ww
	repeat
	Send("sell "..equip)
	ll,ww=wait.regexp("^[> ]*你(卖掉了.*给当铺伙计|身上没有这种东西啊)",12)
	ll=ll or ""
	if string.find(ll,"没有") then
		wait.time(0.5)
		return true
	end
	until false
end
	
function heal()--must be called in wait.make function
	local epp1="^[> ]*你(缓缓.*神清意爽|现在精神饱满|所学的内功中没有这种功能。)"
	local epp2="^[> ]*你(运功完毕，吐出一口瘀血|现在气血充盈，不需要疗伤)"
	Send("yun inspire")
	local ll, ww
	ll, ww=wait.regexp(epp1, 120)
	if ll then
		Sendcmd("halt;yun regenerate;yun heal")
		ll, ww=wait.regexp(epp2, 120)
		Sendcmd("halt;yun recover")
		wait.time(0.5)
	end
end
function checkstatus(name,line,wildcards)
	if name=="score" then
		CharInfo.info.id=wildcards[2]
		CharInfo.info.name=wildcards[1]
		var.chsname=CharInfo.info.name
		print(CharInfo.info.id.."|"..CharInfo.info.name)
	elseif name=="neili" then
		CharInfo.info.QX=tonumber(wildcards[1])
		CharInfo.info.neili=tonumber(wildcards[2])
		CharInfo.info.maxneili=tonumber(wildcards[3])
		print(CharInfo.info.QX.."%|"..CharInfo.info.neili.."|"..CharInfo.info.maxneili)
	elseif name=="jingqi" then
		CharInfo.info.JL=tonumber(wildcards[1])
		print(CharInfo.info.JL)
	elseif name=="food" then
		if tonumber(wildcards[1])<500 then
			print("饿了")
			CharInfo.info.hungry=true
		else
			CharInfo.info.hungry=false
		end
		CharInfo.info.pot=tonumber(wildcards[3])
		print(CharInfo.info.pot)
	elseif name=="water" then
		if tonumber(wildcards[1])<500 then
			print("饿了")
			CharInfo.info.hungry=true
		else
			CharInfo.info.hungry=false
		end		
		CharInfo.info.tihui=tonumber(wildcards[3])
	elseif name=="protect" then
		if wildcards[1]=="保護中" then
			CharInfo.info.protect=true
			print("tianshu yes")
		else
			CharInfo.info.protect=false
		end
	elseif name=="limit" then
		CharInfo.info.potlimit=tonumber(wildcards[1])
		CharInfo.info.thlimit=tonumber(wildcards[2])
		print(CharInfo.info.potlimit)
	elseif name=="exp" then
		CharInfo.info.exp=tonumber(wildcards[2])
	elseif name=="repair" then
		if wildcards[2] == "严重" then
			CharInfo.repair=true
		elseif tonumbera(wildcards[1],"weaponvalue")<tonumber(var.repairvalue) then
			CharInfo.repair=true
		end
		CharInfo.info.weaponvalue=tonumbera(wildcards[1],"weaponvalue")
		print("weapon value: "..CharInfo.info.weaponvalue)
	elseif name=="gold" then
		CharInfo.info.Gold=chtonum(wildcards[1])
		print("gold is "..CharInfo.info.Gold)
	elseif name=="cash" then
		
		CharInfo.info.cash=chtonum(wildcards[1])
		print("cash is "..CharInfo.info.cash)
	elseif name=="silver" then
		CharInfo.info.Silver=chtonum(wildcards[1])
		print("Silver is "..CharInfo.info.Silver)
	elseif name=="zhou" then
		CharInfo.info.food=chtonum(wildcards[1])
		print("food is "..CharInfo.info.food)
	elseif name=="martial" then 
		CharInfo.info.Martial=wildcards[1]
		print("当前武修:"..CharInfo.info.Martial)
	elseif name=="reboot" then
		CharInfo.reboot=true
		EnableTimer("watchdog", false)
	end
end

function repair()--must be called in wait.make function
	local ll, ww,weaponid,i
	Sendcmd("rideto gc;e;e;s")
	for i= 1 ,#weaponlist do
		weaponid=weaponlist[i]
		Send("repair "..weaponid)
		ll, ww=wait.regexp("^[> ]*(你身上好像没有这样东西。|.*现在完好无损，修理做什么？|如果你的确想修理这件物品|你有足够的钱吗，你就修，嘿嘿。)", 10)
		ll=ll or ""
		if string.find(ll,"修理") then
			Send("repair "..weaponid)
		elseif string.find(ll,"足够的钱") then
			Sendcmd("rideto gc;n;w;qu 199 gold")
			no_busy()
			return repair()
		end
		no_busy()
	end
end
function callpet()
	local ll, ww
	Send("ride "..var.petid)
	ll=wait.regexp("^[> ]*(这里没有这样东西可骑|你飞身跃上|你已经有座骑了)",5)
	ll=ll or ""
	if string.find(ll,"你飞身跃上")or string.find(ll,"你已经有座骑") then
		return true
	end
	repeat
		Send("whistle")
		ll, ww=wait.regexp("(跳进草锞子不见了。|你没有自己的宠物。|你只觉得脑袋被拍了一下|你现在.*不可以吹口哨|你精气不够)", 10)
		ll=ll or ""
		if string.find(ll,"不可以吹口哨") or string.find(ll,"脑袋被拍") then
			Send("ride "..var.petid)
			ll=wait.regexp("^[> ]*你飞身跃上",5)
			return true
		end
		if string.find(ll,"你没有自己的宠物。") then
			return false
		end
		if string.find(ll,"精气") or string.find(ll,"跳进草锞子不见了") then
			wait.time(1)
			Send("exert regenerate")
		end

	until false 
end
function split(s, delim)

  assert (type (delim) == "string" and string.len (delim) > 0,
          "bad delimiter")

  local start = 1
  local t = {}  -- results table

  -- find each instance of a string followed by the delimiter

  while true do
    local pos = string.find (s, delim, start, true) -- plain find

    if not pos then
      break
    end

    table.insert (t, string.sub (s, start, pos - 1))
    start = pos + string.len (delim)
  end -- while

  -- insert final one (after last delimiter)

  table.insert (t, string.sub (s, start))

  return t

end -- function split

function Sendcmd(cmdstr)
	local cmdlen,cmd
	local cmdlist=split(cmdstr,";")
	--Note(cmdlist[1] % cmdlist[2])
	for i=1,#cmdlist  do
		if i % 10 ~=0 then
			Send(cmdlist[i]);
		else
			--Note("命令过长 等待")
			wait.time(2)
			Send(cmdlist[i]);
		end
	end
end
function get_weapon()
	local list=var.weaponlist
	weaponlist=split(list,",")
end
function get_skill()
	print("skid:"..skid)
	print("剩余技能列表:"..table.concat(sklist,","))
	if #sklist==0 then 
		var.fullsk="skisfull"
		return "force"
	end
	skid=skid+1
	if skid>#sklist then
		skid=1
	end
	local skill=sklist[skid]
	return skill
end
function fangqiexp()
	local maxexp=tonumber(var.maxexp)
	local limit=var.maxexp*0.1+300000
	if tonumbera(CharInfo.info.exp,"Charexp")>maxexp+limit then
		return true
	end
	if tonumbera(CharInfo.info.exp,"Charexp")>maxexp then
		Sendcmd("fangqi exp;hp")
		no_busy()
	end 
end
function waitfullsk()
	local waittime
	if var.cantouch=="yes" then
		waittime=22
	else
		waittime=15
	end
	if CharInfo.info.hungry then
				CharInfo.info.hungry=false
				Send("eat yuchi zhou")
				no_busy()
	end
	while  not quest_stop and CharInfo.info.pot >5000  do
		getwaitcmd()
		if var.cantouch~="yes" then
			if CharInfo.info.tihui>10000 then
				Sendcmd("halt;"..waitcmd..";jiqu")
			else
				Sendcmd("halt;"..waitcmd.."")
			end
		else
			if CharInfo.info.tihui>10000 then
				Sendcmd("halt;"..waitcmd..";"..var.lianxi..";exert recover;exert regenerate;jiqu")
			else
				Sendcmd("halt;"..waitcmd..";"..var.lianxi..";exert recover")
			end
		end
		--Note("neili:"..neili)
		if CharInfo.info.neili<500 then
			if var.cantouch=="yes" then
				Sendcmd("mtc0;yun refresh")
			else
				no_busy()
				Send("sleep")
				wait.regexp("^[> ]*你一觉醒来，只觉精力充沛。该活动一下了。",30)
			end
			Note("fullsleep thread test")
		end
		if (os.time()-Questinfo.Recordtime)>=waittime then 
			return 
		end
		wait.time(1.5)
		Sendcmd("hp;set no_teach fullsk")
		local ll,ww=wait.regexp("^[> ]*设定环境变数：no_teach",5)
	end 
	while  not quest_stop and var.cantouch=="yes" and (os.time()-Questinfo.Recordtime)< waittime do
		Sendcmd("halt;"..var.lianxi..";exert recover")
		--Note("neili:"..neili)
		if CharInfo.info.neili<500 then
			if var.cantouch=="yes" then
				Sendcmd("mtc0;yun refresh")
			else
				no_busy()
				Send("sleep")
				wait.regexp("^[> ]*你一觉醒来，只觉精力充沛。该活动一下了。",30)
			end
			Note("fullsleep thread test")
		end
		if CharInfo.info.tihui>10000 then
			Sendcmd("exert regenerate;jiqu")
		end
		if (os.time()-Questinfo.Recordtime)>=waittime then 
			return 
		end
		wait.time(1.5)
		Sendcmd("hp;set no_teach fullsk")
		local ll,ww=wait.regexp("^[> ]*设定环境变数：no_teach",5)
	end 
end

function xuemofullsk()
	local waittime
	if var.questtype=="xuemo" then
		waittime=125
	end
	if CharInfo.info.hungry then
				CharInfo.info.hungry=false
				Send("eat yuchi zhou")
				no_busy()
	end
	while  not quest_stop and CharInfo.info.pot >5000  do
		getwaitcmd()
		if CharInfo.info.tihui>10000 then
			Sendcmd("halt;"..waitcmd..";"..var.lianxi..";exert recover;exert regenerate;jiqu")
		else
			Sendcmd("halt;"..waitcmd..";"..var.lianxi..";exert recover")
		end
		--Note("neili:"..neili)
		if CharInfo.info.neili<500 then
			if var.cantouch=="yes" then
				Sendcmd("mtc0;yun refresh")
			end
			Note("fullsleep thread test")
		end
		if (os.time()-CharInfo.info.fbtime)>=waittime then 
			return 
		end
		wait.time(1.5)
		Sendcmd("hp;set no_teach fullsk")
		local ll,ww=wait.regexp("^[> ]*设定环境变数：no_teach",5)
	end 
	while  not quest_stop and var.cantouch=="yes" and (os.time()-CharInfo.info.fbtime)< waittime do
		Sendcmd("halt;"..var.lianxi..";exert recover")
		--Note("neili:"..neili)
		if CharInfo.info.neili<500 then
			if var.cantouch=="yes" then
				Sendcmd("mtc0;yun refresh")
			else
				no_busy()
				Send("sleep")
				wait.regexp("^[> ]*你一觉醒来，只觉精力充沛。该活动一下了。",30)
			end
			Note("fullsleep thread test")
		end
		if CharInfo.info.tihui>10000 then
			Sendcmd("exert regenerate;jiqu")
		end
		if (os.time()-CharInfo.info.fbtime)>=waittime then 
			return 
		end
		wait.time(1.5)
		Sendcmd("hp;set no_teach fullsk")
		local ll,ww=wait.regexp("^[> ]*设定环境变数：no_teach",5)
	end 
end
function getwaitcmd()
	local casecmd=var.waitcmd
	if casecmd=="xue" then
		waitcmd="xue "..var.masterid.." "..get_skill().." 200"
	elseif casecmd=="yanjiu" then
		waitcmd="yanjiu "..get_skill().." 200"
	elseif casecmd=="study" then
		waitcmd="study "..get_skill().." 200"
	else
		waitcmd=casecmd
	end
end

function checkbag()
	local ll,ww,itemnum,i,name
	bag={}
	Execute("i;set no_teach over")
	ll=wait.regexp("^[> ]*你身上带着下列这些东西",5)
	ll=ll or ""
	print(ll)
	if string.find(ll,"身上带着下列") then
		while true do
			ll,ww=wait.regexp("^(.{2}(.*)\\((.*)\\)|.*设定环境变数：no_teach = \"over\")",1)
			ll=ll or ""
			if not string.find(ll,"设定环境变数") and ll~="" then
				print(ww[2])
				if string.find(ww[2],"颗") then
					itemnum=ctonum(string.sub(ww[2],1,string.find(ww[2],"颗")-1))
					name=string.sub(ww[2],string.find(ww[2],"颗")+2,string.len(ww[2]))
				elseif string.find(ww[2],"两") then
					itemnum=ctonum(string.sub(ww[2],1,string.find(ww[2],"两")-1))
					name=string.sub(ww[2],string.find(ww[2],"两")+2,string.len(ww[2]))
				elseif string.find(ww[2],"文") then
					itemnum=ctonum(string.sub(ww[2],1,string.find(ww[2],"文")-1))
					name=string.sub(ww[2],string.find(ww[2],"文")+2,string.len(ww[2]))
				elseif string.find(ww[2],"包") then
					itemnum=ctonum(string.sub(ww[2],1,string.find(ww[2],"包")-1))
					name=string.sub(ww[2],string.find(ww[2],"包")+2,string.len(ww[2]))
				else
					itemnum=1
					name=ww[2]
				end
				--print(name)
				if bag[string.lower(ww[3])]~=nil then
					bag[string.lower(ww[3])]={num=bag[string.lower(ww[3])].num+itemnum;name=name}
				else
					bag[string.lower(ww[3])]={num=itemnum;name=name}
				end
			end
			if string.find(ll,"over") then
				print("bag list ok")
				if bag["silver"]~=nil then
					Send("cunru "..tostring(bag["silver"].num).." silver")
				end
				if bag["coin"]~=nil then
					Send("cunru "..tostring(bag["coin"].num).." coin")
				end
				if bag["gold"]~=nil then
					Send("cunru "..tostring(bag["gold"].num).." gold")
				end
				return true
			end
		end
	else 
		return false
	end
end
function chtonum(str)
	local result,wan,unit=0,1,1
	if (string.len(str) % 2) ==1 then
		return 0
	end
	for i=string.len(str) -2 ,0,-2 do
		char=string.sub(str,i+1,i+2)
		if (char=="十") then
			unit=10*wan
			if (i==0) then
				result=result+unit
			elseif num_ch[string.sub(str,i-1,i)]==nil then
				result=result+unit
			end
		elseif (char=="百") then
			unit=100*wan
		elseif (char=="千") then
			unit=1000*wan
		elseif (char=="万") then
			unit=10000*wan
			wan=10000
		else
			if num_ch[char]~=nil then
				result=result+num_ch[char]*unit
			end
		end
	end
	return result
end