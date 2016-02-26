local function run(msg)
if msg.text == "tfb" then
	return "^_+پرچم بالاست"
end
if msg.text == "Hi" then
	return "Hello honey"
end
if msg.text == "Hello" then
	return "Hi bb"
end
if msg.text == "hello" then
	return "Hi honey"
end
if msg.text == "Salam" then
	return "Salam aleykom"
end
if msg.text == "salam" then
	return "va aleykol asalam"
end
if msg.text == "pouya" then
	return "^_~با بابایی چیکار داری"
end
if msg.text == "seede" then
	return "بسیک چاقال"
end
if msg.text == "اسمت چیه؟" then
	return "^_-آیینه"
end
if msg.text == "slm" then
	return ";(درست سلام بده گشاد"
end
if msg.text == "zac" then
	return "پرچم بالا"
end
if msg.text == "w8" then
	return "+_+تو کونت"
end
if msg.text == "Bot" then
	return "Huuuum?"
end
if msg.text == "?" then
	return "Hum??"
end
if msg.text == "پویا" then
	return "^_~با بابایی چیکار داری"
end
if msg.text == "bye" then
	return "Bye Bye"
end
end

return {
	description = "Chat With Robot Server", 
	usage = "chat with robot",
	patterns = {
		"^[Hh]i$",
		"^[Hh]ello$",
		"^[Pp][Oo][Uu][Yy][Aa]$",
		"^پویا$",
		"^[Bb]ot$",
		"^[Zz][Aa][Cc]$",
		"^[Bb]ye$",
		"^?$",
		"^[Ss]alam$",
		"^w8$",
		"^اسمت چیه؟$",
		"^[Tt][Ff][Bb]$",
		}, 
	run = run,
    --privileged = true,
	pre_process = pre_process
}
