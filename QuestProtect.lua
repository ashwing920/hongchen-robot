ColourNote ("Green","black", "ģ��-��������.���سɹ�...")
function QuestProtect() --�߳���ִ�� �������¿�wait.make
	local ll,ww,i,miss
	if not callpet() then
		print("�������Լ��ĳ���!@!!!")
		return false
	end
	Sendcmd("rideto xiangyang;yun recover;yun regenerate;ask wang jiantong about ��������")
	--ll,ww=wait.regexp("^[> ]*����ͨ(���˵�ͷ������˵��:�ɹ���������һ�����ְ���,����Ҫ��ɱ(.*)����ȥ������һ�¡�|˵���������İ����᧿�Σ���������ܰ��ҳﱸʮ���ƽ���|˵����"..CharInfo.info.name.."������һ�ε�����û���!|˵��������ȡ��ʧ�ܵĽ�ѵ���Ȼ������ɡ�)",2)
	ll,ww=wait.regexp({
							"��������ͨ�����йء��������ʡ�����Ϣ��\n����ͨ���˵�ͷ������˵��:�ɹ���������һ�����ְ���,����Ҫ��ɱ(.*)����ȥ������һ�¡�",
							"��������ͨ�����йء��������ʡ�����Ϣ��\n����ͨ˵���������İ����᧿�Σ���������ܰ��ҳﱸʮ���ƽ���",
							"��������ͨ�����йء��������ʡ�����Ϣ��\n����ͨ˵����"..CharInfo.info.name.."������һ�ε�����û���!",
							"��������ͨ�����йء��������ʡ�����Ϣ��\n����ͨ˵��������ȡ��ʧ�ܵĽ�ѵ���Ȼ������ɡ�",
							},5,nil,true,4)
	ll=ll or ""
	print(ll)
	if string.find(ll,"��ȥ����") then
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
				wait.regexp("^[> ]*��һ��������ֻ���������档�ûһ���ˡ�",30)
			end
		end
		repeat
			if Questinfo.Npc.name~="���" and Questinfo.Npc.name~="��ҩ��" and Questinfo.Npc.name~="������" then
				Sendcmd(Questinfo.Npc.path)
			else
				walkto(Questinfo.Npc.path)
			end
			Send("follow "..Questinfo.Npc.id)
			ll=wait.regexp("[> ]*(����û��|�������ʼ����)",5)
			ll=ll or ""
			if string.find (ll,"����û��") then
				wait.time(3)
			end
			if os.time()-Questinfo.Recordtime>60 then return false end
		until string.find(ll,"��ʼ����")
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
			ll,ww=wait.regexp("^[> ]*������"..CharInfo.info.name.."��(������|а�ɸ���)��ɱ���㣡$",60)
			ll=ll or ""
			if string.find(ll,CharInfo.info.name.."��") then
				print("killertime:"..os.time()-Questinfo.Recordtime)
				if string.find(ww[1],"������") then
					Questinfo.killer.id=CharInfo.info.id.."'s heiyi ren"
				elseif string.find(ww[1],"а�ɸ���") then
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
				ll=wait.regexp("^[> ].*"..CharInfo.info.name.."��(������|а�ɸ���)(\\("..CharInfo.info.id.."|�����ڵ���|��ϥ����)",2)
				ll=ll or ""
				print(ll)
				if string.find(ll,CharInfo.info.name) then
					if Questinfo.killer.faint or Questinfo.killer.die or string.find(ll,"���Բ���") then
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
									print("�������Լ��ĳ���!@!!!")
									return false
								end
							end
							Execute(var.sleephouse..";sleep")
							wait.regexp("^[> ]*��һ��������ֻ���������档�ûһ���ˡ�",30)
							if Questinfo.Npc.name~="���" and Questinfo.Npc.name~="��ҩ��" and Questinfo.Npc.name~="������" then
								Sendcmd(Questinfo.Npc.path)
							else
								walkto(Questinfo.Npc.path)
							end
							ll=wait.regexp("^[> ].*"..CharInfo.info.name.."��(������|а�ɸ���)(һ��Ƴ����|������һ�����|����)",5)
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
				ll=wait.regexp("^[> ]*(��Ҫ�ƿ�˭|�㿴�˿�|��������û��֪��)",2)
				ll=ll or ""
				if string.find(ll,"��Ҫ�ƿ�˭") then
					break
				end
				wait.time(1)
			end
			no_busy()
			if not callpet() then
				print("�������Լ��ĳ���!@!!!")
				return false
			end
			Sendcmd("cha martial-cognize;exert recover;exert regenerate;rideto xiangyang;ask wang jiantong about �������")
			--ll=wait.regexp("[> ]*����ͨ˵����(������û���,�����Ͻ�ȥ��|ʲô����ô������������)",2)
			ll,ww=wait.regexp({
							"��������ͨ�����йء�������ɡ�����Ϣ��\n����ͨ˵����ʲô����ô������������",
							"��������ͨ�����йء�������ɡ�����Ϣ��\n����ͨ˵����������û���,�����Ͻ�ȥ��",
					},5,nil,true,4)
			ll=ll or ""
			if string.find(ll,"����û���") then
					Send("ask wang ��������")
					crashdump()
					Questinfo.failcount=Questinfo.failcount+1
			end
			ll,ww=wait.regexp("^[> ]*��������˵��:���Ѿ����������(.*)������",5) --������û���,�����Ͻ�ȥ��? |����ͨ˵����ʲô����ô�����������ˣ�
			ll=ll or ""
			if string.find(ll,"�������") then
				Questinfo.continuous=chtonum(ww[1])
			end
			fangqiexp()
		end
	elseif string.find(ll,"�Ȼ�����") then
		wait.time(2)
	elseif string.find(ll,"����û���") then
		Send("ask wang jiantong about �������")
		ll,ww=wait.regexp({
							"��������ͨ�����йء�������ɡ�����Ϣ��\n����ͨ˵����ʲô����ô������������",
							"��������ͨ�����йء�������ɡ�����Ϣ��\n����ͨ˵����������û���,�����Ͻ�ȥ��",
					},5,nil,true,4)
		ll=ll or ""
		if string.find(ll,"����û���") then
				Send("ask wang ��������")
				crashdump()
				Questinfo.failcount=Questinfo.failcount+1
		elseif string.find(ll,"��ô������") then
			ll,ww=wait.regexp("^[> ]*��������˵��:���Ѿ����������(.*)������",5) --������û���,�����Ͻ�ȥ��? |����ͨ˵����ʲô����ô�����������ˣ�
			ll=ll or ""
			if string.find(ll,"�������") then
				Questinfo.continuous=chtonum(ww[1])
			end
		end
	elseif string.find(ll,"ʮ���ƽ�") then
		Send("eat shao mai")
		Send("eat shao mai")
		no_busy()
		if tonumbera(CharInfo.info.Gold,"Chargold")>10 then
			Send("give 10 gold to wang jiantong")
		else
			Send("give 1 cash to wang jiantong")
		end
		ll=wait.regexp("^[> ]*��������˵�������������İ��ո�л��",2)
		ll=ll or ""
		if string.find(ll,"��л��") then
			Questinfo.continuous=0
			CharInfo.Combat.SuccessRound=CharInfo.Combat.SuccessRound+1
		end
		return test()
	end
end