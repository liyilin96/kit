# local hub
for file in `ls`; do echo $file; docker load -i $file; done

# public hub
docker images | grep registry.xsky.com | awk '{ print $1 ":" $2}' | awk '{ print $0; gsub(/registry.local/, "registry.public.com/project1"); print $1}'| awk '{if(NR%2!=0)ORS=" ";else ORS="\n"}1' | awk '{ print "docker tag " $1 " " $2 ";\n docker push " $2 ";\n"}' | bash

