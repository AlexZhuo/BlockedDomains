#获得ipset版的gfwlist
./gfwlist2dnsmasq.sh -d 127.0.0.1 -p 5053 -s china -o ./gfw_list.conf
#取出域名列表
awk -F '/' '/server=\/(.*)\/[0-9]+.[0-9]+.[0-9]+.[0-9]+#[0-9]+/'{'print $2'} ./gfw_list.conf | sed 's/^www\.//g' > ./china-banned
#获取最新国内路由表
wget -O- 'http://ftp.apnic.net/apnic/stats/apnic/delegated-apnic-latest' | grep ipv4 | grep CN | awk -F\| '{ printf("%s/%d\n", $4, 32-log($5)/log(2)) }' > china_route
#生成ipset restore文件
echo create china hash:net family inet hashsize 1024 maxelem 65536 > ./china

awk {'print "add china "$0'} ./china_route >> ./china
#删除dnsmasq ipset临时文件
rm -rf ./gfw_list.conf

