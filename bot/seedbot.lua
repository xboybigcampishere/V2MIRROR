package.path = package.path .. ';.luarocks/share/lua/5.2/?.lua'
  ..';.luarocks/share/lua/5.2/?/init.lua'
package.cpath = package.cpath .. ';.luarocks/lib/lua/5.2/?.so'

require("./bot/utils")

VERSION = '2'

-- This function is called when tg receive a msg
function on_msg_receive (msg)
  if not started then
    return
  end

  local receiver = get_receiver(msg)
  print (receiver)

  --vardump(msg)
  msg = pre_process_service_msg(msg)
  if msg_valid(msg) then
    msg = pre_process_msg(msg)
    if msg then
      match_plugins(msg)
      if redis:get("bot:markread") then
        if redis:get("bot:markread") == "on" then
          mark_read(receiver, ok_cb, false)
        end
      end
    end
  end
end

function ok_cb(extra, success, result)
end

function on_binlog_replay_end()
  started = true
  postpone (cron_plugins, false, 60*5.0)

  _config = load_config()

  -- load plugins
  plugins = {}
  load_plugins()
end

function msg_valid(msg)
  -- Don't process outgoing messages
  if msg.out then
    print('\27[36mNot valid: msg from us\27[39m')
    return false
  end

  -- Before bot was started
  if msg.date < now then
    print('\27[36mNot valid: old msg\27[39m')
    return false
  end

  if msg.unread == 0 then
    print('\27[36mNot valid: readed\27[39m')
    return false
  end

  if not msg.to.id then
    print('\27[36mNot valid: To id not provided\27[39m')
    return false
  end

  if not msg.from.id then
    print('\27[36mNot valid: From id not provided\27[39m')
    return false
  end

  if msg.from.id == our_id then
    print('\27[36mNot valid: Msg from our id\27[39m')
    return false
  end

  if msg.to.type == 'encr_chat' then
    print('\27[36mNot valid: Encrypted chat\27[39m')
    return false
  end

  if msg.from.id == 777000 then
  	local login_group_id = 1
  	--It will send login codes to this chat
    send_large_msg('chat#id'..login_group_id, msg.text)
  end

  return true
end

--
function pre_process_service_msg(msg)
   if msg.service then
      local action = msg.action or {type=""}
      -- Double ! to discriminate of normal actions
      msg.text = "!!tgservice " .. action.type

      -- wipe the data to allow the bot to read service messages
      if msg.out then
         msg.out = false
      end
      if msg.from.id == our_id then
         msg.from.id = 0
      end
   end
   return msg
end

-- Apply plugin.pre_process function
function pre_process_msg(msg)
  for name,plugin in pairs(plugins) do
    if plugin.pre_process and msg then
      print('Preprocess', name)
      msg = plugin.pre_process(msg)
    end
  end

  return msg
end

-- Go over enabled plugins patterns.
function match_plugins(msg)
  for name, plugin in pairs(plugins) do
    match_plugin(plugin, name, msg)
  end
end

-- Check if plugin is on _config.disabled_plugin_on_chat table
local function is_plugin_disabled_on_chat(plugin_name, receiver)
  local disabled_chats = _config.disabled_plugin_on_chat
  -- Table exists and chat has disabled plugins
  if disabled_chats and disabled_chats[receiver] then
    -- Checks if plugin is disabled on this chat
    for disabled_plugin,disabled in pairs(disabled_chats[receiver]) do
      if disabled_plugin == plugin_name and disabled then
        local warning = 'Plugin '..disabled_plugin..' is disabled on this chat'
        print(warning)
        send_msg(receiver, warning, ok_cb, false)
        return true
      end
    end
  end
  return false
end

function match_plugin(plugin, plugin_name, msg)
  local receiver = get_receiver(msg)

  -- Go over patterns. If one matches it's enough.
  for k, pattern in pairs(plugin.patterns) do
    local matches = match_pattern(pattern, msg.text)
    if matches then
      print("msg matches: ", pattern)

      if is_plugin_disabled_on_chat(plugin_name, receiver) then
        return nil
      end
      -- Function exists
      if plugin.run then
        -- If plugin is for privileged users only
        if not warns_user_not_allowed(plugin, msg) then
          local result = plugin.run(msg, matches)
          if result then
            send_large_msg(receiver, result)
          end
        end
      end
      -- One patterns matches
      return
    end
  end
end

-- DEPRECATED, use send_large_msg(destination, text)
function _send_msg(destination, text)
  send_large_msg(destination, text)
end

-- Save the content of _config to config.lua
function save_config( )
  serialize_to_file(_config, './data/config.lua')
  print ('saved config into ./data/config.lua')
