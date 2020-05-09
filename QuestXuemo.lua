addxml.trigger {
	enabled='y',
	temporary='y',
	group="xmkilled",
	expand_variables="y",
	match="^[> ]*超度 亡灵: 10/10 。",
	name="killghost",
	script="xuemo_finishfinal",
}
addxml.trigger {
	enabled='y',
	temporary='y',
	group="xmkilled",
	expand_variables="y",
	match="^[> ]*丁一: 1/1",
	name="killding",
	script="ding_die",
}
addxml.trigger {
	enabled='y',
	temporary='y',
	group="xmkilled",
	expand_variables="y",
	match="^[> ]*杀死 僵尸: 8/8。",
	name="killjs",
	script="xuemo_del_npc",
}
addxml.trigger {
	enabled='y',
	temporary='y',
	group="xmkilled",
	expand_variables="y",
	match="^[> ]*杀死 尸煞: 3/3。",
	name="killss",
	script="xuemo_del_npc",
}
addxml.trigger {
	enabled='y',
	temporary='y',
	group="xmkilled",
	expand_variables="y",
	match="^[> ]*杀死 血僵尸: 3/3。",
	name="killxjs",
	script="xuemo_del_npc",
}
addxml.trigger {
	enabled='y',
	temporary='y',
	group="xmkilled",
	expand_variables="y",
	match="^[> ]*杀死 幽灵: 8/8。",
	name="killyl",
	script="xuemo_del_npc",
}
addxml.trigger {
	enabled='y',
	temporary='y',
	group="xmkilled",
	expand_variables="y",
	match="^[> ]*杀死 幽冥之火: 3/3。",
	name="killymzh",
	script="xuemo_del_npc",
}
addxml.trigger {
	enabled='y',
	temporary='y',
	group="xmkilled",
	expand_variables="y",
	match="^[> ]*杀死 幽冥之眼: 3/3。",
	name="killymzy",
	script="xuemo_del_npc",
}
addxml.trigger {
	enabled='y',
	temporary='y',
	group="xmkilled",
	expand_variables="y",
	match="^[> ]*杀死 骷髅: 8/8。",
	name="killkl",
	script="xuemo_del_npc",
}
addxml.trigger {
	enabled='y',
	temporary='y',
	group="xmkilled",
	expand_variables="y",
	match="^[> ]*杀死 骷髅法师: 3/3。",
	name="killklfs",
	script="xuemo_del_npc",
}
addxml.trigger {
	enabled='y',
	temporary='y',
	group="xmkilled",
	expand_variables="y",
	match="^[> ]*杀死 骷髅武士: 3/3。",
	name="killklws",
	script="xuemo_del_npc",
}
ColourNote ("Green","black", "模块-血魔任务.加载成功...")
function QuestXuemo()
	local ll,ww
	quest_ok=true
	dingdie=false
	final_questfinish=false
	SetTimerOption ("watchdog", "minute", "20")
	EnableTimer("watchdog", true)
	ResetTimer("watchdog")
	if not callpet() then
		print("必须有自己的宠物!@!!!")
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
	local ll,ww=wait.regexp("(墓园入口$|为了降低游戏CPU负担|你还需要等)",5)
	ll=ll or ""
	while string.find(ll,"游戏") or string.find(ll,"需要") do
		print("fbtime:"..tostring(os.time()-CharInfo.info.fbtime))
		Send("jiqu")
		wait.time(5)
		Sendcmd("halt;enter door")
		ll,ww=wait.regexp("(墓园入口$|为了降低游戏CPU负担|你还需要等)",5)
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
		ll,ww=wait.regexp("^[> ]*(你目前还没有领取任何副本任务|你当前地点没有可以显示的副本任务|任务名称: \(.*\))",5)
		ll=ll or ""
		if string.find(ll,"没有领取任何") then
			Send("push coffin")
			ll=wait.regexp("^[> ]*(丁一有气无力地说道：这位.*，能听我一言吗？\\(answer yes/no\\)|你推开了棺材，但是里面什么都没有。)",3)
			ll=ll or ""		
			Send("answer yes")
			wait.regexp("^[> ]*丁一说道：你可愿意帮我们对付血魔？\\(accept yes/no\\)",20)
			repeat
				Sendcmd("accept yes")
				ll,ww=wait.regexp("^[> ]*丁一说道：嗯......多谢",2)
			until ll~=nil
			wait.regexp("^[> ]*丁一说道：完成后再来找我\\(report\\)。",15)
			repeat
				Sendcmd("mazequest")
				ll,ww=wait.regexp("^[> ]*任务名称",1)
			until ll~=nil
		elseif string.find(ll,"任务名称") and ww[2]=="证明忠诚" then   --第一阶段任务
				xuemo.kill_npc="目标|骷髅|幽灵|僵尸"
				Questinfo.Questname="血魔阶段1: 证明忠诚"
				Send("halt")
				Send("s")
				for i=1,3 do
					maze_walkto(xuemo.record[i],0)
					wait.regexp("^(> )*(看起来(僵尸王|巫妖|幽冥魔)想杀死你|.*和你一碰面|.*一眼瞥见你|.*对著你一声大喝|.*和你仇人相见)",2)
					CharInfo.disevent="mequest"
					disconserver()
					print("dis")
					no_busy()
					if xuemo.record[i]==8 then
						xuemo.lingtang=xuemo.record[i]
						Note("残破灵堂:"..xuemo.record[i])
						loopkill("ghost")
						kill_npc("ghost")
						no_busy()
						Sendcmd("mtc0;yun refresh")
					elseif  xuemo.record[i]==64 then
						xuemo.kugukeng=xuemo.record[i]
						Note("枯骨坑:"..xuemo.record[i])
						loopkill("skeleton")
						kill_npc("skeleton")
						no_busy()
						Sendcmd("mtc0;yun refresh")
					elseif  xuemo.record[i]==1 then
						xuemo.luanfengang=xuemo.record[i]
						Note("乱坟岗:"..xuemo.record[i])
						loopkill("zombie")
						kill_npc("zombie")
						no_busy()
						Sendcmd("mtc0;yun refresh")
					else
						Note("***************出错了2**************")
					return 
				end
			end		
			while xuemo.kill_npc~="目标" and quest_ok do
				print("追杀:"..xuemo.kill_npc)
				kill_search()
			end	
			no_busy()
			Sendcmd("mtc0;yun refresh;exert regenerate;exert recover")
			maze_walkto(99,1)
			Sendcmd("n;report;jiqu")
			ll,ww=wait.regexp("^[> ]*丁一说道：完成后再来找我\\(report\\)。",25)
			if ll==nil then
				Note("**************出错了3**********************")
				maze_format() 
			else
				repeat
					Sendcmd("mazequest")
					ll,ww=wait.regexp("^[> ]*任务名称: 证明实力",1)
				until ll~=nil
			end
		elseif string.find(ll,"任务名称") and ww[2]=="证明实力" then   --第二阶段任务
				Send("halt")
				Send("s")
				xuemo.kill_npc="目标|骷髅武士|骷髅法师|幽冥之眼|幽冥之火|血僵尸|尸煞"
				Questinfo.Questname="血魔阶段2: 证明实力"
				for i=1,3 do
					maze_walkto(xuemo.record[i],0)
					wait.regexp("^(> )*(看起来(僵尸王|巫妖|幽冥魔)想杀死你|.*和你一碰面|.*一眼瞥见你|.*对著你一声大喝|.*和你仇人相见)",2)
					CharInfo.disevent="mequest"
					disconserver()
					print("dis")
					no_busy()
					if xuemo.record[i]==8 then
						xuemo.lingtang=xuemo.record[i]
						Note("残破灵堂:"..xuemo.record[i])
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
						Note("枯骨坑:"..xuemo.record[i])
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
						Note("乱坟岗:"..xuemo.record[i])
						loopkill("blood zombie")
						kill_npc("blood zombie")
						no_busy()
						Sendcmd("mtc0;yun refresh")
						loopkill("power zombie")
						kill_npc("power zombie")
						no_busy()
						Sendcmd("mtc0;yun refresh")
					else
						Note("***************出错了2**************")
					return 
				end
			end		
			while xuemo.kill_npc~="目标" and quest_ok do
				print("追杀:"..xuemo.kill_npc)
				kill_search()
			end	
			no_busy()
			Sendcmd("mtc0;yun refresh;exert regenerate;exert recover")
			maze_walkto(99,1)
			Sendcmd("n;report;jiqu")
			ll,ww=wait.regexp("^[> ]*丁一说道：完成后再来找我\\(report\\)。",25)
			if ll==nil then
				Note("**************出错了3**********************")
				return 
			end
			repeat
				Sendcmd("mazequest")
				ll,ww=wait.regexp("^[> ]*任务名称: 排除异己",1)
			until ll~=nil
			print(ll)
		elseif string.find(ll,"任务名称") and ww[2]=="排除异己" then   --第三阶段任务
			Send("halt")
			Send("s")
			Questinfo.Questname="血魔阶段3: 排除异己"
			xuemo.kill_npc="目标|心武"
			maze_walkto(57,1)
			Sendcmd("hp;push coffin")
			wait.regexp("^[> ]*心武叹了口气道：还是被找着了。",2)
			kill_boss("xin wu","心武")
			no_busy()
			Sendcmd("mtc0;yun refresh")
			wait.time(1)
			Send("get spirit tower")
			maze_walkto(99,1)
			Sendcmd("n;give spirit tower to ding yi;report;jiqu")
			ll,ww=wait.regexp("^[> ]*丁一说道：完成后再来找我\\(report\\)。",25)
			if ll==nil then
				Note("**************出错了5**********************")
				return 
			end
			repeat
				Sendcmd("mazequest")
				ll,ww=wait.regexp("^[> ]*任务名称: 寻找法引",1)
			until ll~=nil	
		elseif string.find(ll,"任务名称") and ww[2]=="寻找法引" then   --第四阶段任务
			Send("halt")
			Send("s")
			Questinfo.Questname="血魔阶段4: 寻找法引"
			xuemo.kill_npc="目标|巫妖|幽冥魔|僵尸王"
			Sendcmd(var.yunpower)
			maze_walkto(29,0)
			wait.regexp("^(> )*(看起来.*想杀死你|.*和你一碰面|.*一眼瞥见你|.*对著你一声大喝|.*和你仇人相见)",2)
			CharInfo.disevent="mequest"
			disconserver()
			no_busy()
			kill_boss("skeleton lich","巫妖")
			no_busy()
			kill_boss("ghost devil","幽冥魔")
			no_busy()
			kill_boss("lord zombie","僵尸王")
			kill_npc("ghost fire")
			Sendcmd("get ghost fire;get bone staff;get zombie blood")
			no_busy()
			maze_walkto(99,1)
			Sendcmd("n;hp;give ghost fire to ding yi;give bone staff to ding yi;give zombie blood to ding yi;report;jiqu")
			ll,ww=wait.regexp("^[> ]*丁一说道：法阵那里可能还有些血魔的手下......你从前面带路吧！",25)
			if ll==nil then
				Note("**************出错了6**********************")
				return
			end
			repeat
				Sendcmd("mazequest")
				ll,ww=wait.regexp("^[> ]*任务名称: 清理法阵",1)
			until ll~=nil
		elseif string.find(ll,"任务名称") and ww[2]=="清理法阵" then   --第五阶段任务
			Questinfo.Questname="血魔阶段5: 清理法阵"
			xuemo.kill_npc="目标|所有法阵npc"
			Send("halt")
			repeat
				Send("s")
				ll,ww=wait.regexp("丁一.*走了过来",1)
				Send("n")
			until ll~=nil
			Send("s")
			maze_walkto(29,1)
			repeat                           --444
				Sendcmd("mtc0;yun refresh;"..var.yunpower..";jiqu;l")
				ll,ww=wait.regexp("\\(鬼气\\)\\s+\(.*\)\\(\(.*\)\\)",2)
				if ll~=nil then
					Send("halt")
					kill_npc(ww[2])
				end		                         
				Execute("jiali max;#9 report")                                          
				ll,ww=wait.regexp("^[> ]*(丁一说道：在我施法期间，会有很多亡灵|你委屈的说道)",40)
				ll=ll or ""
			until string.find(ll,"丁一说") and quest_ok		
			Questinfo.Questname="血魔阶段6: 最后阶段"
			xuemo.kill_npc="目标|所有召唤物"
			final_questfinish=false
			EnableTriggerGroup("give",false)
			EnableTriggerGroup("killnpc",true)
			while not final_questfinish and quest_ok do
				Sendcmd("mtc0;yun refresh;jiqu")
				ll=wait.regexp("(^[> ]*聚灵塔上光华一闪，一个鬼灵被吸了过来！|丁一说道：成败在此一举！|飘了过来|看起来.*想杀死你|.*和你一碰面|.*一眼瞥见你|.*对著你一声大喝|.*和你仇人相见)",1)
				ll=ll or ""
				if string.find(ll,"丁一") then
					EnableTriggerGroup("killnpc",false)
					break
				end
				kill_boss("skeleton lich","巫妖")
				npc={}
				Sendcmd("id here;set no_teach 9")
				wait.regexp("^(> )*设定环境变数：no_teach = 9",0.5)
				if #npc>0 then
					Send("halt")
					Sendcmd(var.pfm_all)
					CharInfo.disevent="mequest"
					disconserver()
					no_busy(99)
				end
			end
			Questinfo.Questname="血魔阶段7: 终结血魔"
			xuemo.kill_npc="目标|丁一"
			while true and quest_ok do
				ll=wait.regexp("^[> ]*(丁一说道：朋友们|看起来丁一想杀死你)",1)
				ll=ll or ""
				if string.find(ll,"丁一")  then
					kill_boss("ding yi","丁一")
					break----
				end
			end
			--kill_boss("skeleton lich","巫妖")
			no_busy()
			Send("jiqu")
			EnableTriggerGroup("give",false)
			EnableTriggerGroup("killnpc",false)
			repeat
				Sendcmd("mazequest")
				ll,ww=wait.regexp("^[> ]*任务名称: 终结血魔",1)
			until ll~=nil
			no_busy()
			Questinfo.Questname="血魔完成"
			Questinfo.count=Questinfo.count+1
			if dingdie then
				Questinfo.continuous=Questinfo.continuous+1
			end
			callpet()
			CharInfo.info.fbtime=os.time()
			Questinfo.Recordtime=os.time()-Questinfo.Recordtime
			logwin:ColourNote("yellow","",os.date("%Y-%m-%d %H:%M:%S",os.time()).." "..CharInfo.info.id.." 本轮计时:"..Questinfo.Recordtime)
			Sendcmd("cha martial-cognize;hp")
			no_busy()
			callpet()
			Sendcmd("rideto suzhou")
			break
		elseif string.find(ll,"你当前地点没有可以显示的副本任务") then
			logwin:ColourNote("red","white",os.date("%Y-%m-%d %H:%M:%S",os.time()).." "..CharInfo.info.id.." 任务失败:"..Questinfo.Questname)
			CharInfo.info.fbtime=os.time()
			crashdump()
			return test()
		else
			logwin:ColourNote("red","white",os.date("%Y-%m-%d %H:%M:%S",os.time()).." "..CharInfo.info.id.." 任务失败1:"..Questinfo.Questname)
			logwin:ColourNote("red","white",os.date("%Y-%m-%d %H:%M:%S",os.time()).." "..CharInfo.info.id.." 任务ll:"..ll)
			CharInfo.info.fbtime=os.time()
			return test()
		end
		print("xuemo over?")
	end
end
