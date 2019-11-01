require "addxml"
	print("Reload Mcl trigger,var,alias")
	DeleteTriggerGroup ("gag")    ---删除gag旧触发

--系统类触发
	addxml.trigger {
		enabled='y',
		temporary='n',
		group="me",
		expand_variables="y",
		match="^(> )*你.*真气不够",
		name="nomana",
		script="checkme",
	}
	addxml.trigger {
		enabled='y',
		temporary='n',
		group="check",
		expand_variables="y",
		match="^【系统提示】中华英雄将在三分钟.*以后重新启动，请抓紧时间处理你的人物",
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
	SetVariable("wstfull","no")
	SetVariable("mclver","1.72")
