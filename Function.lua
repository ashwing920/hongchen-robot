ColourNote ("Green","black", "��������سɹ�...")
function queststop()
	quest_stop=true
	EnableTimer("watchdog", false)
end
------------�Թ�����--------------------
function maze_format()
	EnableTriggerGroup("maze",true)
	while not quest_stop do
		no_busy()
		Send("mazemap")
		ll=wait.regexp("^[> ]*(��ͼ˵��|ϵͳ�������|���ﲻ���Թ�����)",2)
		ll=ll or ""
		if string.find(ll,"��ͼ˵��") then
			break
		elseif string.find(ll,"���ﲻ���Թ�����") then
			logwin:ColourNote("yellow","",os.date("%Y-%m-%d %H:%M:%S",os.time()).." "..CharInfo.info.id.." ���븱��ʧ�ܣ���������")
			quest_ok=false
			CharInfo.info.fbtime=os.time()
			return test()
		end
		wait.time(2)
	end
	Sendcmd(var.yunpower)
	Send("set brief 4")
	wait.regexp("^�趨����������brief = 4",2)
	EnableTriggerGroup("maze",false)
end
function maze_init()   --�Թ���ʼ��
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
function maze_exitid(dex,dir)  --��λ��dex��dir�����ߵ���һ��λ��
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
function maze_addexit(dex,dir)         --���dexλ��dir����ĳ���
    if MyMaze.data[dex]=="" then
       MyMaze.data[dex]=dir;
    else
       MyMaze.data[dex]=MyMaze.data[dex]..dir;
    end;
	--Note("data:"..dex.." dir:"..dir)
end; 
function maze_setmaze1(a,b,str)  --^��(..)(..)(..)(..)(..)(..)(..)(..)(..)(..)(..)(..)(..)(..)(..)��
local aaa
	--Note("line"..MyMaze.line)
  for i=0,7 do
	aaa=i*2+1
	  --Note(aaa..":"..str[aaa])
      if str[aaa]=="��" then
        maze_addexit(MyMaze.line*8+i+1,"s");
		if MyMaze.line<7 then
			maze_addexit(MyMaze.line*8+i+8+1,"n");
		end
      end;
   end;
	MyMaze.line=MyMaze.line+1;
end;
function maze_setmaze2(a,b,str)  --��(.*)��(.*)��(.*)��(.*)��(.*)��(.*)��(.*)��(.*)��
  for i=0,7 do
	  if str[i*2+1]=="��" then 
		if MyMaze.line==0 then
			MyMaze.loc=99;
			--Note("���:"..MyMaze.loc)
		end
		if MyMaze.line==7 then
			MyMaze.outloc=MyMaze.line*8+i+1
			--Note("����:"..MyMaze.outloc)
		end
	  end
      if i>0 and str[i*2]=="��" then
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
	--Note("��ǰλ��:"..MyMaze.loc)
	--Note("�Թ�����"..MyMaze.outloc)
end;
function maze_getpath(loc,des)           --�����locλ����desλ�õ�·����������path������
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
			--Note("Nex:"..nex.."�߹�")
       end;
    end;
	--Note("path:"..MyMaze.path)
    return 0;   
end;
function maze_walkto(dex,sec)  --�ӵ�ǰλ����dexλ���߶�,Э�������
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
	Note("��ǰλ��:"..MyMaze.loc)
	Note("�Թ�����"..MyMaze.outloc)
    maze_getpath(MyMaze.loc,dex);
	Note("·��:"..MyMaze.path)
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
				Send("say С����������")
				wait.regexp("��˵����С����������",12)
				if sec>0 then
					wait.time(sec)
					no_busy()
				end
				if MyMaze.path~="" then
					walkto_spilt(sec)
				end
end;

function maze_search(loc)         --��loc�����Թ����ص�loc��·����������path��
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
----------------------�Թ�����-------------------------
function cryptinfo()
	local i
	if whitelist==nil then return end
	for i=1,#whitelist do
		if CharInfo.info.id==whitelist[i] then
			ColourNote ("red","white", CharInfo.info.id.."�ѻ��VIP��Ȩ����ӭʹ��")
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
			ColourNote ("red","white", CharInfo.info.id.."�ѻ��VVVVIP��Ȩ����ӭʹ��")
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
	local l=string.format("%.2f", (Questinfo.count/t)*60*60)         --1.93 �޸�Ч�ʱ���2λС�� 
	return l
