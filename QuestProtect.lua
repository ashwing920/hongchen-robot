ColourNote ("Green","black", "模块-保护任务.加载成功...")
function QuestProtect() --线程内执行 无需再新开wait.make
	local ll,ww,i,miss
	if not callpet() then
		print("必须有自己的宠物!@!!!")
		return false
	end
	Sendcmd("rideto xiangyang;yun recover;yun regenerate;ask wang jiantong about 保护人质")
	--ll,ww=wait.regexp("^[> ]*汪剑通(点了点头，对你说道:蒙古人收买了一批武林败类,好象要暗杀(.*)，你去保护他一下。|说道：襄阳的百姓岌岌可危，现在你能帮我筹备十两黄金吗|说道："..CharInfo.info.name.."，你上一次的任务还没完成!|说道：多吸取点失败的教训，等会再来吧。)",2)
	ll,ww=wait.regexp({
							"你向汪剑通打听有关『保护人质』的消息。\n汪剑通点了点头，对你说道:蒙古人收买了一批武林败类,好象要暗杀(.*)，你去保护他一下。",
							"你向汪剑通打听有关『保护人质』的消息。\n汪剑通说道：襄阳的百姓岌岌可危，现在你能帮我筹备十两黄金吗",
							"你向汪剑通打听有关『保护人质』的消息。\n汪剑通说道："..CharInfo.info.name.."，你上一次的任务还没完成!",
							"你向汪剑通打听有关『保护人质』的消息。\n汪剑通说道：多吸取点失败的教训，等会再来吧。",
							},5,nil,true,4)
	ll=ll or ""
	print(ll)
	if string.find(ll,"你去保护") then
		print(ww[2])
		SetTimerOption ("watchdog", "minute", "2")
		EnableTimer("watchdog", true)
		ResetTimer("watchdog")
		Questinfo.Recordtime=os.time()
		Questinfo.Npc.name=ww[2]
		Questinfo.Npc.id=NpcList[Questinfo.Npc.name].id
		Questinfo.Npc.path=NpcList[Questinfo.Npc.name].path
		Questinfo.killer.id="null"
		no_busy()
		dispel()
		if CharInfo.info.pot>500 and not CharInfo.info.poison and var.fullsk== "yes" then
			Sendcmd(var.safehouse)
			waitfullsk()
			no_busy()
		end
		if var.fullsk~="yes" then
			if var.cantouch=="yes" then
				Sendcmd("mtc0;yun refresh")
			else
				Execute("sleep")
				wait.regexp("^[> ]*你一觉醒来，只觉精力充沛。该活动一下了。",30)
			end
		end
		repeat
			if Questinfo.Npc.name~="杨过" and Questinfo.Npc.name~="程药发" and Questinfo.Npc.name~="康亲王" then
				Sendcmd(Questinfo.Npc.path)
			else
				walkto(Questinfo.Npc.path)
			end
			Send("follow "..Questinfo.Npc.id)
			ll=wait.regexp("[> ]*(这里没有|你决定开始跟随)",5)
			ll=ll or ""
			if string.find (ll,"这里没有") then
				wait.time(3)
			end
			if os.time()-Questinfo.Recordtime>60 then return false end
		until string.find(ll,"开始跟随")
		miss=0
		Execute("follow none;ww;exert regenerate;exert recover")
		if CharInfo.info.tihui<CharInfo.info.thlimit and os.time()-Questinfo.Recordtime<26 then
			while os.time()-Questinfo.Recordtime<27 do
				wait.time(1)
			end
		end
		print("fulltime:"..os.time()-Questinfo.Recordtime)
		if CharInfo.info.tihui>2000 then
			Send("jiqu")
		end
		if Questinfo.killer.id=="null" then
			ll,ww=wait.regexp("^[> ]*看起来"..CharInfo.info.name.."的(黑衣人|邪派高手)想杀死你！$",60)
			ll=ll or ""
			if string.find(ll,CharInfo.info.name.."的") then
				print("killertime:"..os.time()-Questinfo.Recordtime)
				if string.find(ww[1],"黑衣人") then
					Questinfo.killer.id=CharInfo.info.id.."'s heiyi ren"
				elseif string.find(ww[1],"邪派高手") then
					Questinfo.killer.id=CharInfo.info.id.."'s xiepai gaoshou"
				end
			end
		end
		if Questinfo.killer.id~="null" then
			Questinfo.killer.die=false
			Questinfo.killer.faint=false
			if var.superman=="yes" then
				CharInfo.disevent="firstkill"
				disconserver()
			end
			while true do
				CharInfo.disevent="mequest"
				disconserver()
				Execute("halt;hp")
				no_busy()
				Execute(var.yunpower)
				Send("look")
				ll=wait.regexp("^[> ].*"..CharInfo.info.name.."的(黑衣人|邪派高手)(\\("..CharInfo.info.id.."|正坐在地下|盘膝坐下)",2)
				ll=ll or ""
				print(ll)
				if string.find(ll,CharInfo.info.name) then
					if Questinfo.killer.faint or Questinfo.killer.die or string.find(ll,"昏迷不醒") then
						print("faint or die")
						break
					end
					if CharInfo.info.neili<tonumbera(var.min_neili,"min_neili") then 
						if var.cantouch=="yes" then
							Sendcmd("mtc0;yun refresh")
						else
							if CharInfo.info.poison then
								detoxify()
								no_busy()
								if not callpet() then
									print("必须有自己的宠物!@!!!")
									return false
								end
							end
							Execute(var.sleephouse..";sleep")
							wait.regexp("^[> ]*你一觉醒来，只觉精力充沛。该活动一下了。",30)
							if Questinfo.Npc.name~="杨过" and Questinfo.Npc.name~="程药发" and Questinfo.Npc.name~="康亲王" then
								Sendcmd(Questinfo.Npc.path)
							else
								walkto(Questinfo.Npc.path)
							end
							ll=wait.regexp("^[> ].*"..CharInfo.info.name.."的(黑衣人|邪派高手)(一眼瞥见你|对著你一声大喝|和你)",5)
						end
					end
					Execute("kill "..Questinfo.killer.id..";"..var.pfm)
					--wait.time(0.5)				
				else
					if Questinfo.killer.faint or Questinfo.killer.die then
						break
					end
					print(ll)
					miss=miss+1
					if miss>5 then
						no_busy()
						return
					end
				end
			end
			Execute("kill "..Questinfo.killer.id)
			while not Questinfo.killer.die  do
				Send("push "..Questinfo.killer.id.." to up")
				ll=wait.regexp("^[> ]*(你要推开谁|你看了看|这人现在没有知觉)",2)
				ll=ll or ""
				if string.find(ll,"你要推开谁") then
					break
				end
				wait.time(1)
			end
			no_busy()
			if not callpet() then
				print("必须有自己的宠物!@!!!")
				return false
			end
			Sendcmd("cha martial-cognize;exert recover;exert regenerate;rideto xiangyang;ask wang jiantong about 保护完成")
			--ll=wait.regexp("[> ]*汪剑通说道：(你任务还没完成,还不赶紧去做|什么？这么快就完成任务了)",2)
			ll,ww=wait.regexp({
							"你向汪剑通打听有关『保护完成』的消息。\n汪剑通说道：什么？这么快就完成任务了",
							"你向汪剑通打听有关『保护完成』的消息。\n汪剑通说道：你任务还没完成,还不赶紧去做",
					},5,nil,true,4)
			ll=ll or ""
			if string.find(ll,"任务还没完成") then
					Send("ask wang 放弃保护")
					crashdump()
					Questinfo.failcount=Questinfo.failcount+1
			end
			ll,ww=wait.regexp("^[> ]*郭靖对你说道:你已经连续完成了(.*)次任务。",5) --你任务还没完成,还不赶紧去做? |汪剑通说道：什么？这么快就完成任务了？
			ll=ll or ""
			if string.find(ll,"连续完成") then
				Questinfo.continuous=chtonum(ww[1])
			end
			fangqiexp()
		end
	elseif string.find(ll,"等会再来") then
		wait.time(2)
	elseif string.find(ll,"任务还没完成") then
		Send("ask wang jiantong about 保护完成")
		ll,ww=wait.regexp({
							"你向汪剑通打听有关『保护完成』的消息。\n汪剑通说道：什么？这么快就完成任务了",
							"你向汪剑通打听有关『保护完成』的消息。\n汪剑通说道：你任务还没完成,还不赶紧去做",
					},5,nil,true,4)
		ll=ll or ""
		if string.find(ll,"任务还没完成") then
				Send("ask wang 放弃保护")
				crashdump()
				Questinfo.failcount=Questinfo.failcount+1
		elseif string.find(ll,"这么快就完成") then
			ll,ww=wait.regexp("^[> ]*郭靖对你说道:你已经连续完成了(.*)次任务。",5) --你任务还没完成,还不赶紧去做? |汪剑通说道：什么？这么快就完成任务了？
			ll=ll or ""
			if string.find(ll,"连续完成") then
				Questinfo.continuous=chtonum(ww[1])
			end
		end
	elseif string.find(ll,"十两黄金") then
		Send("eat shao mai")
		Send("eat shao mai")
		no_busy()
		if tonumbera(CharInfo.info.Gold,"Chargold")>10 then
			Send("give 10 gold to wang jiantong")
		else
			Send("give 1 cash to wang jiantong")
		end
		ll=wait.regexp("^[> ]*郭靖对你说道：我替襄阳的百姓感谢你",2)
		ll=ll or ""
		if string.find(ll,"感谢你") then
			Questinfo.continuous=0
			CharInfo.Combat.SuccessRound=CharInfo.Combat.SuccessRound+1
		end
		return test()
	end
end