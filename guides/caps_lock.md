## Fixing the Caps Lock (Bloq Mayus key) in latin american keyboards in Omarchy

It can happen that after the installation, your keyboard works well, but the Caps Lock key doesn't work.

To fix this go to your input settings:

`SUPER + ALT + SPACE >> Setup >> Input`

Change two config variables to:

```
kb_layout = latam
kb_options = grp:alts_toggle
```

The kb_options line is the one changing the behavior of the caps lock key. The latam option should only be there if you have a latin american input.

You are all set!
