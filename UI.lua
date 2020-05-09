ColourNote ("Green","black", "界面UI加载成功...")
function wstwin()   --爬塔统计UI
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
	WindowFont(win_wst, "f3", "宋体", 9)
	WindowText(win_wst, "f3","爬塔进度：【"..Wstinfo.direction.."】",150, 2, 0, 0,ColourNameToRGB("Green"),false)
	WindowText(win_wst, "f3","层数： 【"..tostring(Wstinfo.level).."】层",5, 25, 0, 0,ColourNameToRGB("White"),false)
	WindowText(win_wst, "f3","耗时： 【"..tostring(Wstinfo.endtime-Wstinfo.startime).."】秒",185, 25, 0, 0,ColourNameToRGB("White"),false)
	WindowText(win_wst, "f3","爬塔时间： 【"..tostring(os.date("%Y-%m-%d %H:%M:%S",Wstinfo.startime)).."】",5, 55, 0, 0,ColourNameToRGB("cyan"),false)
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
	WindowFont(win_Count, "f3", "宋体", 9)
	WindowText(win_Count, "f3",CharInfo.info.id.." 综合统计".."  Lua Version:"..version,110, 2, 0, 0,ColourNameToRGB("cyan"),false)
	WindowText(win_Count, "f3","本轮连续任务数： 【"..Questinfo.continuous.."】次",5, 25, 0, 0,ColourNameToRGB("cyan"),false)
	WindowText(win_Count, "f3","本轮总共任务数： 【"..Questinfo.count.."】次",185, 25, 0, 0,ColourNameToRGB("cyan"),false)
	WindowText(win_Count, "f3","本轮获得exp： 【"..tostring(Questinfo.exp).."】",5, 55, 0, 0,ColourNameToRGB("cyan"),false)
	WindowText(win_Count, "f3","本轮平均exp： 【"..tostring(GetAverageExp()).."/时】",185, 55, 0, 0,ColourNameToRGB("cyan"),false)
	WindowText(win_Count, "f3","本轮获得pot： 【"..tostring(Questinfo.pot).."】",5, 85, 0, 0,ColourNameToRGB("cyan"),false)
	WindowText(win_Count, "f3","本轮平均pot： 【"..tostring(GetAveragePot()).."/时】",185, 85, 0, 0,ColourNameToRGB("cyan"),false)
	WindowText(win_Count, "f3","本轮平均任务次数： 【"..tostring(GetAverageCount()).."次/时】",5, 115, 0, 0,ColourNameToRGB("cyan"),false)
	WindowText(win_Count, "f3","本轮开始时间： 【"..tostring(os.date("%Y-%m-%d %H:%M:%S",Questinfo.startime)).."】",70, 145, 0, 0,ColourNameToRGB("White"),false)
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
	WindowFont(win_hp, "f3", "宋体", 9)
	WindowText(win_hp, "f3","血魔综合统计",150, 2, 0, 0,ColourNameToRGB("Red"),false)
	WindowText(win_hp, "f3","  当前任务阶段： 【"..tostring(Questinfo.Questname).."】",5, 25, 0, 0,ColourNameToRGB("White"),false)
	WindowText(win_hp, "f3","  当前目标 ： 【"..tostring(xuemo.kill_npc).."】",5, 55, 0, 0,ColourNameToRGB("cyan"),false)
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
	WindowFont(win_hp, "f3", "宋体", 9)
	WindowText(win_hp, "f3","任务综合统计",150, 2, 0, 0,ColourNameToRGB("Red"),false)
	WindowText(win_hp, "f3","本轮晕倒次数： 【"..tostring(CharInfo.Combat.FaintCount).."】次",5, 25, 0, 0,ColourNameToRGB("White"),false)
	WindowText(win_hp, "f3","本轮中毒次数： 【"..tostring(CharInfo.Combat.PoisonCount).."】次",185, 25, 0, 0,ColourNameToRGB("White"),false)
	WindowText(win_hp, "f3","本轮连续500 ： 【"..tostring(CharInfo.Combat.SuccessRound).."】次",5, 55, 0, 0,ColourNameToRGB("cyan"),false)
	WindowText(win_hp, "f3","本轮失败放弃： 【"..tostring(Questinfo.failcount).."】次",185, 55, 0, 0,ColourNameToRGB("cyan"),false)
	WindowText(win_hp, "f3","本轮 bug  点： 【"..tostring(Questinfo.bugcount).."点】",5, 85, 0, 0,ColourNameToRGB("Yellow"),false)
	WindowText(win_hp, "f3","本轮伪劣烧麦： 【"..tostring(Questinfo.bugfailed).."】个",185, 85, 0, 0,ColourNameToRGB("Yellow"),false)
    WindowShow(win_hp,true)
end