os.loadAPI("/SublarmsOS/conf/Config")
os.loadAPI(Config.rootDir().."/os/utils/ScreenUtils")
os.loadAPI(Config.rootDir().."/utils/FileHandler")
os.loadAPI(Config.rootDir().."/utils/TextUtils")

rtConf = {}
rtConf = FileHandler.readVariableFile(Config.runtimeFile())

option = 1
safeExit = false

homeunread = false

rednet.send(Config.emailServer(), "COUNT:"..rtConf.user)
s, m = rednet.receive(5)

if m ~= nil then
  ms = TextUtils.split(m,":")
  if ms[1] == "COUNT" then
    if tonumber(ms[2]) > 0 then
      homeunread = true
    end
  end
end

while true do
  submenu = false
  ScreenUtils.drawHF("Home")
  ScreenUtils.drawHomeOptions(option,submenu)
  
  if homeunread then
    term.setCursorPos(35,18)
    term.write("[ New Mail ]")
  end

  term.setCursorPos(24,4)
  term.write("+------------------+")
  term.setCursorPos(24,5)
  term.write("|                  |")
  term.setCursorPos(24,6)
  term.write("|       Help       |")
  term.setCursorPos(24,7)
  term.write("|                  |")
  term.setCursorPos(24,8)
  term.write("|  Use your arrow  |")
  term.setCursorPos(24,9)
  term.write("|  keys, enter, &  |")
  term.setCursorPos(24,10)
  term.write("|   backspace to   |")
  term.setCursorPos(24,11)
  term.write("|   navigate the   |")
  term.setCursorPos(24,12)
  term.write("|       menus      |")
  term.setCursorPos(24,13)
  term.write("|                  |")
  term.setCursorPos(24,14)
  term.write("+------------------+")
  e, k = os.pullEvent("key")
  if k == 208 then
    if option == 6 then
      option = option
    else
      option = option + 1
    end
  elseif k == 200 then
    if option == 1 then
      option = option
    else
      option = option - 1
    end
  elseif k == 28 then
    submenu = true
    if option == 1 then
      shell.run(Config.rootDir().."/os/email/Home")
      rednet.send(Config.emailServer(), "COUNT:"..rtConf.user)
      s1, m1 = rednet.receive(5)
      homeunread = false
      if m1 ~= nil then
        m1s = TextUtils.split(m1, ":")
        if m1s[1] == "COUNT" then
          if tonumber(m1s[2]) > 0 then
            homeunread = true
          end
        end
      end
    elseif option == 2 then
      breakoption = false
      shell.run(Config.rootDir().."/os/files/Home")
      if breakoption then
        safeExit = true
        break
      end
    elseif option == 3 then
      shell.run(Config.rootDir().."/os/games/Home")
    elseif option == 4 then
      shell.run(Config.rootDir().."/os/items/Home")
    elseif option == 5 then
      term.clear()
      term.setCursorPos(1,1)
      safeExit = true
      break
    elseif option == 6 then
      shell.run(Config.rootDir().."/os/Logout")
    end
  end
end
