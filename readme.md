
Bu repository deki stream.conf ve rinetd.conf konfigürasyon dosyaları "xx.xx.xx.xx" makinasında kullanılmak üzere eklenmiştir.

configuration_refresh.sh bash script ini 'nohup ./configuration_refresh.sh &' komutu ile bir kez çalıştırdıktan sonra her 10 saniyede bir pull alınmaktadır. 

Eğer rinetd.conf konfigürasyonunda değişiklik olmuş ise 'systemctl reload rinetd' otomatik çalışıp değişikliği yansıtmaktadır.
Eğer stream.conf konfigürasyonunda değişiklik olmuş ise 'sudo systemctl reload nginx' otomatik çalışıp değişikliği yansıtmaktadır.

Temal mekanizması şu şekilde işlemektedir:
Bitbucket reposundan pull aldıktan sonra "xx.xx.xx.xx" makinasında '/etc/nginx/modules-available/stream.conf' dosyası ile 
repository den gelen 'stream.conf' kıyaslanır ve değişiklik olmuş mu diye bakılır. Eğer repository de değişiklik olmuş ise
yeni 'stream.conf' dosyası '/etc/nginx/modules-available/stream.conf' üzerine yazılır. 
Aynı senaryo 'rinetd.conf' için de geçerlidir. 

ana makinada manuel değişiklik yapıldığında 10 saniye içerisinde git deki dosya üzerine yazılacaktır!



Kurulum adımları olarak izlenen yol:
1) '/home/ubuntu' klasörüne bu repo çekilir: "git clone https://github.com/ahmetceyhan/nginx_git_change_detector.git"
2) 'nginx_git_change_detector' klasörüne geçiş yapılır.
3) Pull alırken sertifika hatasına çözüm için bu komut çalıştırılır: 'git config --global http.sslverify false'
4) Otomatik pull alırken username ve password sormaması için bu komut çalıştırılır: 'git config --global credential.helper store'. 
   Böylece ilk pull alırken girilen git kullanıcı bilgileri kaydedilmiş olur.
5) Super user a geçiş yaptıktan sonra 'chmod +x configuration_refresh.sh' ile çalıştırma izni verilir.
6) 'nohup ./configuration_refresh.sh &' komutu ile arka planda çalıştırılır. ('nohup bash ./configuration_refresh.sh &' ile izin vermeden de çalıştırılabilir)
7) 'ps aux | grep configuration_refresh' komutu ile arka planda çalıştığı gözlemlenebilir.



olası pull hatalarında git revert için: 'git reset && git checkout .'
