
if [ -e /vol_b ]; then
    cd /vol_b
elif [ -e /vol_c ]; then
    cd /vol_c
else
    mkdir -p ~/export
    cd ~/export
fi
pwd
#nohup wget https://data.broadinstitute.org/Trinity/CTAT_RESOURCE_LIB/GRCh38_v27_CTAT_lib_Feb092018.plug-n-play.tar.gz >> nohuplog 2>&1 &
