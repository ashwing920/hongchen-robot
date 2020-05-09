ColourNote ("Green","black", "����UI���سɹ�...")
function wstwin()   --����ͳ��UI
    local WINDOW_WIDTH=GetInfo(264)
    WINDOW_WIDTH=WINDOW_WIDTH
    if WINDOW_WIDTH >=380 then WINDOW_WIDTH=380 end
    local WINDOW_HEIGHT = 80
    local WINDOW_POSITION = 7
    local WINDOW_BACKGROUND_COLOUR = ColourNameToRGB ("black")
    win_wst = "wstcount"
    WindowCreate (win_wst, 0, 145,WINDOW_WIDTH, WINDOW_HEIGHT, WINDOW_POSITION, 0, WINDOW_BACKGROUND_COLOUR)
    local BOX_COLOUR = ColourNameToRGB ("darkgreen")
    WindowCircleOp (win_wst, 2, 0, 15, 0, 0, BOX_COLOUR, 6, 2, 0x000000, 1)
	WindowFont(win_wst, "f3", "����", 9)
	WindowText(win_wst, "f3","�������ȣ���"..Wstinfo.direction.."��",150, 2, 0, 0,ColourNameToRGB("Green"),false)
	WindowText(win_wst, "f3","������ ��"..tostring(Wstinfo.level).."����",5, 25, 0, 0,ColourNameToRGB("White"),false)
	WindowText(win_wst, "f3","��ʱ�� ��"..tostring(Wstinfo.endtime-Wstinfo.startime).."����",185, 25, 0, 0,ColourNameToRGB("White"),false)
	WindowText(win_wst, "f3","����ʱ�䣺 ��"..tostring(os.date("%Y-%m-%d %H:%M:%S",Wstinfo.startime)).."��",5, 55, 0, 0,ColourNameToRGB("cyan"),false)
    WindowShow(win_wst,true)
end
function countwin()
    local WINDOW_WIDTH=GetInfo(264)
    WINDOW_WIDTH=WINDOW_WIDTH
    if WINDOW_WIDTH >=380 then WINDOW_WIDTH=380 end
    local WINDOW_HEIGHT = 165
    local WINDOW_POSITION = 6
    local WINDOW_BACKGROUND_COLOUR = ColourNameToRGB ("black")
    win_Count = "QuestCount"
    WindowCreate (win_Count, 0, 15,WINDOW_WIDTH, WINDOW_HEIGHT, WINDOW_POSITION, 0, WINDOW_BACKGROUND_COLOUR)
    local BOX_COLOUR = ColourNameToRGB ("darkgreen")
    WindowCircleOp (win_Count, 2, 0, 15, 0, 0, BOX_COLOUR, 6, 2, 0x000000, 1)
	WindowFont(win_Count, "f3", "����", 9)
	WindowText(win_Count, "f3",CharInfo.info.id.." �ۺ�ͳ��".."  Lua Version:"..version,110, 2, 0, 0,ColourNameToRGB("cyan"),false)
	WindowText(win_Count, "f3","���������������� ��"..Questinfo.continuous.."����",5, 25, 0, 0,ColourNameToRGB("cyan"),false)
	WindowText(win_Count, "f3","�����ܹ��������� ��"..Questinfo.count.."����",185, 25, 0, 0,ColourNameToRGB("cyan"),false)
	WindowText(win_Count, "f3","���ֻ��exp�� ��"..tostring(Questinfo.exp).."��",5, 55, 0, 0,ColourNameToRGB("cyan"),false)
	WindowText(win_Count, "f3","����ƽ��exp�� ��"..tostring(GetAverageExp()).."/ʱ��",185, 55, 0, 0,ColourNameToRGB("cyan"),false)
	WindowText(win_Count, "f3","���ֻ��pot�� ��"..tostring(Questinfo.pot).."��",5, 85, 0, 0,ColourNameToRGB("cyan"),false)
	WindowText(win_Count, "f3","����ƽ��pot�� ��"..tostring(GetAveragePot()).."/ʱ��",185, 85, 0, 0,ColourNameToRGB("cyan"),false)
	WindowText(win_Count, "f3","����ƽ����������� ��"..tostring(GetAverageCount()).."��/ʱ��",5, 115, 0, 0,ColourNameToRGB("cyan"),false)
	WindowText(win_Count, "f3","���ֿ�ʼʱ�䣺 ��"..tostring(os.date("%Y-%m-%d %H:%M:%S",Questinfo.startime)).."��",70, 145, 0, 0,ColourNameToRGB("White"),false)
    WindowShow(win_Count,true)
	if var.questtype=="xuemo" then
		xuemowin()
	else
		combatwin()
	end
	wstwin()
