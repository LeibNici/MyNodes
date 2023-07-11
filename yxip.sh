#!/bin/sh
ISP=ChinaUnion

echo "优选ip 开始"
./CloudflareST -dn 10 -url https://cloudflare.cdn.openbsd.org/pub/OpenBSD/7.3/src.tar.gz

echo "清除 $ISP 节点信息"
if [ -f "$ISP.list" ]; then
  > $ISP.list
else
  touch "$ISP.list"
fi

echo "写入最新的节点信息"
counter=1
tail -n +2 result.csv | while IFS=',' read -r col1 col2 col3 col4 col5 col6; do
    if [ "$col6" = "0.00" ]; then
      continue
    fi
  echo "优选ip-$counter: $col1 , 速度: $col6"
  echo "vless://e220a9aa-5d2d-4db4-9e14-4968e52b31ca@$col1:443?encryption=none&security=tls&sni=vless.cmhub.tk&fp=randomized&type=ws&host=vless.cmhub.tk&path=%2F%3Fed%3D2048#$ISP-oneself-$counter【${col5}ms | $col6】" >> "$ISP.list"
  counter=$((counter+1))
  if [ $counter -ge 6 ]; then
    echo "数量够5个，跳出循环"
    break
  fi
done

echo "合并最新节点文件"
> AllNodes.list
cat China*.list >> AllNodes.list