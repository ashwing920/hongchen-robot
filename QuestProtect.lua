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
		Questinfo.Recordtime=os.time()
		Questinfo.Npc.name=ww[2]
		Questinfo.Npc.id=NpcList[Questinfo.Npc.name].id
		Questinfo.Npc.path=NpcList[Questinfo.Npc.name].path
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
		print("fulltime:"..os.time()-Questinfo.Recordtime)
		if var.cantouch=="yes" then
			Sendcmd("mtc0;yun refresh")
		end
		Execute("follow none;ww;exert regenerate;exert recover;jiqu")
		ll,ww=wait.regexp("^[> ]*������"..CharInfo.info.name.."��(.*)��ɱ���㣡$",60)
		ll=ll or ""
		if string.find(ll,"ɱ����") then
			print("killertime:"..os.time()-Questinfo.Recordtime)
			if ww[1]=="������" then
				Questinfo.killer.id=CharInfo.info.id.."'s heiyi ren"
			elseif ww[1]=="а�ɸ���" then
				Questinfo.killer.id=CharInfo.info.id.."'s xiepai gaoshou"
			end
			Questinfo.killer.die=false
			Questinfo.killer.faint=false
			CharInfo.disevent="mequest"
			Disconnect()
			Connect()
			i=0
			while not IsConnected() and i<=60 do
				wait.time(1)
				i=i+1
				Connect()
			end
			print(i)
			miss=0
			while true do
				Execute(CharInfo.info.id..";"..var.passw..";y")
				wait.regexp("����������ϡ�",3)
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
					if CharInfo.info.neili<tonumber(var.min_neili) then 
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
					CharInfo.disevent="mequest"
					Disconnect()
					Connect()
					i=0
					while not IsConnected() and i<=60 do
						wait.time(1)
						i=i+1
						Connect()
					end					
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
					CharInfo.disevent="mequest"
					Disconnect()
					Connect()
					i=0
					while not IsConnected() and i<=60 do
						wait.time(1)
						i=i+1
						Connect()
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
			ll,ww=wait.regexp("^[> ]*��������˵��:���Ѿ����������(.*)������",30) --������û���,�����Ͻ�ȥ��? |����ͨ˵����ʲô����ô�����������ˣ�
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
		no_busy()
		wait.time(3)
		Send("ask wang ��������")
		crashdump()
	elseif string.find(ll,"ʮ���ƽ�") then
		Send("eat shao mai")
		Send("eat shao mai")
		no_busy()
		if tonumber(CharInfo.info.Gold)>10 then
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
		return QuestStart()
	end
end