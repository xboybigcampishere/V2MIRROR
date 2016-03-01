do

function run(msg, matches)
send_contact(get_receiver(msg), "+9809210910812", "MIRROR", "TG", ok_cb, false)
end

return {
patterns = {
"^share$"

},
run = run
}

end
