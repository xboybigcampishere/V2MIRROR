do

function run(msg, matches)
  if matches[1]:lower() == 'sticker' then -- Put everything you like :)
    send_document(get_receiver(msg), "./files/sticker.webp", ok_cb, false)
    return 'test'
  end
end
return {
  patterns = {
    "^[!/.](sticker)$"
	"^(sticker)$"
  }, 
  run = run 
}

end
