require "addxml"
	print("Reload Mcl trigger,var,alias")
	DeleteTriggerGroup ("gag")    ---ɾ��gag�ɴ���

--ϵͳ�ഥ��
	addxml.trigger {
		enabled='y',
		temporary='n',
		group="me",
		expand_variables="y",
		match="^(> )*��.*��������",
		name="nomana",
		script="checkme",
	}
	addxml.trigger {
		enabled='y',
		temporary='n',
		group="check",
		expand_variables="y",
		match="^��ϵͳ��ʾ���л�Ӣ�۽���������.*�Ժ�������������ץ��ʱ�䴦���������",
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
	SetVariable("wstfull","no")
	SetVariable("mclver","1.72")
