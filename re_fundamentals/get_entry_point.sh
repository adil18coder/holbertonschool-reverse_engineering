#!/bin/bash

# messages.sh faylını bura daxil edirik ki, oradakı funksiyanı istifadə edə bilək
source ./messages.sh

# 1. Arqument yoxlanışı: İstifadəçi skripti işə salanda fayl adı yazıbmı?
if [ -z "$1" ]; then
    echo "Xəta: Zəhmət olmasa bir fayl adı daxil edin."
    echo "İstifadə qaydası: $0 <fayl_adı>"
    exit 1
fi

file_name="$1"

# 2. Faylın mövcudluq yoxlanışı: Belə bir fayl sistemdə var?
if [ ! -f "$file_name" ]; then
    echo "Xəta: Fayl tapılmadı və ya mövcud deyil."
    exit 1
fi
# 3. Faylın ELF olub-olmadığını yoxlayırıq
if ! file "$file_name" | grep -q "ELF"; then
    echo "Xəta: Bu fayl etibarlı bir ELF faylı deyil."
    exit 1
fi
# 4. Tələb olunan məlumatların çıxarılması

# Magic Number (Sehrli Rəqəmlər) hissəsini götürürük
magic_number=$(readelf -h "$file_name" | grep "Magic:" | sed 's/^[ \t]*Magic:[ \t]*//')

# Class (32-bit və ya 64-bit) hissəsini götürürük
class=$(readelf -h "$file_name" | grep "Class:" | awk -F: '{print $2}' | xargs)

# Byte Order (Endianness - Data oxunma sırası) hissəsini götürürük
byte_order=$(readelf -h "$file_name" | grep "Data:" | awk -F: '{print $2}' | xargs)

# Entry Point Address (Proqramın başladığı ünvan) hissəsini götürürük
entry_point_address=$(readelf -h "$file_name" | grep "Entry point address:" | awk -F: '{print $2}' | xargs)
# 5. messages.sh faylındakı funksiyanı çağıraraq nəticəni ekrana çıxarırıq
display_elf_header_info
