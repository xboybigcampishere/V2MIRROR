do

function run(msg, matches)
  return "سلام  " .. matches[1]
end

return {
    patterns = {
    "^salam be (.*)$"
  }, 
  run = run 
}

end