end
function GetAveragePot()
	local t=os.time()-Questinfo.startime
	local l=math.floor((Questinfo.pot/t)*60*60)
	return l
end
function disconserver()   --����ɱfunc
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
	ll=wait.regexp("^(�����������|�����߽���|���������룺�����������)",3)
	ll=ll or ""
	if string.find(ll,"���߽���") then
		return test()
	end
end
-------------�����¼�����
function connserver()
	local ll                                                 
	if quest_stop then   --����ֹͣ״̬ ������
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
		ll=wait.regexp("(�����������|�����߽���)",3)
		ll=ll or ""
		if string.find(ll,"���߽���") then
			CharInfo.reboot=false
		end
		quest_ok=false
		return test()
	end)
end
--------------------Ѫħר�ú���---------------------
function loopkill(id)
	local i=1
	local ll
	while true do
		Send("kill "..id.." "..i)
		ll=wait.regexp("^(> )*(�����|�����|����û�������|�����ں��˼�����������|����һ������û�����)",1)
		ll=ll or ""
		if string.find(ll,"����û�������") then
			break
		end
		i=i+1
	end
end
function xuemo_killsearch() --Ѫħ����׷ɱС��
	local num,pat,aa,bb,patnext
	Note("��ʼ׷ɱ:"..xuemo.kill_npc)
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
				print("�������ĵ�ֱ�ӵ�:"..MyMaze.loc)
				Send(patnext)
				MyMaze.path=string.sub(MyMaze.path,3,num)
			end
		end
		Send("set no_teach 1")
		aa,bb=wait.regexp("(\\(����\\)\\s+\("..xuemo.kill_npc..")\\(\(.*\)\\)|�趨����������no_teach = 1)",4)
		aa=aa or ""
		print(aa)
		if string.find(aa,"����") then	
				kill_npc(bb[3])       
				no_busy()
				Sendcmd("mtc0;yun refresh")
		end
		print("Ŀ��:"..xuemo.kill_npc)
		if xuemo.kill_npc=="Ŀ��"  or not quest_ok then
				return
		end
		no_busy()
	until num==1
end
--***************************************************************************************


function xuemo_delnpc(name,b,str)
    if name=="killjs" then
		if string.find(xuemo.kill_npc,"��ʬ") then
			xuemo.kill_npc=string.gsub(xuemo.kill_npc,"|��ʬ","");	--"����|����|��ʬ"
		end
	end;
	if name=="killkl" then
		if string.find(xuemo.kill_npc,"����") and not (string.find(xuemo.kill_npc,"���÷�ʦ") or string.find(xuemo.kill_npc,"������ʿ"))then
			xuemo.kill_npc=string.gsub(xuemo.kill_npc,"|����","");
		end
	end;
	if name=="killyl" then
		if string.find(xuemo.kill_npc,"����") then
			xuemo.kill_npc=string.gsub(xuemo.kill_npc,"|����","");
		end
	end;
	if name=="killss" then
		if string.find(xuemo.kill_npc,"ʬɷ") then
			xuemo.kill_npc=string.gsub(xuemo.kill_npc,"|ʬɷ","");     --"������ʿ|���÷�ʦ|��ڤ֮��|��ڤ֮��|Ѫ��ʬ|ʬɷ"
		end
	end;
    if name=="killxjs" then
		if string.find(xuemo.kill_npc,"Ѫ��ʬ") then
			xuemo.kill_npc=string.gsub(xuemo.kill_npc,"|Ѫ��ʬ","");
		end
	end;
	if name=="killymzh" then
		if string.find(xuemo.kill_npc,"��ڤ֮��") then
			xuemo.kill_npc=string.gsub(xuemo.kill_npc,"|��ڤ֮��","");
		end
	end;
	if name=="killymzy" then
		if string.find(xuemo.kill_npc,"��ڤ֮��") then
			xuemo.kill_npc=string.gsub(xuemo.kill_npc,"|��ڤ֮��","");
		end
	end;
	if name=="killklfs" then
		if string.find(xuemo.kill_npc,"���÷�ʦ") then
			xuemo.kill_npc=string.gsub(xuemo.kill_npc,"|���÷�ʦ","");
		end
	end;
	if name=="killklws" then
		if string.find(xuemo.kill_npc,"������ʿ") then
			xuemo.kill_npc=string.gsub(xuemo.kill_npc,"|������ʿ","");
		end
	end;
	Note(name.."����,killnpc="..xuemo.kill_npc)
