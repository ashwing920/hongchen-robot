require "addxml"
	print("Reload Mcl trigger,var,alias")
	DeleteTriggerGroup ("gag")    ---删除gag旧触发
	DeleteTrigger("nomana")
	addxml.trigger {
		enabled='y',
		temporary='n',
		group="me",
		expand_variables="y",
		match="^(> )*(你扑在地上挣扎了几下|鬼门关|白无常说道)",
		name="medie",
		script="checkme",
	}
	addxml.trigger {
		enabled='n',
		temporary='n',
		group="wst",
		expand_variables="y",
		match="^(> )*你(.*真气不够|.*内力不够)",
		name="nomana",
		script="checkme",
	}
	addxml.trigger {
		enabled='y',
		temporary='n',
		group="me",
		expand_variables="y",
		match="^(> )*(也许是缺乏实战经验，你感到难以继续研究(.*)的问题了|你的基本.*，无法领会更高深的(.*)。)",
		name="skfull",
		script="checkme",
	}
	addxml.trigger {
		enabled='y',
		temporary='n',
		group="check",
		expand_variables="y",
		match="^【系统提示】中华英雄将在(一|二|三)分钟.*以后重新启动，请抓紧时间处理你的人物",
		name="reboot",
		script="checkstatus",
	}
	addxml.trigger {
		enabled='y',
		temporary='n',
		group="check",
		expand_variables="y",
		match="^(> )*你吃下一个.*烧卖，感觉自己",
		name="bug",
		script="checkme",
	}
	addxml.trigger {
		enabled='y',
		temporary='n',
		group="check",
		expand_variables="y",
		match="^(> )*你吃下一个.*烧卖，一股霉味",
		name="bugfailed",
		script="checkme",
	}
	addxml.trigger {
		enabled='y',
		temporary='n',
		group="look",
		expand_variables="y",
		match="^(> )你被@chsname的(.*)惊的没缓过神来！",
		name="npccome",
		script="checknpc",
	}
	addxml.trigger {
		enabled='y',
		temporary='n',
		group="check",
		expand_variables="y",
		match="^(> )*│(\\s{2}|□)(.*)\\s\\((.*)\\)",
		name="",
		script="loadskill",
	}
	---系统alias
if IsAlias("reloadsk") ~=0 then
	addxml.alias{
		name="reloadsk",
		enabled="y",
		temporary='n',
		group="sys",
		match="^reloadskill$",
		script="reloadsklist",
	}
end
if IsAlias("loopcmd") ~=0  then
	addxml.alias {
		name="loopcmd",
		enabled="y",
		group="sys",
		temporary='n',
		send="for i=1,%1 do\nExecute\('%2'\)\nend",
		send_to='12',
		match="^#(\\d+)\\s(.*)",
	}
end
--屏蔽消息类触发
	addxml.trigger {
		enabled="y",
		group="gag",
		temporary='n',
		match="(展开一个睡袋|深深吸了几口气|飞奔而去|办事干净利落|慢慢放开姿势|在冥神思索|轻轻的叹了口气|唯一皱眉，收住了姿势|觉得精神好了一些|深吸一口气|眉角微微一动|疾驰)",
		name="gag1",
		omit_from_output="y",
		['repeat']="y",
	}
	addxml.trigger {
		enabled="y",
		group="gag",
		temporary='n',
		match="(> )*(汪剑通说道：多加小心|> 汪剑通说道：什么？这么快就完成任务)",
		name="gag2",
		omit_from_output="y",
		['repeat']="y",
	}
	addxml.trigger {
		enabled='n',
		temporary='n',
		group="killnpc",
		expand_variables="y",
		match="^(.+)\\s+=([^、]+)",
		name="killnpc",
		script="killidhere",
	}
	addxml.trigger {
		enabled='n',
		temporary='n',
		group="get",
		expand_variables="y",
		match="^(.+)\\s+=([^、]+)",
		name="getidhere",
		script="xuemoget",
	}
	addxml.trigger {
		enabled='y',
		temporary='n',
		group="statistics",
		expand_variables="y",
		match="^\\s*(.*)点实战经验$",
		name="getexp2",
		script="statistics",
	}
	addxml.trigger {
		enabled='y',
		temporary='n',
		group="statistics",
		expand_variables="y",
		match="^\\s*(.*)点潜能$",
		name="getpot2",
		script="statistics",
	}
	addxml.trigger {
		enabled='y',
		temporary='n',
		group="statistics",
		expand_variables="y",
		match="^\\s*(.*)点体会$",
		name="gettihui2",
		script="statistics",
	}
--迷宫数据抓取触发-------
	addxml.trigger {
		enabled='n',
		temporary='n',
		group="maze",
		expand_variables="y",
		match="^(\\s{2}|│)(\\s{2}|│)(\\s{2}|│)(\\s{2}|│)(\\s{2}|│)(\\s{2}|│)(\\s{2}|│)(\\s{2}|│)(\\s{2}|│)(\\s{2}|│)(\\s{2}|│)(\\s{2}|│)(\\s{2}|│)(\\s{2}|│)(\\s{2}|│)",
		name="maze1",
		script="maze_setmaze1",
	}
	addxml.trigger {
		enabled='n',
		temporary='n',
		group="maze",
		expand_variables="y",
		match="^(◎|●)(.*)(◎|●)(.*)(◎|●)(.*)(◎|●)(.*)(◎|●)(.*)(◎|●)(.*)(◎|●)(.*)(◎|●)",
		name="maze2",
		script="maze_setmaze2",
	}
	addxml.trigger {
		enabled='n',
		temporary='n',
		group="maze",
		expand_variables="y",
		match="^迷宫地图，●->入口，●->出口，◎->位置",
		name="mazeend",
		script="maze_init",
	}
	SetAlphaOption("on_world_connect","")
	SetAlphaOption("on_world_disconnect","connserver") --设置断线重连事件
	if GetVariable("repairvalue")==nil then
		SetVariable("repairvalue","50")
	end
	if GetVariable("pfm_all")==nil then
		SetVariable("pfm_all","null")
	end
	if GetVariable("pfm_boss")==nil then
		SetVariable("pfm_boss","null")
	end
	if GetVariable("superman")==nil then
		SetVariable("superman","no")
	end
	if GetVariable("wstfull")==nil then
		SetVariable("wstfull","no")
	end
	if GetVariable("tianshu")==nil then
		SetVariable("tianshu","yes")
	end
	if GetVariable("upexp")==nil then
		SetVariable("upexp","0")
	end
	if GetVariable("questtype")==nil then
		SetVariable("questtype","protect")
	end
	SetVariable("mclver","2.00")
