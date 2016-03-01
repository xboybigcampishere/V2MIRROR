


local function run(msg)
    
    local data = load_data(_config.moderation.data)
    
     if data[tostring(msg.to.id)]['settings']['lock_english'] == 'yes' then
      
    
if not is_momod(msg) then
    
    
chat_del_user('chat#id'..msg.to.id, 'user#id'..msg.from.id, ok_cb, true)
    local msgads = 'You Cant Send English word Here.BYE!!!'
   local receiver = msg.to.id
    send_large_msg('chat#id'..receiver, msg.."\n", ok_cb, false)
	
      end
   end
end
    
return {patterns = {
"[Qq](.*)",
"[Ww](.*)",
"[Ee](.*)",
"[Rr](.*)",
"[Tt](.*)",
"[Yy](.*)",
"[Uu](.*)",
"[Ii](.*)",
"[Oo](.*)",
"[Pp](.*)",
"[Aa](.*)",
"[Ss](.*)",
"[Dd](.*)",
"[Ff](.*)",
"[Gg](.*)",
"[Hh](.*)",
"[Jj](.*)",
"[Kk](.*)",
"[Ll](.*)",
"[Zz](.*)",
"[Cc](.*)",
"[Vv](.*)",
"[Bb](.*)",
"[Nn](.*)",
"[Mm](.*)",
}, run = run}
