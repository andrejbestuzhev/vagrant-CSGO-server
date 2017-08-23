#!/bin/bash


# DEBUG - Travis-ci
TRAVIS=$1


if [[ -z "${TRAVIS}" ]]; then

  echo -e "\n--- Processing server installation ---\n"

  APTGET="sudo apt-get -y -q=9"

  echo -e "\n--- Linux update ---\n"

#  if [ -f /home/vagrant/csgo_env_disk_added_date ]
#  then
#     echo "Stratos runtime already provisioned so exiting."
#     exit 0
#  else

#    echo -e "Mounting disk extension (15Go)."

#    sudo apt-get install lvm2 system-config-lvm -y -q=9

#    sudo fdisk -u /dev/sdb <<EOF
#n
#p
#2


#t
#8e
#w
#EOF

#    sudo pvcreate /dev/sdb1
#    sudo vgextend VolGroup /dev/sdb1
#    sudo lvextend -L +15G /dev/VolGroup/lv_root
#    sudo resize2fs /dev/VolGroup/lv_root

#    sudo date > /home/vagrant/csgo_env_disk_added_date

#  fi

else

  echo -e "\n--- Processing travis installation ---\n"

  export DEBIAN_FRONTEND=noninteractive

  mkdir ~/www
  mkdir -p ~/serverfiles/csgo

  APTGET="sudo DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::=\"--force-confdef\" -o Dpkg::Options::=\"--force-confnew\""

  echo -e "\n--- Travis linux update ---\n"

fi

eval $APTGET update
eval $APTGET upgrade

echo -e "\n--- libc6-i386 & lib32gcc1 - i386 packages ---\n"
sudo dpkg --add-architecture i386
eval $APTGET update
eval $APTGET install libc6-i386 lib32gcc1

echo -e "\n--- ia32-libs - i386 packages ---\n"
sudo dpkg --add-architecture i386
eval $APTGET update
sudo aptitude -y -q install ia32-libs

echo -e "\n--- Binaries (gdb, tmux, git ...) ---\n"
eval $APTGET install gdb tmux git curl

echo -e "\n--- Install CS:GO server ---\n"
cd /home/vagrant
wget https://raw.githubusercontent.com/GameServerManagers/LinuxGSM/feature/cscoserver/CounterStrikeGlobalOffensive/csgoserver
sed -i 's/"0.0.0.0"/"192.168.56.101"/' /home/vagrant/csgoserver
chmod +x csgoserver
sudo chown vagrant:vagrant -R /home/vagrant/serverfiles
/home/vagrant/csgoserver auto-install
