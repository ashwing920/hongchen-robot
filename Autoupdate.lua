ColourNote ("Green","black", "�Զ�����ģ����سɹ�...")
local ftp = require("socket.ftp")
local http = require("socket.http")
ftp.USER = "robotftp"  --ftp �û���
ftp.PASSWORD = "Robot1234"  --ftp ����
local remoteconfig=""
local url = "ftp://139.155.23.7/"
local httpurl = "http://139.155.23.7:8080/"
function updater()--�Զ����º���
	ColourNote ("Red","black", "��ʼ�Զ�����...��ȡ���������ļ�")
	remoteconfig=""
	wait.make(function()
		while remoteconfig=="" do
			remoteconfig=http.request(httpurl.."UpdateConfig.txt")
			wait.time(1)
		end
		local config={}
		config=unserialize(remoteconfig)
		i=0
		for k,c in ipairs(config) do
			print(c.filename)
			mmd5=GetFileMd5(c.filename)
			if mmd5~=c.md5 then
				GetFile(c.filename)
			else
				ColourNote ("Red","blue", c.filename.." MD5:"..mmd5)
				ColourNote ("Red","blue", "MD5���������ļ�����������")
			end
			if c.require=="yes" then
				require(c.name)
			end
		end
		ColourNote ("Red","blue", "�����ļ�������ϣ���������������ָ��ctrl+shift+r���±���")
	end)
end

function unserialize(lua)
    local t = type(lua)
    if t == "nil" or lua == "" then
        return nil
    elseif t == "number" or t == "string" or t == "boolean" then
        lua = tostring(lua)
    else
        error("can not unserialize a " .. t .. " type.")
    end
    lua = "return " .. lua
    local func = loadstring(lua)
    if func == nil then
        return nil
    end
    return func()
end
function GetFileMd5(file)
	md5=""
	f = io.open (mclpath..file, "rb")
    if f then
		md5=utils.tohex (utils.md5 (f:read ("*a")))
		print(file.." md5:"..md5)
		f:close ()
	end
	return md5
end

function GetFile(file)
	local tempfile,wfile
	wfile=io.open(mclpath..file,"wb")
	tempfile,e =ftp.get(url..file)
	if tempfile~=nil then
		--print(tempfile)
		wfile:write(tempfile)
		wfile:flush()
		ColourNote ("Green","blue", "Զ���ļ�: "..file.." ���³ɹ�")
	else
		ColourNote ("Green","blue", "Զ���ļ�: "..file.." ����ʧ��")
	end
	wfile:close()
end
