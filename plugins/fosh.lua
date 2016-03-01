do

function run(msg, matches)
  return "از سر تا نوک پا گاییدمت  " .. matches[1]
end

return {
    patterns = {
    "^fosh be (.*)$"
  }, 
  run = run 
}

end
