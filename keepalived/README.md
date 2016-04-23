#keepalived#

./configure --prefix=/usr/local/keepalived1220   
make && make install   


firewall-cmd --direct --permanent --add-rule ipv4 filter INPUT 0 \  
  --in-interface enp0s8 --destination 224.0.0.18 --protocol vrrp -j ACCEPT  
success  
firewall-cmd --direct --permanent --add-rule ipv4 filter OUTPUT 0 \  
  --out-interface enp0s8 --destination 224.0.0.18 --protocol vrrp -j ACCEPT  
success  
firewall-cmd --reload  
success  

firewall-cmd --direct --permanent --add-rule ipv4 filter INPUT 0 --in-interface eth0 --destination 224.0.0.18 --protocol vrrp -j ACCEPT  
firewall-cmd --direct --permanent --add-rule ipv4 filter OUTPUT 0 --out-interface eth0 --destination 224.0.0.18 --protocol vrrp -j ACCEPT  
firewall-cmd --reload 

firewall-cmd --direct --add-rule ipv4 filter INPUT 0 -i eth0 -d 224.0.0.0/8 -j ACCEPT
firewall-cmd --direct --perm --add-rule ipv4 filter INPUT 0 -i eth0 -d 224.0.0.0/8 -j ACCEPT
firewall-cmd --direct --add-rule ipv4 filter INPUT 0 -p vrrp -i eth0 -j ACCEPT
firewall-cmd --direct --perm --add-rule ipv4 filter INPUT 0 -p vrrp -i eth0 -j ACCEPT
firewall-cmd --direct --add-rule ipv4 filter OUTPUT 0 -p vrrp -o eth0 -j ACCEPT
firewall-cmd --direct --perm --add-rule ipv4 filter OUTPUT 0 -p vrrp -o eth0 -j ACCEPT
 
