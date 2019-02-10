#!/bin/sh
#
#    nagios-plugins-crond - A plugin for nagios that will check crond.
#    version 1.5 - Jul 11 2012
#    Copyright (c) 2012  Ilya A. Otyutskiy <sharp@thesharp.ru>
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

pidfile="/var/run/crond.pid"

if [ -e $pidfile ] ; then
	pid=`cat $pidfile`
	run=`ps ax | awk '{print $1}' | egrep '^[0-9]' | egrep ^$pid$ | wc -l`

	if [ $run -eq "1" ] ; then
		echo "CROND OK: crond is running"
		exit 0
	else
		echo "CROND CRITICAL: crond is stopped"
		exit 2
	fi
else
	echo "CROND CRITICAL: crond is stopped"
	exit 2
fi
