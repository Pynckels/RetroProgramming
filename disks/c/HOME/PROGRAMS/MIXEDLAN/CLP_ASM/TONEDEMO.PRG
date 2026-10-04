EXTERNAL Tone

PROCEDURE Main

    MEMVAR GetList

    CLEAR

    ? "Clipper 5.2 / MASM PC-speaker demonstration"
    ?
    ? "The assembly routine will generate a 440 Hz tone."
    ?
    ? "Press a key to start..."
    INKEY(0)

    Tone(300)

    ?
    ? "Finished."
    ? "Press a key to exit."
    INKEY(0)

RETURN
