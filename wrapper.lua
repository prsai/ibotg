
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
-- MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. 
-- IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
-- CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
-- TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
-- SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


function on_msg_receive(msg)
  handle_msg(msg,"0")
end

function on_msg_history(msg)
  handle_msg(msg,"1")
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

function ok_load(mid, success, result)
  local sep,text,err = "\x1E","",""
  if success and (type(result)=="string") then
    text = result
  else
    err = "1"
  end
  print("3kdy5F"..sep..mid..sep..err..sep..sep..sep..sep..text)
end

function partir(x)
  local m = 425
  local n = -m
  local l = string.len(x)
  return function ()
    local j,z,tra="",""
    n = n + m
    if n<l then
      tra = string.sub(x,n+1,m+n)
      if l-n<m then return tra end   
      for i in string.gmatch(tra,"[^ ]+")
      do
        j = j..z
        z = i.." "
      end
      n = n - string.len(z)
      return j
    end
  end
end

do
  local mid = 1

  function handle_msg(msg,hist)
    local sep = "\x1E"
    local fecha
    local text
    local mit = 0
    local ind = 0
    if msg.text==nil then
      if msg.media~=nill and msg.media.type~=nil then 
        text = "["..msg.media.type.."]"
        if msg.media.type=="photo" then 
          load_photo(msg.id,ok_load,mid)
          ind = 1
        end
        if msg.media.type=="document" then
          load_document(msg.id,ok_load,mid)
          ind = 1
        end
        if ind==1 then
          text = text.."["..mid.."]"
          mit = mid
          mid = mid + 1
        end
      else
        return
      end
    else 
      text = msg.text
    end
    if hist=="1" then fecha = os.date("[%d %H:%M]",msg.date).." " else fecha = "" end
    for linea in string.gmatch(text,"[^\n]+")
    do
      for i in partir(linea)
      do
        print("9ZxtQy"..sep..mit..sep..hist..sep..msg.date..sep..msg.from.print_name..sep..msg.to.print_name..sep..fecha..i)
      end
    end
  end
end
