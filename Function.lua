ColourNote ("Green","black", "��������سɹ�...")
function queststop()
	quest_stop=true
end
function cryptinfo()
	local i
	if whitelist==nil then return end
	for i=1,#whitelist do
		if CharInfo.info.id==whitelist[i] then
			ColourNote ("red","white", CharInfo.info.id.."�ѻ��VVVVIP��Ȩ����ӭʹ��")
			return true
		end
	end
	return false	
end
function statistics(name,line,wildcards)
	if name=="getexp" then
		Questinfo.exp=Questinfo.exp+tonumber(chtonum(wildcards[1]))
	elseif name =="getpot" then
		Questinfo.pot=Questinfo.pot+tonumber(chtonum(wildcards[1]))
	elseif name =="gettihui" then
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
	local l=math.floor((Questinfo.count/t)*60*60)
	return l
end
function GetAveragePot()
	local t=os.time()-Questinfo.startime
	local l=math.floor((Questinfo.pot/t)*60*60)
	return l
end

-------------�����¼�����
function connserver()
	local ll
	if CharInfo.disevent~="normal" then 
		print("disevent:"..CharInfo.disevent)
		CharInfo.disevent="normal"
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
		ll=wait.regexp("(�����������|�����߽���)",3)
		ll=ll or ""
		if string.find(ll,"���߽���") then
			CharInfo.reboot=false
		end
		quest_ok=false
		
		return test()
	end)
end
-----------------------------�ε������߳�
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
		wait.regexp("(�����������|�����߽���)",3)
		Execute("halt;hp")
		Send("eat "..var.fullitem)
		no_busy()
		if not callpet() then
			print("�������Լ��ĳ���!!!")
			return
		end
		detoxify()
		fullme()
		quest_ok=false
		return test()
	end)
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
				Send("give "..i.." to "..GetVariable("dummy"))
			end
		end
	end
	--Send("set no_teach 1")
end
function mingsi()
	local mingsipath="rideto songshan;nu;ne;u;nu;nu;nu;nu;wu;nw"
	walkto(mingsipath)
	Send("mingsi")
	wait.regexp("^[> ]*(��ķ�����ѧ����|ʲô)",60)
	no_busy(1)
end
function dispel()
	local ll
	no_busy()
	Send("yun dispel")
	ll=wait.regexp("^[> ]*(�����������|���Ϣ���|���Ϣ����|�����û�����Լ����κ��쳣)",5)
	ll=ll or ""
	if string.find(ll,"��������") then
		if var.cantouch=="yes" then
			Sendcmd("mtc0;yun refresh")
		else
			Send("sleep")
			wait.regexp("^[> ]*��һ��������ֻ���������档�ûһ���ˡ�",30)
		end	
		return dispel()
	elseif string.find(ll,"�����û����") then
		no_busy()
		return
	else
		CharInfo.info.poison=true
	end
	no_busy()
end
function detoxify()
	if not callpet() then
		print("�������Լ��ĳ���!@!!!")
		return false
	end
	if os.time()-CharInfo.Combat.fbtime<115 then
		ColourNote ("red","white", CharInfo.info.id.."����cd�У�ǰ����̨������������")
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
	local ll,ww=wait.regexp("(�������$|Ĺ԰���$|Ϊ�˽�����ϷCPU����|�㻹��Ҫ��)",5)
	ll=ll or ""
	while string.find(ll,"��Ϸ") or string.find(ll,"��Ҫ") do
		wait.time(5)
		Send("enter door")
		ll,ww=wait.regexp("(�������$|Ĺ԰���$|Ϊ�˽�����ϷCPU����|�㻹��Ҫ��)",5)
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
		ll=wait.regexp("(���Ҳ���.*����������|�ǲ�������)", 2)
		ll= ll or ""
		if string.find(ll,"�ǲ�������") then
			Send("eat "..var.fullitem)
		else
			Send("tell "..var.dummy.." Warning!!!ȱ��fullҩ ����!!!")
		end
		no_busy()
	else
		if CharInfo.info.neili<CharInfo.info.maxneili*0.5 then 
			if var.cantouch=="yes" then
				Sendcmd("mtc0;yun refresh")
			else
				Send("sleep")
				wait.regexp("^[> ]*(��һ��������ֻ���������档�ûһ����|���ﲻ������˯�ĵط�)",30)
			end
		end
		heal()
	end
