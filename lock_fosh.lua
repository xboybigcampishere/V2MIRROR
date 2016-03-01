


local function run(msg)
    
    local data = load_data(_config.moderation.data)
    
     if data[tostring(msg.to.id)]['settings']['lock_fosh'] == 'yes' then
      
    
if not is_momod(msg) then
    
    
chat_del_user('chat#id'..msg.to.id, 'user#id'..msg.from.id, ok_cb, true)
    local msgads = 'You cant Send Kossher Here.BYE!!!'
   local receiver = msg.to.id
    send_large_msg('chat#id'..receiver, msg.."\n", ok_cb, false)
	
      end
   end
end
    
return {patterns = {
"نگاییدم",
"گاییدم",
"[Nn][Aa][Gg][Hh][Aa][Ee][Dd][Aa][Mm](.*)",
"[Nn][Aa][Gg][Aa][Ee][Dd][Aa][Mm](.*)",
"کس ننت",
"کص ننت",
"[Kk]os nanat(.*)",
"[Kk]os nnt(.*)",
"[Kk]osnanat(.*)",
"[Kk]osnnt(.*)",
"کیری",
"کیر",
"[Kk][Ii][Rr][Ii](.*)",
"[Kk][Ii][Rr](.*)",
"کص",
"کس",
"[Kk][Oo][Ss]",
"مادر به خطا",
"ننه به خطا",
"[Mm][Aa][Dd][Aa][Rr][Bb][Ee][Kk][Hh][Tt][Aa](.*)",
"مادر جنده",
"ننه جنده",
"[Mm]adar jende(.*)",
"[Nn]ane jende(.*)",
"[Nn]ne jende(.*)",
"کس مامانت",
"کس ننت",
"[Kk]os madaret(.*)",
"[Kk]os mamanet(.*)",
"[Kk]os nnt(.*)",
"[Kk]os nnt(.*)",
"[Dd][Aa][Yy][Oo][Ss](.*)",
"[Dd][Aa][Yy][Uu][Ss](.*)",
"دیوص",
"دیوث",
"دیوس",
"بیناموس",
"[Bb][Ii][Nn][Aa][Mm][Uu][Ss](.*)",
"بی ناموس",
"ننه برزیلی",
"کسکش",
"[Kk][Oo][Ss][Kk][Ee][Ss][Hh](.*)",
"کونکش",
"[Kk][Uu][Nn][Kk][Ee][Ss][Hh](.*)",
"تخم سگ",
"[Tt][Oo][Kk][Hh][Mm] [Ss][Aa][Gg]",
"ننه لامپی",
"[Nn][Aa][Nn][Ee] [Ll][Aa][Mm][Pp][Ii](.*)",
"[Nn][Nn][Ee] [Ll][Aa][Mm][Pp][Ii](.*)",
}, run = run}
