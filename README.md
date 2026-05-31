# conveyor bag test

small roblox take-home — bags spawn on a conveyor, fall onto the belt, ride to the end, despawn. one player gets a slider for spawn rate.

## studio setup

you need a model in workspace called **Conveyer** with parts **Spawn** and **Belt**. belt `LookVector` should point along travel (spawn → end). i built mine in studio, rojo only syncs scripts.

## run

```bash
rojo serve
```

connect the rojo plugin, hit play.

build a place file if you want:

```bash
rojo build -o rojo-test.rbxlx
```

## whats in the repo

- server owns bags (spawn, physics drop, slide on belt, delete at 50 studs)
- random color/material per bag on server so everyone sees the same thing
- click a bag → client + server print its `BagId` in output
- first player in the server gets the interval ui (default 2s, max 30 bags)

## approach (short)

tried to keep network light — bags are server parts, movement is mostly server-side after they land (not spamming cframe every frame on 30 bags). spawn interval is one replicated number value, slider only talks to server if youre the picked admin.

libs: just rojo, no wally or anything.