end;
function xuemo_del_npc(name,b,str)
    if name=="killjs" then
		if string.find(xuemo.kill_npc,"��ʬ") then
			xuemo.kill_npc=string.gsub(xuemo.kill_npc,"|��ʬ","");	--"����|����|��ʬ"
		end
	end;
	if name=="killkl" then
		if string.find(xuemo.kill_npc,"����") and not (string.find(xuemo.kill_npc,"���÷�ʦ") or string.find(xuemo.kill_npc,"������ʿ"))then
			xuemo.kill_npc=string.gsub(xuemo.kill_npc,"|����","");
		end
	end;
	if name=="killyl" then
		if string.find(xuemo.kill_npc,"����") then
			xuemo.kill_npc=string.gsub(xuemo.kill_npc,"|����","");
		end
	end;
	if name=="killss" then
		if string.find(xuemo.kill_npc,"ʬɷ") then
			xuemo.kill_npc=string.gsub(xuemo.kill_npc,"|ʬɷ","");     --"������ʿ|���÷�ʦ|��ڤ֮��|��ڤ֮��|Ѫ��ʬ|ʬɷ"
		end
	end;
    if name=="killxjs" then
		if string.find(xuemo.kill_npc,"Ѫ��ʬ") then
			xuemo.kill_npc=string.gsub(xuemo.kill_npc,"|Ѫ��ʬ","");
		end
	end;
	if name=="killymzh" then
		if string.find(xuemo.kill_npc,"��ڤ֮��") then
			xuemo.kill_npc=string.gsub(xuemo.kill_npc,"|��ڤ֮��","");
		end
	end;
	if name=="killymzy" then
		if string.find(xuemo.kill_npc,"��ڤ֮��") then
			xuemo.kill_npc=string.gsub(xuemo.kill_npc,"|��ڤ֮��","");
		end
	end;
	if name=="killklfs" then
		if string.find(xuemo.kill_npc,"���÷�ʦ") then
			xuemo.kill_npc=string.gsub(xuemo.kill_npc,"|���÷�ʦ","");
		end
	end;
	if name=="killklws" then
		if string.find(xuemo.kill_npc,"������ʿ") then
			xuemo.kill_npc=string.gsub(xuemo.kill_npc,"|������ʿ","");
		end
	end;
	Note(name.."����,killnpc="..xuemo.kill_npc)
end;
--------------------Ѫħר�ý���---------------------
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
		logwin:ColourNote ("yellow","white",os.date("%Y-%m-%d %H:%M:%S",os.time()).." "..CharInfo.info.id.." ����cd ǰ����̨!")
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
			logwin:ColourNote ("red","white",os.date("%Y-%m-%d %H:%M:%S",os.time()).." "..CharInfo.info.id.." ������ҩ")
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
function trim(str)
	return string.gsub(str, "%s+", "")
end
function crashdump()
	local lin,text,path
	text=""
	path=mclpath..CharInfo.info.id
	print(path)
	logwin:ColourNote ("red","white",os.date("%Y-%m-%d %H:%M:%S",os.time()).." "..CharInfo.info.id.." �����쳣��dump log��")
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
			logwin:ColourNote ("white","",os.date("%Y-%m-%d %H:%M:%S",os.time()).." "..CharInfo.info.id.." ����δע��sk:"..wildcards[argidx])
			return
		end
		if #sklist==0 then       --��������б�full��� �ж��ǲ�������maxexp ��ֵ
			if var.upexp>0 then  
				var.maxexp=var.maxexp+var.upexp
				logwin:ColourNote ("white","",os.date("%Y-%m-%d %H:%M:%S",os.time()).." "..CharInfo.info.id.." maxexp��ֵ�ſ�"..var.upexp.." maxexp����Ϊ:"..var.maxexp)
				sklist=split(var.list_skill,",")
			end
			return
		end
		for i,v in ipairs(sklist) do
			if v == skdata[wildcards[argidx]] and CharInfo.info.exp+50000 >var.maxexp then
				table.remove(sklist, i)
				if #sklist==0 then       --��������б�full��� �ж��ǲ�������maxexp ��ֵ
					if var.upexp>0 then  
						var.maxexp=var.maxexp+var.upexp
						logwin:ColourNote ("white","",os.date("%Y-%m-%d %H:%M:%S",os.time()).." "..CharInfo.info.id.." maxexp��ֵ�ſ�"..var.upexp)
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
		logwin:ColourNote ("red","",os.date("%Y-%m-%d %H:%M:%S",os.time()).." "..CharInfo.info.id.." �ɹ����һ��bug��")
