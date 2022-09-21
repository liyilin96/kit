# check when sonobuoy on
status=1 
# set private registry
registry="172.10.13.240:32082" 

while ((status > 0));do 
  # get err pod
  for line in $(kubectl get pod -A | grep -e "ImagePullBackOff" -e "ErrImagePull" | awk '{ print $1 ":" $2}');do 
    namespace=$(echo $line | cut -d ":" -f 1);
    name=$(echo $line | cut -d ":" -f 2);
    echo "here error pod name is $name namespace is $namespace"
    # get image
    for image in $(kubectl  get pod $name -n $namespace -o yaml | grep "image:");do
      dest=${image#*image:}
      echo "dest image is $dest"
      # jump public registry
      if [ "${dest%%/*}" != $registry ];then continue;fi
      
      img=$(echo $dest | awk -F '/' '{print $3}')
      # public registry
      src="docker.io/opsdockerimage/e2e-test-images-$img" 
      echo "src image is $src"
      # path
      ./auto_pull.sh $src $dest
      
      src="docker.io/opsdockerimage/$img" 
      echo "backup src image is $src"
      ./auto_pull.sh $src $dest
    done
  done
  status=$(sonobuoy status | grep e2e | wc -l)
  echo "check e2e status $status" 
  sleep 60
done
