YearProgressBot
===============

\\\ YearProgressBot /// written in Bash, for Telegram.

Deployment
----------

1. Clone the reposistory:
```
$ git clone https://github.com/RedL0tus/YearProgressBot.git
```

2. Copy and modify the systemd unit file:  
Use your favourite editor to replace the dummy environment variables with yours. Don't forget to change the path at `ExecStart` as well.
```
# cp YearProgressBot.service /etc/systemd/system/YearProgressBot.service
# nano /etc/systemd/system/YearProgressBot.service
```

3. Start the bot
```
# systemctl start YearProgressBot
```

License
-------

WTFPLv2

```
DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
        Version 2, December 2004

Copyright (C) 2004 Sam Hocevar <sam@hocevar.net>

Everyone is permitted to copy and distribute verbatim or modified
copies of this license document, and changing it is allowed as long
as the name is changed.

DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION

0. You just DO WHAT THE FUCK YOU WANT TO.
```