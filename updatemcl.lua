require "addxml"
	print("Reload Mcl trigger,var,alias")
	DeleteTriggerGroup ("gag")    ---ɾ��gag�ɴ���
	DeleteTrigger("nomana")
	addxml.trigger {
		enabled='y',
		temporary='n',
		group="me",
		expand_variables="y",
		match="^(> )*(�����ڵ��������˼���|���Ź�|���޳�˵��)",
		name="medie",
		script="checkme",
	}
	addxml.trigger {
		enabled='n',
		temporary='n',
		group="wst",
		expand_variables="y",
		match="^(> )*��(.*��������|.*��������)",
		name="nomana",
		script="checkme",
	}
	addxml.trigger {
		enabled='y',
		temporary='n',
		group="me",
		expand_variables="y",
		match="^(> )*(Ҳ����ȱ��ʵս���飬��е����Լ����о�(.*)��������|��Ļ���.*���޷����������(.*)��)",
		name="skfull",
		script="checkme",
	}
	addxml.trigger {
		enabled='y',
		temporary='n',
		group="check",
		expand_variables="y",
		match="^��ϵͳ��ʾ���л�Ӣ�۽���(һ|��|��)����.*�Ժ�������������ץ��ʱ�䴦���������",
		name="reboot",
		script="checkstatus",
	}
	addxml.trigger {
		enabled='y',
		temporary='n',
		group="check",
		expand_variables="y",
		match="^(> )*�����һ��.*�������о��Լ�",
		name="bug",
		script="checkme",
	}
	addxml.trigger {
		enabled='y',
		temporary='n',
		group="check",
		expand_variables="y",
		match="^(> )*�����һ��.*������һ��ùζ",
		name="bugfailed",
		script="checkme",
	}
	addxml.trigger {
		enabled='y',
		temporary='n',
		group="look",
		expand_variables="y",
		match="^(> )�㱻@chsname��(.*)����û����������",
		name="npccome",
		script="checknpc",
	}
	addxml.trigger {
		enabled='y',
		temporary='n',
		group="check",
		expand_variables="y",
		match="^(> )*��(\\s{2}|��)(.*)\\s\\((.*)\\)",
		name="",
		script="loadskill",
	}
	---ϵͳalias
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
--������Ϣ�ഥ��
	addxml.trigger {
		enabled="y",
		group="gag",
		temporary='n',
		match="(չ��һ��˯��|�������˼�����|�ɱ���ȥ|���¸ɾ�����|�����ſ�����|��ڤ��˼��|�����̾�˿���|Ψһ��ü����ס������|���þ������һЩ|����һ����|ü��΢΢һ��|����)",
		name="gag1",
		omit_from_output="y",
		['repeat']="y",
	}
	addxml.trigger {
		enabled="y",
		group="gag",
		temporary='n',
		match="(> )*(����ͨ˵�������С��|> ����ͨ˵����ʲô����ô����������)",
		name="gag2",
		omit_from_output="y",
		['repeat']="y",
	}
	addxml.trigger {
		enabled='n',
		temporary='n',
		group="killnpc",
		expand_variables="y",
		match="^(.+)\\s+=([^��]+)",
		name="killnpc",
		script="killidhere",
	}
	addxml.trigger {
		enabled='n',
		temporary='n',
		group="get",
		expand_variables="y",
		match="^(.+)\\s+=([^��]+)",
		name="getidhere",
		script="xuemoget",
	}
	addxml.trigger {
		enabled='y',
		temporary='n',
		group="statistics",
		expand_variables="y",
		match="^\\s*(.*)��ʵս����$",
		name="getexp2",
		script="statistics",
	}
	addxml.trigger {
		enabled='y',
		temporary='n',
		group="statistics",
		expand_variables="y",
		match="^\\s*(.*)��Ǳ��$",
		name="getpot2",
		script="statistics",
	}
	addxml.trigger {
		enabled='y',
		temporary='n',
		group="statistics",
		expand_variables="y",
		match="^\\s*(.*)�����$",
		name="gettihui2",
		script="statistics",
	}
--�Թ�����ץȡ����-------
	addxml.trigger {
		enabled='n',
		temporary='n',
		group="maze",
		expand_variables="y",
		match="^(\\s{2}|��)(\\s{2}|��)(\\s{2}|��)(\\s{2}|��)(\\s{2}|��)(\\s{2}|��)(\\s{2}|��)(\\s{2}|��)(\\s{2}|��)(\\s{2}|��)(\\s{2}|��)(\\s{2}|��)(\\s{2}|��)(\\s{2}|��)(\\s{2}|��)",
		name="maze1",
		script="maze_setmaze1",
	}
	addxml.trigger {
		enabled='n',
		temporary='n',
		group="maze",
		expand_variables="y",
		match="^(��|��)(.*)(��|��)(.*)(��|��)(.*)(��|��)(.*)(��|��)(.*)(��|��)(.*)(��|��)(.*)(��|��)",
		name="maze2",
		script="maze_setmaze2",
	}
	addxml.trigger {
		enabled='n',
		temporary='n',
		group="maze",
		expand_variables="y",
		match="^�Թ���ͼ����->��ڣ���->���ڣ���->λ��",
		name="mazeend",
		script="maze_init",
	}
	SetAlphaOption("on_world_connect","")
	SetAlphaOption("on_world_disconnect","connserver") --���ö��������¼�
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