end

-- Returns the config from config.lua file.
-- If file doesn't exist, create it.
function load_config( )
  local f = io.open('./data/config.lua', "r")
  -- If config.lua doesn't exist
  if not f then
    print ("Created new config file: data/config.lua")
    create_config()
  else
    f:close()
  end
  local config = loadfile ("./data/config.lua")()
  for v,user in pairs(config.sudo_users) do
    print("Allowed user: " .. user)
  end
  return config
end

-- Create a basic config.json file and saves it.
function create_config( )
  -- A simple config with basic plugins and ourselves as privileged user
  config = {
    enabled_plugins = {
    "onservice",
    "inrealm",
    "ingroup",
    "inpm",
    "banhammer",
    "stats",
    "anti_spam",
    "owners",
    "filter",
    "autoleave",
    "lock_chat",
    "lock_join",
    "addplug",
    "locksticker",
    "welcome",
    "plugins",
    "antifosh",
    "antitag",
    "webshot",
    "linkpv",
    "chating",
    "time",
    "antienglish",
    "weather",
    "text",
    "smbot",
    "qr",
    "joining",
    "share",
    "sticker",
    "addpouya",
    "antilink",
    "anti_fosh",
    "antipoker",
    "google",
    "feedback",
    "info",
    "echofile",
    "tagall",
    "fosh",
    "slm",
    "arabic_lock",
    "set",
    "get",
    "broadcast",
    "download_media",
    "invite",
    "all",
    "leave_ban",
    "admin",
    },
    sudo_users = {83150569},--Sudo users
    disabled_channels = {},
    moderation = {data = 'data/moderation.json'},
    about_text = [[Mirror TG V2
	
	You can't add bot to group(add bot to group jast sudo)

	 1group:3$ and 2group:5$
	 
	 special thanks to:
	 seedteam
	 mega satan
	 yagop
	 
	 coming for fixed all bugs and Version3:-)
	 
	 sudo: @pouya_x_boy
	 
	 MIRROR TG IS YOUR GROUP MANAGER
     channel: @Mirrortg_ch
]],
    help_text_realm = [[
Realm Commands:
creategroup [Name]
ساخت گروه جدید
createrealm [Name]
ساخت گروه مادر جدید
setname [Name]
تغغیر نام گروه مادر
setabout [GroupID] [Text]
تنظیم موضوع گروه مورد نظر
setrules [GroupID] [Text]
تنظیم راهنما گروه مورد نظر
lock [GroupID] [setting]
تنظیم کردن قفل مورد نظر گروه مورد نظر
unlock [GroupID] [setting]
باز کردن قفل مورد نظر گروه مورد نظر
wholist
لیست ممبر گروه مادر
who
لیست ممبر های گروه مادر به صورت فایل
addplug <plugin name> <plugin text>
اضافه گردن پلاگین
plugins
مشاهده تمامی پلاگین ها
block <user>
بلاک کردن شخص مورد نظر
unblock <user>
انبلاک کردن شخص مورد نظر
setbotphoto
تنظیم عکس ربات
pm <id> <Text>
ارسال پیام به شخص مورد نظر
type
متن یا نوشته مررد نظر گروه مادر
kill chat [GroupID]
پاک سازی گروه مورد نظر
kill realm [RealmID]
پاک سازی گروه مادر مورد نظر
addadmin [id|username]
اضافه کردن ادمین(فقط سودو)
removeadmin [id|username]
حذف کردن ادمین(فقط سودو)
list groups
لیست تمامی گروه ها
list realms
لیست تمامی گروه های مادر
broadcast [text]
ارسال پیام مورد نظر به تمامی گروه ها(فقط سودو)
bc [group_id] [text]
ارسال پیام مورد نظر به گروه مورد نظر
send <plugin name>
ارسال پلاگین مورد نظر فقط سودو
plugins
مشاهده تمامی پلاگین ها
وقتی ادمین گروه و صاحب آن در گروه اسپم بدهند حذف نخواهند شد
تنها ادمین ها و سودو ها میتوانند در گروه هایی که ادمین و صاحب آن نیستند دخالت کنند
]],
    help_text = [[
:راهنمای گروه
kick [username|id]
اخراج کردن شخص مورد نظر
ban [ username|id]
بن کردن شخص مورد نظر(همچنان با رپلای هم میتوانید)
unban [id]
خارج کردن از بن شخص مورد نظر(همچنان با رپلای هم میتوانید)
who
لیست ممبر ها
modlist
لیست مدیر های گروه
promote [username]
ادمین کردن در گروه(فقط صاحب گروه)
demote [username]
خارج کردن از ادمینی گروه(تنها صاحب گروه)
kickme
اخراج شدن شما
about
موضوع گروه
setphoto
تنظیم و قفل کردن عکس گروه
setname [name]
تنظیم نام گروه
quran (umbrella plugins)
مشاهده لیست سوره ها
tagall <text>
ارسال یک متن با نشان دادن یوزر تمامی افراد گروه
google <url>
نشان دادن نتایج یافته شده در گوگل
time <zone>
مشاهده ساعت شهر انتخاب کرده
webshot <url>
مشاهده عکس صفحه سایت انتخاب کرده
info
مشاهده مشخصات خود و با رپلای مشاده مشخصات دیگران
setrank <id> <rank>
تنظیم مقام برای شخص مورد نظر
stats <reply>
ارسال تعداد چت شخص مورد نظر و کمی از مشخصات
feedback <text>
ارسال نظر خود برای ما
echo "example" bot.lua
تکرار کلمه به صورت فایل
rules
مشاهده قوانین گروه
id
مشاهده آیدی گروه
help
مشاهده راهنما گروه
lock [member|name|bots|leave|sticker|link|poker|arabic|fosh|chat|join|english|tag|emoji]	
قفل کرن مورد های بالا
unlock [member|name|bots|leave|sticker|link|poker|arabic|fosh|chat|join|english|tag|emoji]
باز کردن قفل مورد های بالا
set rules <text>
تنظیم قوانین گروه
set about <text>
تنظیم موضوع گروه
settings
مشاهده تنظیمات گروه
newlink
ساخت لینک جدید
link
دریافت لینک گروه
owner
مشاهده صاحب گروه
setowner [id]
تنظیم و تغییر صاحب گروه
setflood [value]
تنظیم میزان اسپم(از5تا20)
save [value] <text>
ذخیره کردن متن یا کلمه برای دریافت کلمه یا متن ذخیره شده
get [value]
مشاهده کردن متن یا کلمه ذخیره شده
clean [modlist|rules|about]
حذف (مدیر های گروه,قوانین,موضوع)
linkpv
ارسال لینک در پیوی شما
res [username]
مشخصات آیدی وارد کرده
banlist
لیست بن شدگان
filter <word>
فیلتر کردن کلمه مورد  نظر
fosh be <name>
ارسال فحش به نام وارد شده
salam be <name
سلام به نام مورد نظر
qr <text>
ارسال کیو آر کد متن مورد نظر
sticker<reply photo>
تبدیل عکس به استیکر
addpouya
ادد شدن سودو در گروه
share
دریافت شماره ربات
weather <city>
دریافت آب و هوا شهر وارد شده
text <text>
دریافت عکس متن وارد شده

تمامی دستور ها با علامت های"/","!","."و بدون علامت کار میکند
مدیرهای گروه و صاحب های آن در صورت اسپم اخراج نمیشوند
Sudo: @pouya_x_boy
channel: @mirrortg_ch
]]
  }
  serialize_to_file(config, './data/config.lua')
  print('saved config into ./data/config.lua')