end
function xuemowin()
    local WINDOW_WIDTH=GetInfo(264)
    WINDOW_WIDTH=WINDOW_WIDTH
    if WINDOW_WIDTH >=380 then WINDOW_WIDTH=380 end
    local WINDOW_HEIGHT = 110
    local WINDOW_POSITION = 7
    local WINDOW_BACKGROUND_COLOUR = ColourNameToRGB ("black")
    win_hp = "CombatCount"
    WindowCreate (win_hp, 0, 155,WINDOW_WIDTH, WINDOW_HEIGHT, WINDOW_POSITION, 0, WINDOW_BACKGROUND_COLOUR)
    local BOX_COLOUR = ColourNameToRGB ("darkgreen")
    WindowCircleOp (win_hp, 2, 0, 15, 0, 0, BOX_COLOUR, 6, 2, 0x000000, 1)
	WindowFont(win_hp, "f3", "����", 9)
	WindowText(win_hp, "f3","Ѫħ�ۺ�ͳ��",150, 2, 0, 0,ColourNameToRGB("Red"),false)
	WindowText(win_hp, "f3","  ��ǰ����׶Σ� ��"..tostring(Questinfo.Questname).."��",5, 25, 0, 0,ColourNameToRGB("White"),false)
	WindowText(win_hp, "f3","  ��ǰĿ�� �� ��"..tostring(xuemo.kill_npc).."��",5, 55, 0, 0,ColourNameToRGB("cyan"),false)
    WindowShow(win_hp,true)
end
function combatwin()
    local WINDOW_WIDTH=GetInfo(264)
    WINDOW_WIDTH=WINDOW_WIDTH
    if WINDOW_WIDTH >=380 then WINDOW_WIDTH=380 end
    local WINDOW_HEIGHT = 110
    local WINDOW_POSITION = 7
    local WINDOW_BACKGROUND_COLOUR = ColourNameToRGB ("black")
    win_hp = "CombatCount"
    WindowCreate (win_hp, 0, 155,WINDOW_WIDTH, WINDOW_HEIGHT, WINDOW_POSITION, 0, WINDOW_BACKGROUND_COLOUR)
    local BOX_COLOUR = ColourNameToRGB ("darkgreen")
    WindowCircleOp (win_hp, 2, 0, 15, 0, 0, BOX_COLOUR, 6, 2, 0x000000, 1)
	WindowFont(win_hp, "f3", "����", 9)
	WindowText(win_hp, "f3","�����ۺ�ͳ��",150, 2, 0, 0,ColourNameToRGB("Red"),false)
	WindowText(win_hp, "f3","�����ε������� ��"..tostring(CharInfo.Combat.FaintCount).."����",5, 25, 0, 0,ColourNameToRGB("White"),false)
	WindowText(win_hp, "f3","�����ж������� ��"..tostring(CharInfo.Combat.PoisonCount).."����",185, 25, 0, 0,ColourNameToRGB("White"),false)
	WindowText(win_hp, "f3","��������500 �� ��"..tostring(CharInfo.Combat.SuccessRound).."����",5, 55, 0, 0,ColourNameToRGB("cyan"),false)
	WindowText(win_hp, "f3","����ʧ�ܷ����� ��"..tostring(Questinfo.failcount).."����",185, 55, 0, 0,ColourNameToRGB("cyan"),false)
	WindowText(win_hp, "f3","���� bug  �㣺 ��"..tostring(Questinfo.bugcount).."�㡿",5, 85, 0, 0,ColourNameToRGB("Yellow"),false)
	WindowText(win_hp, "f3","����α������ ��"..tostring(Questinfo.bugfailed).."����",185, 85, 0, 0,ColourNameToRGB("Yellow"),false)
    WindowShow(win_hp,true)
end