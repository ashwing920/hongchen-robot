addxml.trigger {
	enabled='y',
	temporary='y',
	group="xmkilled",
	expand_variables="y",
	match="^[> ]*���� ����: 10/10 ��",
	name="killghost",
	script="xuemo_finishfinal",
}
addxml.trigger {
	enabled='y',
	temporary='y',
	group="xmkilled",
	expand_variables="y",
	match="^[> ]*��һ: 1/1",
	name="killding",
	script="ding_die",
}
addxml.trigger {
	enabled='y',
	temporary='y',
	group="xmkilled",
	expand_variables="y",
	match="^[> ]*ɱ�� ��ʬ: 8/8��",
	name="killjs",
	script="xuemo_del_npc",
}
addxml.trigger {
	enabled='y',
	temporary='y',
	group="xmkilled",
	expand_variables="y",
	match="^[> ]*ɱ�� ʬɷ: 3/3��",
	name="killss",
	script="xuemo_del_npc",
}
addxml.trigger {
	enabled='y',
	temporary='y',
	group="xmkilled",
	expand_variables="y",
	match="^[> ]*ɱ�� Ѫ��ʬ: 3/3��",
	name="killxjs",
	script="xuemo_del_npc",
}
addxml.trigger {
	enabled='y',
	temporary='y',
	group="xmkilled",
	expand_variables="y",
	match="^[> ]*ɱ�� ����: 8/8��",
	name="killyl",
	script="xuemo_del_npc",
}
addxml.trigger {
	enabled='y',
	temporary='y',
	group="xmkilled",
	expand_variables="y",
	match="^[> ]*ɱ�� ��ڤ֮��: 3/3��",
	name="killymzh",
	script="xuemo_del_npc",
}
addxml.trigger {
	enabled='y',
	temporary='y',
	group="xmkilled",
	expand_variables="y",
	match="^[> ]*ɱ�� ��ڤ֮��: 3/3��",
	name="killymzy",
	script="xuemo_del_npc",
}
addxml.trigger {
	enabled='y',
	temporary='y',
	group="xmkilled",
	expand_variables="y",
	match="^[> ]*ɱ�� ����: 8/8��",
	name="killkl",
	script="xuemo_del_npc",
}
addxml.trigger {
	enabled='y',
	temporary='y',
	group="xmkilled",
	expand_variables="y",
	match="^[> ]*ɱ�� ���÷�ʦ: 3/3��",
	name="killklfs",
	script="xuemo_del_npc",
}
addxml.trigger {
	enabled='y',
	temporary='y',
	group="xmkilled",
	expand_variables="y",
	match="^[> ]*ɱ�� ������ʿ: 3/3��",
	name="killklws",
	script="xuemo_del_npc",
}
ColourNote ("Green","black", "ģ��-Ѫħ����.���سɹ�...")
function QuestXuemo()
	local ll,ww
	quest_ok=true
	dingdie=false
	final_questfinish=false
	SetTimerOption ("watchdog", "minute", "20")
	EnableTimer("watchdog", true)
	ResetTimer("watchdog")
	if not callpet() then
		print("�������Լ��ĳ���!@!!!")
		return false
	end
	if (os.time()-CharInfo.info.fbtime)< 110 then
		fangqiexp()
	end
	if CharInfo.info.pot>500 and not CharInfo.info.poison and var.fullsk== "yes" and (os.time()-CharInfo.info.fbtime)< 100 then
		Sendcmd(var.safehouse)
		xuemofullsk()
		no_busy()
	end
	Sendcmd("ww;rideto gc;n;n;w;w;w;n;xia")
	Sendcmd("mtc0;yun refresh;exert regenerate;exert recover")
	Send("enter door")
	local ll,ww=wait.regexp("(Ĺ԰���$|Ϊ�˽�����ϷCPU����|�㻹��Ҫ��)",5)
	ll=ll or ""
	while string.find(ll,"��Ϸ") or string.find(ll,"��Ҫ") do
		print("fbtime:"..tostring(os.time()-CharInfo.info.fbtime))
		Send("jiqu")
		wait.time(5)
		Sendcmd("halt;enter door")
		ll,ww=wait.regexp("(Ĺ԰���$|Ϊ�˽�����ϷCPU����|�㻹��Ҫ��)",5)
		ll=ll or ""
	end
	Questinfo.Recordtime=os.time()
	Send("s")
	maze_format()
	Send("n")
	while true and quest_ok do
		no_busy()
		Send("jiqu")
		Send("mazequest")
		ll,ww=wait.regexp("^[> ]*(��Ŀǰ��û����ȡ�κθ�������|�㵱ǰ�ص�û�п�����ʾ�ĸ�������|��������: \(.*\))",5)
		ll=ll or ""
		if string.find(ll,"û����ȡ�κ�") then
			Send("push coffin")
			ll=wait.regexp("^[> ]*(��һ����������˵������λ.*��������һ����\\(answer yes/no\\)|���ƿ��˹ײģ���������ʲô��û�С�)",3)
			ll=ll or ""		
			Send("answer yes")
			wait.regexp("^[> ]*��һ˵�������Ը������ǶԸ�Ѫħ��\\(accept yes/no\\)",20)
			repeat
				Sendcmd("accept yes")
				ll,ww=wait.regexp("^[> ]*��һ˵������......��л",2)
			until ll~=nil
			wait.regexp("^[> ]*��һ˵������ɺ���������\\(report\\)��",15)
			repeat
				Sendcmd("mazequest")
				ll,ww=wait.regexp("^[> ]*��������",1)
			until ll~=nil
		elseif string.find(ll,"��������") and ww[2]=="֤���ҳ�" then   --��һ�׶�����
				xuemo.kill_npc="Ŀ��|����|����|��ʬ"
				Questinfo.Questname="Ѫħ�׶�1: ֤���ҳ�"
				Send("halt")
				Send("s")
				for i=1,3 do
					maze_walkto(xuemo.record[i],0)
					wait.regexp("^(> )*(������(��ʬ��|����|��ڤħ)��ɱ����|.*����һ����|.*һ��Ƴ����|.*������һ�����|.*����������)",2)
					CharInfo.disevent="mequest"
					disconserver()
					print("dis")
					no_busy()
					if xuemo.record[i]==8 then
						xuemo.lingtang=xuemo.record[i]
						Note("��������:"..xuemo.record[i])
						loopkill("ghost")
						kill_npc("ghost")
						no_busy()
						Sendcmd("mtc0;yun refresh")
					elseif  xuemo.record[i]==64 then
						xuemo.kugukeng=xuemo.record[i]
						Note("�ݹǿ�:"..xuemo.record[i])
						loopkill("skeleton")
						kill_npc("skeleton")
						no_busy()
						Sendcmd("mtc0;yun refresh")
					elseif  xuemo.record[i]==1 then
						xuemo.luanfengang=xuemo.record[i]
						Note("�ҷظ�:"..xuemo.record[i])
						loopkill("zombie")
						kill_npc("zombie")
						no_busy()
						Sendcmd("mtc0;yun refresh")
					else
						Note("***************������2**************")
					return 
				end
			end		
			while xuemo.kill_npc~="Ŀ��" and quest_ok do
				print("׷ɱ:"..xuemo.kill_npc)
				kill_search()
			end	
			no_busy()
			Sendcmd("mtc0;yun refresh;exert regenerate;exert recover")
			maze_walkto(99,1)
			Sendcmd("n;report;jiqu")
			ll,ww=wait.regexp("^[> ]*��һ˵������ɺ���������\\(report\\)��",25)
			if ll==nil then
				Note("**************������3**********************")
				maze_format() 
			else
				repeat
					Sendcmd("mazequest")
					ll,ww=wait.regexp("^[> ]*��������: ֤��ʵ��",1)
				until ll~=nil
			end
		elseif string.find(ll,"��������") and ww[2]=="֤��ʵ��" then   --�ڶ��׶�����
				Send("halt")
				Send("s")
				xuemo.kill_npc="Ŀ��|������ʿ|���÷�ʦ|��ڤ֮��|��ڤ֮��|Ѫ��ʬ|ʬɷ"
				Questinfo.Questname="Ѫħ�׶�2: ֤��ʵ��"
				for i=1,3 do
					maze_walkto(xuemo.record[i],0)
					wait.regexp("^(> )*(������(��ʬ��|����|��ڤħ)��ɱ����|.*����һ����|.*һ��Ƴ����|.*������һ�����|.*����������)",2)
					CharInfo.disevent="mequest"
					disconserver()
					print("dis")
					no_busy()
					if xuemo.record[i]==8 then
						xuemo.lingtang=xuemo.record[i]
						Note("��������:"..xuemo.record[i])
						loopkill("ghost fire")
						kill_npc("ghost fire")
						no_busy()
						Sendcmd("mtc0;yun refresh")
						loopkill("ghost eye")
						kill_npc("ghost eye")
						no_busy()
						Sendcmd("mtc0;yun refresh")
					elseif  xuemo.record[i]==64 then
						xuemo.kugukeng=xuemo.record[i]
						Note("�ݹǿ�:"..xuemo.record[i])
						loopkill("skeleton mage")
						kill_npc("skeleton mage")
						no_busy()
						Sendcmd("mtc0;yun refresh")
						loopkill("skeleton fighter")
						kill_npc("skeleton fighter")
						no_busy()
						Sendcmd("mtc0;yun refresh")
					elseif  xuemo.record[i]==1 then
						xuemo.luanfengang=xuemo.record[i]
						Note("�ҷظ�:"..xuemo.record[i])
						loopkill("blood zombie")
						kill_npc("blood zombie")
						no_busy()
						Sendcmd("mtc0;yun refresh")
						loopkill("power zombie")
						kill_npc("power zombie")
						no_busy()
						Sendcmd("mtc0;yun refresh")
					else
						Note("***************������2**************")
					return 
				end
			end		
			while xuemo.kill_npc~="Ŀ��" and quest_ok do
				print("׷ɱ:"..xuemo.kill_npc)
				kill_search()
			end	
			no_busy()
			Sendcmd("mtc0;yun refresh;exert regenerate;exert recover")
			maze_walkto(99,1)
			Sendcmd("n;report;jiqu")
			ll,ww=wait.regexp("^[> ]*��һ˵������ɺ���������\\(report\\)��",25)
			if ll==nil then
				Note("**************������3**********************")
				return 
			end
			repeat
				Sendcmd("mazequest")
				ll,ww=wait.regexp("^[> ]*��������: �ų��켺",1)
			until ll~=nil
			print(ll)
		elseif string.find(ll,"��������") and ww[2]=="�ų��켺" then   --�����׶�����
			Send("halt")
			Send("s")
			Questinfo.Questname="Ѫħ�׶�3: �ų��켺"
			xuemo.kill_npc="Ŀ��|����"
			maze_walkto(57,1)
			Sendcmd("hp;push coffin")
			wait.regexp("^[> ]*����̾�˿����������Ǳ������ˡ�",2)
			kill_boss("xin wu","����")
			no_busy()
			Sendcmd("mtc0;yun refresh")
			wait.time(1)
			Send("get spirit tower")
			maze_walkto(99,1)
			Sendcmd("n;give spirit tower to ding yi;report;jiqu")
			ll,ww=wait.regexp("^[> ]*��һ˵������ɺ���������\\(report\\)��",25)
			if ll==nil then
				Note("**************������5**********************")
				return 
			end
			repeat
				Sendcmd("mazequest")
				ll,ww=wait.regexp("^[> ]*��������: Ѱ�ҷ���",1)
			until ll~=nil	
		elseif string.find(ll,"��������") and ww[2]=="Ѱ�ҷ���" then   --���Ľ׶�����
			Send("halt")
			Send("s")
			Questinfo.Questname="Ѫħ�׶�4: Ѱ�ҷ���"
			xuemo.kill_npc="Ŀ��|����|��ڤħ|��ʬ��"
			Sendcmd(var.yunpower)
			maze_walkto(29,0)
			wait.regexp("^(> )*(������.*��ɱ����|.*����һ����|.*һ��Ƴ����|.*������һ�����|.*����������)",2)
			CharInfo.disevent="mequest"
			disconserver()
			no_busy()
			kill_boss("skeleton lich","����")
			no_busy()
			kill_boss("ghost devil","��ڤħ")
			no_busy()
			kill_boss("lord zombie","��ʬ��")
			kill_npc("ghost fire")
			Sendcmd("get ghost fire;get bone staff;get zombie blood")
			no_busy()
			maze_walkto(99,1)
			Sendcmd("n;hp;give ghost fire to ding yi;give bone staff to ding yi;give zombie blood to ding yi;report;jiqu")
			ll,ww=wait.regexp("^[> ]*��һ˵��������������ܻ���ЩѪħ������......���ǰ���·�ɣ�",25)
			if ll==nil then
				Note("**************������6**********************")
				return
			end
			repeat
				Sendcmd("mazequest")
				ll,ww=wait.regexp("^[> ]*��������: ������",1)
			until ll~=nil
		elseif string.find(ll,"��������") and ww[2]=="������" then   --����׶�����
			Questinfo.Questname="Ѫħ�׶�5: ������"
			xuemo.kill_npc="Ŀ��|���з���npc"
			Send("halt")
			repeat
				Send("s")
				ll,ww=wait.regexp("��һ.*���˹���",1)
				Send("n")
			until ll~=nil
			Send("s")
			maze_walkto(29,1)
			repeat                           --444
				Sendcmd("mtc0;yun refresh;"..var.yunpower..";jiqu;l")
				ll,ww=wait.regexp("\\(����\\)\\s+\(.*\)\\(\(.*\)\\)",2)
				if ll~=nil then
					Send("halt")
					kill_npc(ww[2])
				end		                         
				Execute("jiali max;#9 report")                                          
				ll,ww=wait.regexp("^[> ]*(��һ˵��������ʩ���ڼ䣬���кܶ�����|��ί����˵��)",40)
				ll=ll or ""
			until string.find(ll,"��һ˵") and quest_ok		
			Questinfo.Questname="Ѫħ�׶�6: ���׶�"
			xuemo.kill_npc="Ŀ��|�����ٻ���"
			final_questfinish=false
			EnableTriggerGroup("give",false)
			EnableTriggerGroup("killnpc",true)
			while not final_questfinish and quest_ok do
				Sendcmd("mtc0;yun refresh;jiqu")
				ll=wait.regexp("(^[> ]*�������Ϲ⻪һ����һ�����鱻���˹�����|��һ˵�����ɰ��ڴ�һ�٣�|Ʈ�˹���|������.*��ɱ����|.*����һ����|.*һ��Ƴ����|.*������һ�����|.*����������)",1)
				ll=ll or ""
				if string.find(ll,"��һ") then
					EnableTriggerGroup("killnpc",false)
					break
				end
				kill_boss("skeleton lich","����")
				npc={}
				Sendcmd("id here;set no_teach 9")
				wait.regexp("^(> )*�趨����������no_teach = 9",0.5)
				if #npc>0 then
					Send("halt")
					Sendcmd(var.pfm_all)
					CharInfo.disevent="mequest"
					disconserver()
					no_busy(99)
				end
			end
			Questinfo.Questname="Ѫħ�׶�7: �ս�Ѫħ"
			xuemo.kill_npc="Ŀ��|��һ"
			while true and quest_ok do
				ll=wait.regexp("^[> ]*(��һ˵����������|��������һ��ɱ����)",1)
				ll=ll or ""
				if string.find(ll,"��һ")  then
					kill_boss("ding yi","��һ")
					break----
				end
			end
			--kill_boss("skeleton lich","����")
			no_busy()
			Send("jiqu")
			EnableTriggerGroup("give",false)
			EnableTriggerGroup("killnpc",false)
			repeat
				Sendcmd("mazequest")
				ll,ww=wait.regexp("^[> ]*��������: �ս�Ѫħ",1)
			until ll~=nil
			no_busy()
			Questinfo.Questname="Ѫħ���"
			Questinfo.count=Questinfo.count+1
			if dingdie then
				Questinfo.continuous=Questinfo.continuous+1
			end
			callpet()
			CharInfo.info.fbtime=os.time()
			Questinfo.Recordtime=os.time()-Questinfo.Recordtime
			logwin:ColourNote("yellow","",os.date("%Y-%m-%d %H:%M:%S",os.time()).." "..CharInfo.info.id.." ���ּ�ʱ:"..Questinfo.Recordtime)
			Sendcmd("cha martial-cognize;hp")
			no_busy()
			callpet()
			Sendcmd("rideto suzhou")
			break
		elseif string.find(ll,"�㵱ǰ�ص�û�п�����ʾ�ĸ�������") then
			logwin:ColourNote("red","white",os.date("%Y-%m-%d %H:%M:%S",os.time()).." "..CharInfo.info.id.." ����ʧ��:"..Questinfo.Questname)
			CharInfo.info.fbtime=os.time()
			crashdump()
			return test()
		else
			logwin:ColourNote("red","white",os.date("%Y-%m-%d %H:%M:%S",os.time()).." "..CharInfo.info.id.." ����ʧ��1:"..Questinfo.Questname)
			logwin:ColourNote("red","white",os.date("%Y-%m-%d %H:%M:%S",os.time()).." "..CharInfo.info.id.." ����ll:"..ll)
			CharInfo.info.fbtime=os.time()
			return test()
		end
		print("xuemo over?")
	end
end
