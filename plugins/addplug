 local function run(msg, matches)
 local text = matches[2]
 if matches[1] == "saveplug" and is_sudo(msg) then
 
  return "Plugin Saves!!!"
 end
end

return {
 description = "filemanager plugin saver!",
 usage = {
  "!saveplug [name][ext] [plugintxt] : save plugin",
 },
 patterns = {
  "^saveplug ([^%s]+) (.*)$",
  "^[!/.](saveplug) ([^%s]+) (.*)$",
  
 },
 run = run,
}
