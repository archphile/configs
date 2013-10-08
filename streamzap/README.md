## Installation
* Install the v4l-util package.
* Modify your native /etc/rc_maps.cfg to point to /etc/rc_keymaps/streamzap.local
```
--- a/etc/rc_maps.cfg	2013-10-08 18:10:04.478595923 -0400
+++ b/etc/rc_maps.cfg	2013-10-08 16:19:34.150994862 -0400
@@ -77,7 +78,7 @@
 *	rc-npgtech               npgtech
 *	rc-leadtek-y04g0051      leadtek_y04g0051
 *	rc-manli                 manli
-*	rc-streamzap             streamzap
+*	rc-streamzap             /etc/rc_keymaps/streamzap.local
 *	rc-winfast-usbii-deluxe  winfast_usbii_deluxe
 *	rc-behold                behold
 *	rc-gadmei-rm008z         gadmei_rm008z
```

* streamzap.local should be installed to /etc/rc_keymaps
* keyboard.xml to ~/.xbmc/userdata/keymaps and is only for user with xbmc
