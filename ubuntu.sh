# Created By Tahmid Rayat =>> ig: @tahmid.rayat
# thanks to =>>> github.com/Neo-Oli <<<= & =>>> github.com/MFDGaming <<<=
# Donot copy . Give me The credit.
# Ubuntu 19.04 (Eoan Ermine) =>>>> http://cdimage.ubuntu.com/ubuntu-base/releases/

#!/data/data/com.termux/files/usr/bin/bash
folder=ubuntu-fs
if [ -d "$folder" ]; then
    first=1
    printf '\e[1;93m Skipping Download.Already Installed !!\n'
fi
tarball="ubuntu.tar.gz"
if [ "$first" != 1 ];then
	if [ ! -f $tarball ]; then
		printf '\e[1;93m Downloading Ubuntu Setup ...\n'
		case `dpkg --print-architecture` in
		aarch64)
			archurl="arm64" ;;
		arm)
			archurl="armhf" ;;
		amd64)
			archurl="amd64" ;;
		i*86)
			archurl="i386" ;;
		x86_64)
			archurl="amd64" ;;
		*)
			echo "unknown architecture"; exit 1 ;;
		esac
        wget "http://cdimage.ubuntu.com/ubuntu-base/releases/19.10/release/ubuntu-base-19.10-base-${archurl}.tar.gz" -O $tarball

    fi
    cur=`pwd`
    mkdir -p $folder
    cd $folder
    printf '\e[1;92m Download Completed !\n'
    printf ''
    proot --link2symlink tar -xf $cur/ubuntu.tar.gz --exclude='dev'||:
    printf ''
    printf 'nameserver 8.8.8.8\nnameserver 8.8.4.4\n' > etc/resolv.conf
    stubs=()
    stubs+=('usr/bin/groups')
    
    for f in ${stubs[@]};do
        echo -e "#!/bin/sh\nexit" > "$f"
    done



    cd $cur
fi
mkdir -p bind
bin=start.sh
cat > $bin <<- EOM
#!/bin/bash
cd \$(dirname \$0)
## unset LD_PRELOAD in case termux-exec is installed
unset LD_PRELOAD
command="proot"
command+=" --link2symlink"
command+=" -0"
command+=" -r $folder"
if [ -n "\$(ls -A bind)" ]; then
    for f in bind/* ;do
      . \$f
    done
fi
command+=" -b /dev"
command+=" -b /proc"
command+=" -b ubuntu-fs/tmp:/dev/shm"
command+=" -b /data/data/com.termux"
command+=" -b /:/host-rootfs"
command+=" -b /sdcard"
command+=" -b /storage"
command+=" -b /mnt"
command+=" -w /root"
command+=" /usr/bin/env -i"
command+=" HOME=/root"
command+=" PATH=/usr/local/sbin:/usr/local/bin:/bin:/usr/bin:/sbin:/usr/sbin:/usr/games:/usr/local/games"
command+=" TERM=\$TERM"
command+=" LANG=C.UTF-8"
command+=" /bin/bash --login"
com="\$@"
if [ -z "\$1" ];then
    exec \$command
else
    \$command -c "\$com"
fi
EOM

termux-fix-shebang $bin
chmod +x $bin
rm ubuntu.tar.gz -rf
clear
echo ""
printf '\e[1;96m Ubuntu by github.com/htr-tech\n'
printf '\e[1;93m Instagram: @ tahmid.rayat\n'
printf '\e[1;97m---------------------------------------'
echo ""
printf '\e[1;96m Ubuntu Base 19.10 (Eoan Ermine)\n'
printf '\e[1;96m Updated on 23-11-2019\n'
printf '\e[1;97m---------------------------------------'
echo ""
printf '\e[1;93m Now launch ubuntu  by "./start.sh"\n'
printf '\e[0m'
echo ""
