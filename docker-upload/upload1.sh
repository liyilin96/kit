for file in `ls`; do echo $file; docker load -i $file; done

docker images | grep registry.yourharbor.com | awk '{ print $1 ":" $2}'
