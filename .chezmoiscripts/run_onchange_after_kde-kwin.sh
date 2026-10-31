#!/bin/bash
# KWin-Verhalten, virtuelle Desktops, Effekte und Eingabe (Dekoration wird von Hand gepflegt).
# Setzt nur einzelne Keys; Geräteabschnitte (Touchpad) bleiben unangetastet,
# verwaiste Tiling-Layouts fliegen raus. Die Desktop-IDs sind fest, weil kwinrulesrc darauf verweist.
set -euo pipefail

kwin() { kwriteconfig6 --file kwinrc "$@"; }
input() { kwriteconfig6 --file kcminputrc "$@"; }

# Virtuelle Desktops: 16 in einer Reihe
kwin --group Desktops --key Number 16
kwin --group Desktops --key Rows 1
kwin --group Desktops --key Id_1 6b33d5a8-71f4-4707-8dce-8ed2ba37dc2d
kwin --group Desktops --key Id_2 52693e58-9514-4cab-9fd2-057327f615b9
kwin --group Desktops --key Id_3 0783c141-6f53-47a7-92f1-dd2c2ad51499
kwin --group Desktops --key Id_4 ae304e5f-cfe5-4c91-9ba9-f4052c25a8ae
kwin --group Desktops --key Id_5 aafb4cd5-6f20-4873-b3d8-9f64ce10eef3
kwin --group Desktops --key Id_6 97b0af27-59a8-43c7-b251-3b54b29457f8
kwin --group Desktops --key Id_7 ef8c9d84-a8d5-4bff-aa69-3ac3e8c89792
kwin --group Desktops --key Id_8 fbe6d7f7-4d8f-4834-b44b-052d1ca4d64e
kwin --group Desktops --key Id_9 e8b0dd7c-262c-4eb6-8373-f15bdfd345a2
kwin --group Desktops --key Id_10 404e2c4a-66ca-4046-a33b-4a4cd7d2104f
kwin --group Desktops --key Id_11 50a7ee63-1c82-4306-b054-f0a06ec7926b
kwin --group Desktops --key Id_12 22954df9-cfac-451f-b91d-51f87fba9034
kwin --group Desktops --key Id_13 87b1ac68-e007-408e-a26d-f1369796cead
kwin --group Desktops --key Name_13 tk
kwin --group Desktops --key Id_14 919440d6-55ec-4dd8-a398-0b9b546c1253
kwin --group Desktops --key Name_14 cava
kwin --group Desktops --key Id_15 7f1a02ba-59b8-4e6f-ae2b-0c6b95e9b193
kwin --group Desktops --key Name_15 aux
kwin --group Desktops --key Id_16 4b44e857-a6e9-40f5-b102-466187aebe0b
kwin --group Desktops --key Name_16 comm

# Fokus folgt der Maus, mit Auto-Raise
kwin --group Windows --key FocusPolicy FocusFollowsMouse
kwin --group Windows --key AutoRaise true
kwin --group Windows --key AutoRaiseInterval 400
kwin --group Windows --key DelayFocusInterval 100

# Effekte und Skripte
kwin --group Plugins --key mudeerEnabled true
kwin --group Plugins --key diminactiveEnabled true
kwin --group Plugins --key wobblywindowsEnabled true
kwin --group Plugins --key desktopchangeosdEnabled false
kwin --group Script-desktopchangeosd --key PopupHideDelay 200
kwin --group Effect-overview --key BorderActivate 9

kwin --group NightColor --key Active true

# Großer, farbiger Cursor (Paket: oxygen-cursors)
input --group Mouse --key cursorTheme 'Oxygen 33 Indigo Ghost'
input --group Mouse --key cursorSize 48

# Tastenwiederholung und Kensington-Trackball
input --group Keyboard --key RepeatDelay 300
input --group Keyboard --key RepeatRate 60
input --group Libinput --group 6790 --group 32792 --group 'Kensington Expert Wireless TB Mouse' --key PointerAcceleration 0.600

# Tiling-Layouts verwaister Desktops entfernen (gekachelt wird mit Mudeer)
kwinrc=${XDG_CONFIG_HOME:-$HOME/.config}/kwinrc
known=$(grep -E '^Id_[0-9]+=' "$kwinrc" | cut -d= -f2)
{ grep -oE '^\[Tiling\]\[[^]]+\]\[[^]]+\]' "$kwinrc" || true; } | while IFS= read -r section; do
    desktop=$(cut -d'[' -f3 <<<"$section" | tr -d ']')
    output=$(cut -d'[' -f4 <<<"$section" | tr -d ']')
    grep -qx "$desktop" <<<"$known" && continue
    kwin --group Tiling --group "$desktop" --group "$output" --key padding --delete
    kwin --group Tiling --group "$desktop" --group "$output" --key tiles --delete
done

if qdbus6 org.kde.KWin >/dev/null 2>&1; then
    qdbus6 org.kde.KWin /KWin reconfigure >/dev/null || true
fi

echo "KWin-Einstellungen gesetzt; Desktop-IDs und -Namen wirken nach Ab- und Anmelden."
