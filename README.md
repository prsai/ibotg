
ibotg
=====

IRC bot to Telegram: a bot that allows using Telegram from IRC

**[ Media branch is stable and is the default ]**

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
* telegram-cli with an account configured (optionally from [my
  fork](https://github.com/prsai/tg) to use history function, see
  "Telegram-cli with history callbacks" section)
* An IRC server, private recommended but can be public if it allows the
  requeriments of ibotg (see Notes section)
* An IRC client.
* Some means to access to the media files (see media support section).

Configuration
-------------

For configuring ibotg complete the config file, it's self documented, the 
directives are in the format key=value.

By now ibotg cannot retrieve the contact list nor group list from
telegram-cli, in fact some users can be in a group talking with its members
without having them as contacts, so ibotg needs two text files: one for the
contact list and another for the group/channel list. The format of them is
as follows:

**contact list:**

One line per contact with four data separated by colons:

    ircnick:telegram_name:username:channels

* ircnick: the nick shown in IRC (normally max 9 characters, no spaces).
* telegram_name: the name of the contact as appears on Telegram (spaces
  replaced by underscores "_").
* username: optional public username (also known as alias) that can be set
  in a Telegram account, in the form @username, al mentions in messages to
  these aliases will be replaced by the ircnick in the form ~ircnick~. If
  you don't like this feature just leave the username empty.
* channels: comma separated list of channels on IRC corresponding to
  Telegram groups where the contact is, the name of the group on Telegram
  will be defined in the group/channel list file.

Examples:

    root:::#farwest,#saloon
    unknown:::#farwest,#saloon
    echo:Your_name:@your_alias:#farwest,#saloon
    media:media::
    prsai:John_Wayne:@Duke:#farwest,#saloon

There are four special contacts in ibotg that must be present in contact
list:

* root user: internal control user managed by ibotg that has two functions:
  receive messages from a channel to forward them to Telegram and, via   
  private messages, pass commands directly to telegram-cli and return its
  output. This contact has no presence in Telegram network so the
  telegram_name and username should be empty. It must be in all channels.

* unknown user: it's the user on IRC that maps any Telegram user that is not
  in the contact file (will show the Telegram name into brackets). This
  contact has no presence in Telegram network so the telegram_name and
  username should be empty. It must be in all channels.

* echo user: it's your user on Telegram that must be mapped in IRC for echo
  messages (if enabled) and history logs, it must be different from master
  user (see Running section).

* media user: it's the user on IRC that shows media URLs (see media support
  section) for history messages (via private messages), as it's not possible
  to show the URLs inline (by each contact) as on regular messages. Both
  ircnick and telegram_name must be the same, username should be empty.

**channel list:**

One line per group/channel with two data separated by colon:

    Group_name:#channel

* Group_name: Name of the group as shown in Telegram (with spaces replaced
  by underscores "_").
* #channel: The name of the IRC channel when the corresponding group will be
  mapped.

Examples:

    The_Far_West:#farwest
    Western_Saloon:#saloon

Another file you should adapt to your system is "tg", this is the script
ibotg uses to launch telegram-cli with all the necessary options, you can
change variables TG_PATH with the path to the telegram-cli executable and
PUB_PATH with the path to the Telegram publick key file "tg-server.pub".

Telegram-cli with history callbacks (optional)
----------------------------------------------

If you want to use the history function of telegram-cli in ibotg (including
"last" command, see Running section) you must use my own [fork of
telegram-cli](https://github.com/prsai/tg) that adds history callbacks.

Follow the usual intructions to compile telegram-cli.

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
window query in your IRC client.

Commands
--------

Some special commands can be sent to the control user (root) prefixed with
exclamation mark (!). At the moment the following commands are available:

    !last <user|channel>

This will produce a dump of messages from history according to the number of
unread messages reported by "dialog_list" command from telegram-cli. You can
reset the unread message count with telegram-cli command "`mark_read
<contact|channel>`". This only works if you use the forked version of 
telegram-cli as said above.

    !chcon <ircnick> <telegram_name> [username|-]

For the contact refered by ircnick, change the telegram_name and
username/alias. If you omit the username it will be set to empty, if you set
"-" it will be left unchanged with the previous value that already had.  
This is usefull when some contact changes its name in Telegram, it will be
shown in ibotg as unknown until you set the new name with chcon, similarly
the username/alias affects the conversion from @username to ~irnick~ forms.
You must update the contact list file with the new telegram_name and/or
username of the contact as well because the changes made with chcon will not
be persistent if ibotg is restarted.

    !chgrp <#channel> <telegram_group>

For the channel refered (usually starting with #) change the group on
Telegram that is linked with. Like with !chcon, the changes made are not
persistent so you should update the channel list file.

!chcon and !chgrp commands are useful when the name of contacts or groups
on Telegram change, you can change them in ibotg in runtime to make it
work properly.

    !list

Will show the list of the live contacts that ibotg keeps, including the
changes made by "!chcon" command in runtime.

Shortcuts
---------

When sending commands to telegram-cli via the control user (root), when you
have to refer to a contact you normally use its telegram_name, now you can
use shortcuts for convenience with the follow syntax:

    command !<ircnick>

For example:

    user_info !prsai

Suposing that the contact with ircnick "prsai" has telegram_name
"John_Wayne", ibotg will convert the previous command to:

    user_info John_Wayne

As telegram-cli needs the telegram_name.

Similary, in a channel, you can refer to a contact with the following
syntax:

    !<ircnick>:

ibotg will convert this to the alias/username of the contact with the
ircnick refered, in the form @alias. In telegram this will notify the user
mentioned.

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
  connections, and/or antiflood measures. Also the nicks/channels created by
  the bot can collide with existing ones on IRC and/or can be registered by
  other users (at the moment ibotg doesn't support nick bots like
  "NickServ"), finally public servers can arise some privacy concerns; for
  all these reasons I recommend running your own private IRC server, ibotg
  has been heavily tested with [ngircd](http://ngircd.barton.de).

* Initial pending messages are causing some problems to ibotg so they are
  disabled by default, instead I recommend you use history command from
  telegram-cli (using [my fork](https://github.com/prsai/tg), see
  "Telegram-cli with history callbacks" section). If you want to enable them
  at your own risk set PENDING_MSGS=1 in "tg" file.

ToDo
----

* Make contact list dynamic/live [partially done].

* Address some synchronization problems [not experienced for some time].

Contact
-------

* Via [github project](https://github.com/prsai/ibotg).

* \#ibotg on irc.freenode.net

License
-------

Copyright (C) 2015,2016 E. Bosch

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