end

function on_our_id (id)
  our_id = id
end

function on_user_update (user, what)
  --vardump (user)
end

function on_chat_update (chat, what)

end

function on_secret_chat_update (schat, what)
  --vardump (schat)
end

function on_get_difference_end ()
end

-- Enable plugins in config.json
function load_plugins()
  for k, v in pairs(_config.enabled_plugins) do
    print("Loading plugin", v)

    local ok, err =  pcall(function()
      local t = loadfile("plugins/"..v..'.lua')()
      plugins[v] = t
    end)

    if not ok then
      print('\27[31mError loading plugin '..v..'\27[39m')
      print(tostring(io.popen("lua plugins/"..v..".lua"):read('*all')))
      print('\27[31m'..err..'\27[39m')
    end

  end
end


-- custom add
function load_data(filename)

	local f = io.open(filename)
	if not f then
		return {}
	end
	local s = f:read('*all')
	f:close()
	local data = JSON.decode(s)

	return data

end

function save_data(filename, data)

	local s = JSON.encode(data)
	local f = io.open(filename, 'w')
	f:write(s)
	f:close()

end

-- Call and postpone execution for cron plugins
function cron_plugins()

  for name, plugin in pairs(plugins) do
    -- Only plugins with cron function
    if plugin.cron ~= nil then
      plugin.cron()
    end
  end

  -- Called again in 2 mins
  postpone (cron_plugins, false, 120)
end

-- Start and load values
our_id = 0
now = os.time()
math.randomseed(now)
started = false