--		if Questinfo.bugcount% 10 ==0 then
--			Send("bug transfer 1 to idler ")
--		end
	end
	if name=="bugfailed" then
		Questinfo.bugfailed=Questinfo.bugfailed+1
		logwin:ColourNote ("red","",os.date("%Y-%m-%d %H:%M:%S",os.time()).." "..CharInfo.info.id.." �Ե�һ�Ź�������")
	end
	if name == "poison" then
		CharInfo.info.poison = true
		logwin:ColourNote ("blue","white",os.date("%Y-%m-%d %H:%M:%S",os.time()).." "..CharInfo.info.id.." �ж�")
	end
	if name == "danger" or  name == "danger1" then
		if var.wstfull~="yes" and wstnow then
			return
		end
		Execute("eat "..var.fullitem)
		logwin:ColourNote ("red","white",os.date("%Y-%m-%d %H:%M:%S",os.time()).." "..CharInfo.info.id.." ������ҩ")
	end
	if name=="hungry" then
		CharInfo.info.hungry=true
	end
	if name=="mefaint" then
		wait.clearall()
		logwin:ColourNote ("red","white",os.date("%Y-%m-%d %H:%M:%S",os.time()).." "..CharInfo.info.id.." �����ε�")
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
		logwin:ColourNote ("red","white",os.date("%Y-%m-%d %H:%M:%S",os.time()).." "..CharInfo.info.id.." ����")
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
		if wildcards[2]=="������" then
			Questinfo.killer.id=CharInfo.info.id.."'s heiyi ren"
		elseif wildcards[2]=="а�ɸ���" then
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
function checkfight()
	Send("come")
	local ll=wait.regexp("(��Ҫ��ʲôҰ�޸����㣿|һ�ߴ��һ��ѱ�ޣ������ǻ����ˣ�)",2)
	ll=ll or ""
	if string.find(ll,"���") then
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
		ll, ww=wait.regexp("��(���ڲ�æ|����.*ͣ������|�������һԾ|������ת|һ������|������æ��)",10)
		ll=ll or ""
		--Note(ll)
		if string.find(ll, "��æ")  or string.find(ll,"������ת") then
			return true
		elseif string.find(ll,"�������һԾ") then
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
			if sec==99 and string.find(ll,"ͣ������") then
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
			--print("npc��:"..tostring(#npc))
			if #npc>0 then
				for k,v in ipairs(npc) do
					if k>0 then
						if v.id==i then
							npcidx=npcidx+1
						end
					end
				end
			end
			if string.find(s,"Ĺ԰���") then 
				crashdump()
				logwin:ColourNote("red","white",os.date("%Y-%m-%d %H:%M:%S",os.time()).." "..CharInfo.info.id.." ����ʧ��:"..Questinfo.Questname)
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
	 ll,ww=wait.regexp("(�����|�����|����û�������|�����ں��˼�����������|����һ������û�����|�����һ�㣬�ǲ����ǻ���|�㿴�˿��ε��ڵ�|������û������ս���ˡ�)",30)
	 ll=ll or ""
	 if string.find(ll,"�ȵ�") or string.find(ll,"�ε�") then
		Sendcmd(var.pfm_all)
		wait.time(1)
	 elseif string.find(ll,"���ں��˼�") then
		Sendcmd(var.pfm_all)
		wait.time(1)
	 elseif string.find(ll,"û�����") then
		Sendcmd(var.pfm_all)
		wait.time(1)
	elseif string.find(ll,"û������") then
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
		ll=wait.regexp("^[> ]*(��Ҫ�ƿ�˭|�㿴�˿�|��������û��֪��|�˼��������ڴ����)",2)
		ll=ll or ""
		print(ll)
		if string.find(ll,"��Ҫ�ƿ�˭") then
			return true
		elseif string.find(ll,"��������û��֪��") then
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
	Note("��ʼ׷ɱ:"..xuemo.kill_npc)
	MyMaze.path=""
	for i=1,64 do
        MyMaze.flag[i]=0;
    end;
	maze_search(MyMaze.loc)
	repeat
		--print(MyMaze.path)
		num=string.len(MyMaze.path)
		pat=string.sub(MyMaze.path,1,1)
		print("��ǰloc:"..MyMaze.loc)
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
				print("�������ĵ�ֱ�ӵ�:"..MyMaze.loc)
				Send(patnext)
				print("��ǰpath:"..MyMaze.path)
				MyMaze.path=string.sub(MyMaze.path,3,num)
				print("ʣ��path:"..MyMaze.path)
			end
		end
		Send("set no_teach 1")
		aa,bb=wait.regexp("(\\(����\\)\\s+\("..xuemo.kill_npc..")\\(\(.*\)\\)|�趨����������no_teach = 1)",4)
		aa=aa or ""
		if string.find(aa,"����") then	
			wait.regexp("^(> )*(������.*��ɱ����|.*����һ����|.*һ��Ƴ����|.*������һ�����|.*����������)",2)
				CharInfo.disevent="mequest"
				disconserver()
				loopkill(bb[3])
				kill_npc(bb[3])       
				no_busy()
				Sendcmd("mtc0;yun refresh")
		end
		print(xuemo.kill_npc)
		if xuemo.kill_npc=="Ŀ��"  or not quest_ok then
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
		if wildcards[2] == "����" then
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
		print("��ǰ����:"..CharInfo.info.Martial)
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
	print("skid:"..skid)
	print("ʣ�༼���б�:"..table.concat(sklist,","))
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
				wait.regexp("^[> ]*��һ��������ֻ���������档�ûһ���ˡ�",30)
			end
			Note("fullsleep thread test")
		end
		if (os.time()-Questinfo.Recordtime)>=waittime then 
			return 
		end
		wait.time(1.5)
		Sendcmd("hp;set no_teach fullsk")
		local ll,ww=wait.regexp("^[> ]*�趨����������no_teach",5)
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
				wait.regexp("^[> ]*��һ��������ֻ���������档�ûһ���ˡ�",30)
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
		local ll,ww=wait.regexp("^[> ]*�趨����������no_teach",5)
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
		local ll,ww=wait.regexp("^[> ]*�趨����������no_teach",5)
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
				wait.regexp("^[> ]*��һ��������ֻ���������档�ûһ���ˡ�",30)
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

function checkbag()
	local ll,ww,itemnum,i,name
	bag={}
	Execute("i;set no_teach over")
	ll=wait.regexp("^[> ]*�����ϴ���������Щ����",5)
	ll=ll or ""
	print(ll)
	if string.find(ll,"���ϴ�������") then
		while true do
			ll,ww=wait.regexp("^(.{2}(.*)\\((.*)\\)|.*�趨����������no_teach = \"over\")",1)
			ll=ll or ""
			if not string.find(ll,"�趨��������") and ll~="" then
				print(ww[2])
				if string.find(ww[2],"��") then
					itemnum=ctonum(string.sub(ww[2],1,string.find(ww[2],"��")-1))
					name=string.sub(ww[2],string.find(ww[2],"��")+2,string.len(ww[2]))
				elseif string.find(ww[2],"��") then
					itemnum=ctonum(string.sub(ww[2],1,string.find(ww[2],"��")-1))
					name=string.sub(ww[2],string.find(ww[2],"��")+2,string.len(ww[2]))
				elseif string.find(ww[2],"��") then
					itemnum=ctonum(string.sub(ww[2],1,string.find(ww[2],"��")-1))
					name=string.sub(ww[2],string.find(ww[2],"��")+2,string.len(ww[2]))
				elseif string.find(ww[2],"��") then
					itemnum=ctonum(string.sub(ww[2],1,string.find(ww[2],"��")-1))
					name=string.sub(ww[2],string.find(ww[2],"��")+2,string.len(ww[2]))
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