
-- ibotg  IRC bot to Telegram: a bot that allows using Telegram from IRC
-- Lua wrapper to telegram-cli
-- Copyright (C) 2015 E. Bosch

-- MIT/X11 License

-- Permission is hereby granted, free of charge, to any person obtaining
-- a copy of this software and associated documentation files (the
-- "Software"), to deal in the Software without restriction, including   
-- without limitation the rights to use, copy, modify, merge, publish,
-- distribute, sublicense, and/or sell copies of the Software, and to
-- permit persons to whom the Software is furnished to do so, subject to
-- the following conditions:

-- The above copyright notice and this permission notice shall be
-- included in all copies or substantial portions of the Software.

-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
-- EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
-- MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
-- NONINFRINGEMENT. IN NO EVENT SHALL THE X CONSORTIUM BE LIABLE FOR ANY
-- CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
-- TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
-- SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


function on_msg_receive(msg)
  local sep = "\x1E"
  for linea in string.gmatch(msg.text,"[^\n]+")
  do
    for i in partir(linea)
    do
      print("9ZxtQy"..sep.."0"..sep..msg.date..sep..msg.from.print_name..sep..msg.to.print_name..sep..i)
    end
  end
end

function on_msg_history(msg)
  local sep = "\x1E"
  local fecha = os.date("[%d %H:%M]",msg.date)
  for linea in string.gmatch(msg.text,"[^\n]+")
  do
    for i in partir(linea)
    do
      print("9ZxtQy"..sep.."1"..sep..msg.date..sep..msg.from.print_name..sep..msg.to.print_name..sep..fecha.." "..i)
    end
  end
end

function on_our_id (id)
end

function on_user_update (user, what)
end

function on_chat_update (chat, what)
end

function on_secret_chat_update (schat, what)
end

function on_get_difference_end ()
end

function on_binlog_replay_end ()
end

function partir(x)
  local n = -425
  local l = string.len(x)
  return function ()
    n = n + 425
    if n<l then return string.sub(x,n+1,425+n) end
  end
end
