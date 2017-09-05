## env-py

> This is just a sh script, help you guy to install python to own space.

**NOW JUST DEMO**

### Usage

First, you should install some C dependencies, on Debain system listed below,

```bash
sudo apt-get install zlibg1-dev libssl-dev libsqlite3-dev ...
```

1. Download the `init-virtual-env.sh`

2. `chmod +x init-virtual-env.sh`

3. `./init-virtual-env.sh 3.5.0`

*Maybe some error occured, ingore it if you can get what you want.*

These steps will download python 3.5.0 and installed in
`~/.virtual-python/3.5.0`.

You can leave the version param blank, install default version of python 2.7.9.

Py* files will stay in the directory where you init the file.*This is no a good
idea, should be stored in ~/.virtual-python/cache.*

Finally, you get python and virtualenv!

**Have fun!**
