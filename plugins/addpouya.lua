do
local function callback(extra, success, result)
    vardump(success)
    cardump(result)
end
    function run(msg, matches)
        if not is_momod or not is_owner then
    return "Only Owners can added POUYA X BOY!!!"
end
    local user = 'user#id'
    local chat = 'chat#id'..msg.to.id
    chat_add_user(chat, user, callback, false)
    return "@pouya_x_boy Added To: "..string.gsub(msg.to.print_name, "_", " ")..'['..msg.to.id..']'
end
return {
    usage = {
      "Addadmin: Add Sudo In Group."
      },
    patterns = {
        "^[!/.]([Aa][Dd][Dd][Pp][Oo][Uu][Yy][Aa])$"
		"^([Aa][Dd][Dd][Pp][Oo][Uu][Yy][Aa])$"
		
        },
    run = run
}
end
