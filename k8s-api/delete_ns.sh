for myns in $(kubectl get ns --no-headers | grep Terminating | awk '{ print $1 }'); do 
  kubectl get ns $myns -o json > $myns.json;
  
  start_line=`sed -n "/spec/=" $myns.json`; 
  end_line=$(($start_line + 4));
  sed -i "${start_line},${end_line}d" $myns.json;
  
  curl -k -H "Content-Type: application/json" -X PUT --data-binary @$myns.json  127.0.0.1:8001/api/v1/namespaces/$myns/finalize;
  
  rm $myns.json;
done
