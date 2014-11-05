#!/bin/sh
#
# Author: Krasimir Stoev (alabalism[_at_]gmail[_dot_]com 
# License: Public domain
#
# Скриптът е набързо написано решение за човек, който иска да вдигне няколко
# web сървъра и да ги наблюдава онлайн.
# Интересното в случая е това, че човекът deploy-ва някакви web сървъри
# но твърдно не желае Nagios за мониторинг.
#
# Предполага се, че сървърът трябва да е инсталиран и конфигуриран
# преди да се пристъпи към инсталация на phpSysInfo.
#

# Конфигурационни - пътища, линкове 
WEB_PATH="/var/www/"
PSI_DWN="https://github.com/phpsysinfo/phpsysinfo/archive/v3.1.16.tar.gz"
PSI_DWFL="v3.1.16.tar.gz"
PSI_DIR="psi"

# Update the system
echo "> Updating the system..."
apt-get update &&
apt-get upgrade -y
echo

# Достъпваме web директорията
cd ${WEB_PATH}

# Сваляме последната версия на phpsysinfo
wget ${PSI_DWN}

# Разопаковаме
tar xvzf v3.1.16.tar.gz

# Местим phpsysinfo в директорията, която искаме
mv -i phpsysinfo-3.1.16/ psi

# Влизаме в директорията
cd psi

# Копираме конфигурацията
cp phpsysinfo.ini.new phpsysinfo.ini

#Изтриваме архива, който сме свалили
cd ../
rm ${PSI_DWFL}

echo -n "> phpSysInfo is avaliable on yourdomain.ltd/psi"
