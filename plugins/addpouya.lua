do
local function callback(extra, success, result)
    vardump(success)
    cardump(result)
end
    function run(msg, matches)
        if not is_momod or not is_owner then
    return "Only owners can add POUYA X BOY"
end
    local user = 'user#id'
    local chat = 'chat#id'..msg.to.id
    chat_add_user(chat, user, callback, false)
    return "@pouya_x_boy Added To: "..string.gsub(msg.to.print_name, "_", " ")..'['..msg.to.id..']'
end
return {
    patterns ={
        "^([Aa]ddxboy)$"
        },
    run = run
}
end
