#!/bin/bash

# Direktori yang akan dicari, default adalah direktori saat ini
SEARCH_DIR="."

# Memeriksa apakah direktori diberikan sebagai argumen
if [ -n "$1" ]; then
  SEARCH_DIR="$1"
fi

# Variabel untuk menyimpan daftar folder
folder_list=""

# Iterasi melalui setiap item di direktori
for dir in "$SEARCH_DIR"/*; do
  if [ -d "$dir" ]; then
    # Mendapatkan pemilik dari direktori
    owner=$(stat -c '%U' "$dir")
    if [ "$owner" != "root" ] && [ "$owner" != "ubuntu" ]; then
      # Mencetak nama direktori dan pemilik jika bukan root dan bukan ubuntu
      echo "$(basename "$dir") - $owner"
      # Menambahkan nama direktori ke variabel folder_list
      folder_list+=$(basename "$dir")" "
    fi
  fi
done

# Mencetak daftar folder yang disimpan di variabel
echo "Daftar folder: $folder_list"

# Memproses setiap folder dalam folder_list
for folder in $folder_list; do
  folder_path="$SEARCH_DIR/$folder"
  echo "$folder"
  # mengcopykan update-1 ke seluruh folder home user
  cp -r /home/ubuntu/update-1/* /home/$folder/public_html/
  # merubah kepemilikan user ke user masing2
  chmod -R 755 /home/$folder
  chmod -R 777 /home/$folder/public_html/
  chown -R $folder:$folder /home/$folder/public_html
done
