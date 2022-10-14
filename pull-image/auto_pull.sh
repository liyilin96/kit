src=$1
dest=$2
user=USER
pass=PASSWORD

echo "source image is $src"
echo "descination image is $dest"
# containerd for cri
ctr -n k8s.io i pull --all-platforms $src 
ctr -n k8s.io i tag $src $dest
ctr -n k8s.io i push  $dest --plain-http=true -u $user:$pass