end
--***************************************************************���º�����Э���е���

function crashdump()
	local lin,text,path
	text=""
	path=mclpath..CharInfo.info.id
	wait.make(function()
		if var.isdump == "yes" then
			OpenLog(path.."\\"..os.date("%Y-%m-%d-%H-%M-%S",os.time())..".txt", true)
			if not IsLogOpen() then
				os.execute("mkdir "..path)
				OpenLog(path.."\\"..os.date("%Y-%m-%d-%H-%M-%S",os.time())..".txt", true)
				if not IsLogOpen() then
					Note("����LOG�ļ���ʧ��")
					return
				end
			end
			lin=GetLinesInBufferCount()
			for i=lin-500,lin do
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
	if name == "nomana" then
		if var.cantouch=="yes" then
			Execute("mtc0;yun refresh")
		end
	end
	if name=="bug" then
		Questinfo.bugcount=Questinfo.bugcount+1
--		if Questinfo.bugcount% 10 ==0 then
--			Send("bug transfer 1 to idler ")
--		end
	end
	if name=="bugfailed" then
		Questinfo.bugfailed=Questinfo.bugfailed+1
	end
	if name == "poison" then
		CharInfo.info.poison = true
	end
	if name == "danger" or  name == "danger1" then
		if var.wstfull~="yes" and wstnow then
			return
		end
		Execute("eat "..var.fullitem)
	end
	if name=="hungry" then
		CharInfo.info.hungry=true
	end
	if name=="mefaint" then
		wait.clearall()
		quest_stop=true
		CharInfo.disevent="mefaint"
		Disconnect()
		CharInfo.info.faintime=os.time()
		wakeup()
	end
	if name=="medie" then
		wait.clearall()
		quest_stop=true
		quest_ok=true
		crashdump()
		Execute("quit;quit;quit")
		CharInfo.disevent="medie"
		DoAfterSpecial(2,Disconnect(),12)
	end
end
function checknpc(name,line,wildcards)
	if name=="faint" or  name=="faint1" or name=="faint2" then
		print("faint")
		Questinfo.killer.faint=true
	elseif name=="die" then
		print("die")
		Questinfo.killer.die=true
	end
end
function walkto(path)
	local flag=false
	local ciflag=false
	local t=utils.split(path, ';')
	local i=1
	while i<=#t do
		Execute(t[i]..";set no_teach 6")
		local ll,ww=wait.regexp("^[> ]*(�趨����������no_teach = 6|��Ķ�����û����ɣ������ƶ���|�������û�г�·|��������һ����ס��|����.*�ȵ�|Ҫ��ǽ���üһ�|�����һԾ|���������|��ʹ����һ��)",3)
		ll=ll or ""
		--print(ll)
		if string.find(ll,"û�г�·") then
			print("·������")
			break
		elseif string.find(ll,"Ҫ��ǽ���üһ�") then
			ciflag=true
			Execute("wield long sword")
		elseif string.find(ll,"��������") then
			kill_npc("shi wei")
		elseif string.find(ll,"����") then
			kill_npc("ya yi")
		elseif string.find(ll,"��Ķ�����û�����") or string.find(ll,"�����һԾ") or string.find(ll,"���������")  or string.find(ll,"��ʹ����һ��") then
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
function no_busy(sec)
	local flag=0
	local ll, ww
	local kk=false
	if sec then
		wait.time(sec)
	end
	repeat
		Send("halt")
		ll, ww=wait.regexp("��(���ڲ�æ|����.*ͣ������|�������һԾ|������ת|һ������|������æ��)",10)
		ll=ll or ""
		--Note(ll)
		if string.find(ll, "��æ")  or string.find(ll,"������ת") then
			return true
		else
			flag=flag+1
			wait.time(1)
		end
	until kk or flag>60
	return false
end
function kill_npc(npcname)
     local ll,ww
	 local shot_bool
	 repeat
		Send("kill "..npcname)
		--ll,ww=wait.regexp("(�����|����û�������|�����ں��˼�����������|--->>����һ������û�����)",2)
		ll,ww=wait.regexp("(�������ʼ����|����û��|������û������ս����)",2)
		ll=ll or ""
		--Note(ll);
		--if string.find(ll,"�ȵ�") or string.find(ll,"���ں��˼�") or string.find(ll,"����û��") then
		if string.find(ll,"����") then
			 wait.time(1)
		elseif string.find(ll,"û������") then
			quest_ok=true
			return true
		else
			return true
	 end

	 until false
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
	ll,ww=wait.regexp("^[> ]*��(������.*�����̻��|����û�����ֶ�����)",12)
	ll=ll or ""
	if string.find(ll,"û��") then
		wait.time(0.5)
		return true
	end
	until false
end
	
function heal()--must be called in wait.make function
	local epp1="^[> ]*��(����.*������ˬ|���ھ�����|��ѧ���ڹ���û�����ֹ��ܡ�)"
	local epp2="^[> ]*��(�˹���ϣ��³�һ����Ѫ|������Ѫ��ӯ������Ҫ����)"
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
			print("����")
			CharInfo.info.hungry=true
		else
			CharInfo.info.hungry=false
		end
		CharInfo.info.pot=tonumber(wildcards[3])
		print(CharInfo.info.pot)
	elseif name=="water" then
		if tonumber(wildcards[1])<500 then
			print("����")
			CharInfo.info.hungry=true
		else
			CharInfo.info.hungry=false
		end		
		CharInfo.info.tihui=tonumber(wildcards[3])
	elseif name=="protect" then
		if wildcards[1]=="���o��" then
			CharInfo.info.protect=true
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
		CharInfo.info.weaponvalue=tonumber(wildcards[1])
		if wildcards[2] == "����" then
			CharInfo.info.weaponvalue=10
		end
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
		print("��ǰ����:"..CharInfo.info.Martial)
	elseif name=="reboot" then
		CharInfo.reboot=true
	end
end

function repair()--must be called in wait.make function
	local ll, ww,weaponid,i
	Sendcmd("rideto gc;e;e;s")
	for i= 1 ,#weaponlist do
		weaponid=weaponlist[i]
		Send("repair "..weaponid)
		ll, ww=wait.regexp("^[> ]*(�����Ϻ���û������������|.*�����������������ʲô��|������ȷ�����������Ʒ|�����㹻��Ǯ������ޣ��ٺ١�)", 10)
		ll=ll or ""
		if string.find(ll,"����") then
			Send("repair "..weaponid)
		elseif string.find(ll,"�㹻��Ǯ") then
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
	ll=wait.regexp("^[> ]*(����û��������������|�����Ծ��|���Ѿ���������)",5)
	ll=ll or ""
	if string.find(ll,"�����Ծ��")or string.find(ll,"���Ѿ�������") then
		return true
	end
	repeat
		Send("whistle")
		ll, ww=wait.regexp("(��������Ӳ����ˡ�|��û���Լ��ĳ��|��ֻ�����Դ�������һ��|������.*�����Դ�����|�㾫������)", 10)
		ll=ll or ""
		if string.find(ll,"�����Դ�����") or string.find(ll,"�Դ�����") then
			Send("ride "..var.petid)
			ll=wait.regexp("^[> ]*�����Ծ��",5)
			return true
		end
		if string.find(ll,"��û���Լ��ĳ��") then
			return false
		end
		if string.find(ll,"����") or string.find(ll,"��������Ӳ�����") then
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
			--Note("������� �ȴ�")
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
	local sk = var.list_skill
	local skill
	local sklist = split(sk,",")
	if(skid>#sklist) then
		skid=1
	end
	--Note("skid:"..skid)
	skill=sklist[skid]
	skid=skid+1
	return skill
end
function fangqiexp()
	local maxexp=tonumber(var.maxexp)
	if CharInfo.info.exp>maxexp+500000 then
		return true
	end
	if CharInfo.info.exp>maxexp then
		Sendcmd("fangqi exp;hp")
		no_busy()
	end 
end
function waitfullsk()
	local waittime
	if var.cantouch=="yes" then
		waittime=24
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
				Sendcmd("halt;"..waitcmd..";jiqu;hp")
			else
				Sendcmd("halt;"..waitcmd..";hp")
			end
		else
			if CharInfo.info.tihui>10000 then
				Sendcmd("halt;"..waitcmd..";"..var.lianxi..";exert recover;exert regenerate;jiqu;hp")
			else
				Sendcmd("halt;"..waitcmd..";"..var.lianxi..";exert recover;hp")
			end
		end
		--Note("neili:"..neili)
		if CharInfo.info.neili<500 then
			if var.cantouch=="yes" then
				Sendcmd("mtc0;yun refresh")
			else
				no_busy()
				Send("sleep")
				wait.regexp("^[> ]*��һ��������ֻ���������档�ûһ���ˡ�",30)
			end
			Send("hp")
			Note("fullsleep thread test")
		end
		if (os.time()-Questinfo.Recordtime)>=waittime then 
			return 
		end
		wait.time(1.5)
		Send("set no_teach fullsk")
		local ll,ww=wait.regexp("^[> ]*�趨����������no_teach",5)
	end 
	while  not quest_stop and var.cantouch=="yes" and (os.time()-Questinfo.Recordtime)< waittime do
		Sendcmd("halt;"..var.lianxi..";exert recover;hp")
		--Note("neili:"..neili)
		if CharInfo.info.neili<500 then
			if var.cantouch=="yes" then
				Sendcmd("mtc0;yun refresh")
			else
				no_busy()
				Send("sleep")
				wait.regexp("^[> ]*��һ��������ֻ���������档�ûһ���ˡ�",30)
			end
			Send("hp")
			Note("fullsleep thread test")
		end
		if CharInfo.info.tihui>10000 then
			Sendcmd("exert regenerate;jiqu")
		end
		if (os.time()-Questinfo.Recordtime)>=waittime then 
			return 
		end
		wait.time(1.5)
		Send("set no_teach fullsk")
		local ll,ww=wait.regexp("^[> ]*�趨����������no_teach",5)
	end 
end
function fullsk()
	while  not quest_stop and CharInfo.info.pot >CharInfo.info.potlimit-2000 do
		getwaitcmd()
		if CharInfo.info.hungry then
				CharInfo.info.hungry=false
				Send("eat yuchi zhou")
				no_busy()
		end
		if var.cantouch~="yes" then
			Sendcmd("halt;"..waitcmd..";hp")
		else
			Sendcmd("halt;"..waitcmd..";"..var.lianxi..";exert recover;hp")
		end
		--Note("neili:"..neili)
		if CharInfo.info.neili<500 then
			if var.cantouch=="yes" then
				Sendcmd("mtc0;yun refresh")
			else
				no_busy()
				Send("sleep")
				wait.regexp("^[> ]*��һ��������ֻ���������档�ûһ���ˡ�",30)
			end
			Send("hp")
			Note("fullsleep thread test")
		end
		wait.time(1.5)
		Send("set no_teach fullsk")
		local ll,ww=wait.regexp("^[> ]*�趨����������no_teach",5)
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

function chtonum(str)
	local result,wan,unit=0,1,1
	if (string.len(str) % 2) ==1 then
		return 0
	end
	for i=string.len(str) -2 ,0,-2 do
		char=string.sub(str,i+1,i+2)
		if (char=="ʮ") then
			unit=10*wan
			if (i==0) then
				result=result+unit
			elseif num_ch[string.sub(str,i-1,i)]==nil then
				result=result+unit
			end
		elseif (char=="��") then
			unit=100*wan
		elseif (char=="ǧ") then
			unit=1000*wan
		elseif (char=="��") then
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