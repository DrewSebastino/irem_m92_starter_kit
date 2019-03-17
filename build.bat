@echo off
yasm main.asm -l main.lst
if ERRORLEVEL 1 goto end

romwak /b main a2-l0-a.8h a2-h0-a.6h
del main

SNEStoM92 sprite_tiles.chr
ren 0.bin a2_000.8a
ren 1.bin a2_010.8b
ren 2.bin a2_020.8c
ren 3.bin a2_030.8d
SNEStoM92 background_tiles.chr
ren 0.bin a2_c0.1a
ren 1.bin a2_c1.1b
ren 2.bin a2_c2.3a
ren 3.bin a2_c3.3b

copy raw_pcm.bin a2_da.1l /y

7z a -tzip gunforc2.zip a2_000.8a a2_010.8b a2_020.8c a2_030.8d a2_c0.1a a2_c1.1b a2_c2.3a a2_c3.3b a2_da.1l a2_sh0.3l a2_sl0.5l a2-h0-a.6h a2-h1-a.6f a2-l0-a.8h a2-l1-a.8f
del a2_000.8a
del a2_010.8b
del a2_020.8c
del a2_030.8d
del a2_c0.1a
del a2_c1.1b
del a2_c2.3a
del a2_c3.3b
del a2_da.1l
del a2-h0-a.6h
del a2-l0-a.8h

xcopy gunforc2.zip "" /y			//The pathway for your MAME roms directory goes in the quotation marks
cd ""								//The pathway for MAME directory goes in the quotation marks
mame64 -debug -nofilter gunforc2
cd ""								//The pathway from which this was called goes in the quotation marks (optional)

:end