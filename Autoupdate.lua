ColourNote ("Green","black", "自动更新模块加载成功...")
local ftp = require("socket.ftp")
local http = require("socket.http")
ftp.USER = "robotftp"  --ftp 用户名
ftp.PASSWORD = "Robot1234"  --ftp 密码
local remoteconfig=""
local url = "ftp://139.155.23.7/"
local httpurl = "http://139.155.23.7:8080/"
function updater()--自动更新函数
	ColourNote ("Red","black", "开始自动更新...拉取更新配置文件")
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
				ColourNote ("Red","blue", "MD5符合最新文件，跳过更新")
			end
			if c.require=="yes" then
				require(c.name)
			end
		end
		ColourNote ("Red","blue", "所有文件更新完毕，请伸出你的三根手指按ctrl+shift+r重新编译")
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
		ColourNote ("Green","blue", "远端文件: "..file.." 更新成功")
	else
		ColourNote ("Green","blue", "远端文件: "..file.." 更新失败")
	end
	wfile:close()
end
