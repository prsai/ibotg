
ibotg
=====

IRC bot to Telegram: a bot that allows using Telegram from IRC

**[ Experimental branch with media support ]**

Description
-----------

ibotg acts as a gateway between IRC and Telegram chat/messaging network.

It works connecting to a Telegram account and mapping every contact and
group on Telegram to a user and channel on a IRC server.

ibotg is written in Tcl with a small Lua wrapper to 
[telegram-cli](https://github.com/vysheng/tg).

Architecture
------------

See [diagram](https://raw.githubusercontent.com/prsai/ibotg/media/DIAGRAM).

Requirements
-------------

* Tcl with picoirc library.
* telegram-cli with an account configured (optional patch supplied to use
  history function)
* An IRC server, private recommended but can be public if it allows several
  connections from the same IP and there is not nick collision nor flood
  problems.
* An IRC client.
* Some means to access to the media files (see media support section).

Configuration
-------------

For configuring ibotg complete the config file, it's self documented, the 
directives are in the format key=value.

By now ibotg cannot retrieve the contact list from telegram-cli, in fact
some users can be in a group talking with its members without having them as
contacts, so ibotg needs a text file (by default "contact_list") containing
the contact list in the following format:

    ircnick:telegram_name:groups

* ircnick: the nick shown in IRC (normally max 9 characters, no spaces).
* telegram_name: the name of the contact as appears on Telegram (spaces
  replaced by underscores "_").
* groups: comma separated list of Telegram groups where the contact is,
  these groups should be renamed in telegram-cli to not contain spaces,
  these names will be the channel names in IRC with prefix (ex.  "#") added
  by ibotg.

Examples:

    root::farwest,saloon
    echo:Your_name:farwest,saloon
    media:media:
    prsai:John_Wayne:farwest,saloon

There are two special contacts in botg that must be present in contact list:

* root user: internal control user managed by ibotg that has two functions:
  receive message from a channel and pass messages directly from/to
  telegram-cli. This contact has no presence in Telegram network so the
  telegram_name should be empty. It must be in all channels where there is
  a real contact.

* echo user: it's your user on Telegram that must be mapped in IRC for echo
  messages (if enabled) and history logs, it must be different from master
  user (see Running section).

* media user: it's the user on IRC that shows media URLs for history messages,
  as it's not possible to show the URLs inline as on regular messages. Both
  ircnick and telegram_name must be the same.

Another file you should adapt to your system is "tg", this is the script
ibotg uses to launch telegram-cli with all the necessary options, you can
change variables TG_PATH with the path to the telegram-cli executable and
PUB_PATH with the path to the Telegram publick key file "tg-server.pub".

Patching telegram-cli (optional)
--------------------------------

If you want to use the history function of telegram-cli in ibotg you must
compile telegram-cli with a small modification following these instructions,
if not you can skip this section and use a regular version of telegram-cli.

Before compiling telegram-cli apply the patch from its directory (normally
"tg" in your home), change "(ibotg directory)" with the path where you
downloaded ibotg.

    patch -p0 < (ibotg directory)/tgcli-lua_hist.patch

Then compile.

Running
-------

Simply launch ibotg from its directory and keep it in background, you can
provide an optional config file, if not "config" in the current directory
will be used.

    ./ibotg [config_file] &

On IRC you will see all the contacts joining their channels, the user
configured as master (normally the user you use with your IRC client) is
authorized to have the messages forwarded to telegram-cli and will be the
target from private messages.

A control user (configured as root user in tribute to bitlbee) will send the
non-message output from telegram-cli to master user and will forward
commands to telegram-cli, I suggest you keep the root user in a separated
window in your IRC client.

Some special commands can be sent to this control user (root) prefixed with
exclamation mark (!). At the moment the only command available is:

    !last <user|channel>

This will produce a dump of messages from history according to the number of
unread messages reported by "dialog_list" command from telegram-cli. You can
reset the unread message count with telegram-cli command "`mark_read
<contact|channel>`".

Media support
-------------

Support only for photos (by now): telegram-cli saves every photo to the
downloads local folder ($HOME/.telegram-cli/downloads) if you are running
telegram-cli/ibotg on your PC you just have to open the files with your
favourite image viewer. If you are running telegram-cli/ibotg on a server,
you should share the downloads folder via http, ftp, gopher, NFS, CIFS or
another protocol/service that allows you to access to the files remotely.

As an alternative you can sync the files with rsync, S3, etc. so you can
access them from other location.

In order to ease the operation, ibotg constructs the final URL according to
a base URL and the filename reported by telegram-cli, regular messages show
their URLs inline, the URLs in history messages are shown by the virtual
user "media".

Notes
-----

* TLS/SSL conections to IRC are not supported (a limitation from picoirc
  library), if you run a private IRC server I suggest you run ibotg on the
  same host (serv=localhost). If you need TLS/SSL you can deploy a tunnel or
  bouncer/proxy like stunnel or znc.
  Connection to Telegram is handled by telegram-cli so is secured by
  MTProto.

* If you run ibotg on public IRC server you may experience some problems
  like being rejected/banned due to antibot policies, limit of number of
  connections, and/or antiflood measures. Also the nicks/channels created
  by the bot can collide with existing ones on IRC and/or can be registered
  by other users (at the moment ibotg doesn't support nick bots like
  "NickServ"), finally public servers can arise some privacy concerns; for
  all these reasons I recommend running your own private IRC server.

* Initial pending messages are causing some problems to ibotg so they are
  disabled by default instead I recommend you use history command from
  telegram-cli (works only with an optional patch supplied, see Patching
  section).  If you want to enable them at your own risk set PENDING_MSGS=1
  in "tg" file.

ToDo
----

* Make contact list dynamic/live.

* Address some synchronization problems.

Contact
-------

* Via [github project](https://github.com/prsai/ibotg).

* \#ibotg on irc.freenode.net

License
-------

Copyright (C) 2015 E. Bosch

MIT/X11 License

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. 
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
