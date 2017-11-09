Create or edit /var/lib/gdm3/.config/pulse/client.conf including the code below:

```
autospawn = no
daemon-binary = /bin/true
```

Make sure gdm have access to the new file:

```
sudo chown gdm:gdm /var/lib/gdm3/.config/pulse/client.conf
```

In order to auto-connect devices, include the follow line of code at the end of /etc/pulse/default.pa:
```
load-module module-switch-on-connect
```

And now just reboot.
