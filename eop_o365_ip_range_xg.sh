opcode insert_hostgroup -s nosync -t json -b '{ "___username": "admin", "___component": "GUI", "Event": "ADD", "___serverip": "127.0.0.1", "hostgroupname": "EOP Range", "___serverport": 4444, "___serverprotocol": "HTTP", "APIVersion": "1700.1", "hostgrouptype": "8", "ipfamily": "0", "grouptypename": "IP Host Group", "mode": 54, "select": "0", "Entity": "iphostgroup", "description": "Exchange Online Protection IP addresses" }'
opcode add_host -s nosync -t json -b '{ "APIVersion": "1700.1", "hostname": "eop-1", "updatehostgrp": "1", "ipfamily": "0", "Entity": "iphost", "mode": 51, "netmask": "255.255.252.0", "___component": "GUI", "hosttype": "9", "hostgroupid_cat": "hostgroup", "netid": "23.103.132.0", "Event": "ADD", "___username": "admin", "___serverport": 4444, "___serverprotocol": "HTTP", "hostgroupid": [ "EOP Range" ], "transactionid": "1102", "___serverip": "127.0.0.1" }'
opcode add_host -s nosync -t json -b '{ "APIVersion": "1700.1", "hostname": "eop-2", "updatehostgrp": "1", "ipfamily": "0", "Entity": "iphost", "mode": 51, "netmask": "255.255.248.0", "___component": "GUI", "hosttype": "9", "hostgroupid_cat": "hostgroup", "netid": "23.103.136.0", "Event": "ADD", "___username": "admin", "___serverport": 4444, "___serverprotocol": "HTTP", "hostgroupid": [ "EOP Range" ], "transactionid": "1102", "___serverip": "127.0.0.1" }'
opcode add_host -s nosync -t json -b '{ "APIVersion": "1700.1", "hostname": "eop-3", "updatehostgrp": "1", "ipfamily": "0", "Entity": "iphost", "mode": 51, "netmask": "255.255.240.0", "___component": "GUI", "hosttype": "9", "hostgroupid_cat": "hostgroup", "netid": "23.103.144.0", "Event": "ADD", "___username": "admin", "___serverport": 4444, "___serverprotocol": "HTTP", "hostgroupid": [ "EOP Range" ], "transactionid": "1102", "___serverip": "127.0.0.1" }'
opcode add_host -s nosync -t json -b '{ "APIVersion": "1700.1", "hostname": "eop-4", "updatehostgrp": "1", "ipfamily": "0", "Entity": "iphost", "mode": 51, "netmask": "255.255.254.0", "___component": "GUI", "hosttype": "9", "hostgroupid_cat": "hostgroup", "netid": "23.103.198.0", "Event": "ADD", "___username": "admin", "___serverport": 4444, "___serverprotocol": "HTTP", "hostgroupid": [ "EOP Range" ], "transactionid": "1102", "___serverip": "127.0.0.1" }'
opcode add_host -s nosync -t json -b '{ "APIVersion": "1700.1", "hostname": "eop-5", "updatehostgrp": "1", "ipfamily": "0", "Entity": "iphost", "mode": 51, "netmask": "255.255.252.0", "___component": "GUI", "hosttype": "9", "hostgroupid_cat": "hostgroup", "netid": "23.103.200.0", "Event": "ADD", "___username": "admin", "___serverport": 4444, "___serverprotocol": "HTTP", "hostgroupid": [ "EOP Range" ], "transactionid": "1102", "___serverip": "127.0.0.1" }'
opcode add_host -s nosync -t json -b '{ "APIVersion": "1700.1", "hostname": "eop-6", "updatehostgrp": "1", "ipfamily": "0", "Entity": "iphost", "mode": 51, "netmask": "255.255.252.0", "___component": "GUI", "hosttype": "9", "hostgroupid_cat": "hostgroup", "netid": "23.103.212.0", "Event": "ADD", "___username": "admin", "___serverport": 4444, "___serverprotocol": "HTTP", "hostgroupid": [ "EOP Range" ], "transactionid": "1102", "___serverip": "127.0.0.1" }'
opcode add_host -s nosync -t json -b '{ "APIVersion": "1700.1", "hostname": "eop-7", "updatehostgrp": "1", "ipfamily": "0", "Entity": "iphost", "mode": 51, "netmask": "255.252.0.0", "___component": "GUI", "hosttype": "9", "hostgroupid_cat": "hostgroup", "netid": "40.92.0.0", "Event": "ADD", "___username": "admin", "___serverport": 4444, "___serverprotocol": "HTTP", "hostgroupid": [ "EOP Range" ], "transactionid": "1102", "___serverip": "127.0.0.1" }'
opcode add_host -s nosync -t json -b '{ "APIVersion": "1700.1", "hostname": "eop-8", "updatehostgrp": "1", "ipfamily": "0", "Entity": "iphost", "mode": 51, "netmask": "255.255.128.0", "___component": "GUI", "hosttype": "9", "hostgroupid_cat": "hostgroup", "netid": "40.107.0.0", "Event": "ADD", "___username": "admin", "___serverport": 4444, "___serverprotocol": "HTTP", "hostgroupid": [ "EOP Range" ], "transactionid": "1102", "___serverip": "127.0.0.1" }'
opcode add_host -s nosync -t json -b '{ "APIVersion": "1700.1", "hostname": "eop-9", "updatehostgrp": "1", "ipfamily": "0", "Entity": "iphost", "mode": 51, "netmask": "255.255.192.0", "___component": "GUI", "hosttype": "9", "hostgroupid_cat": "hostgroup", "netid": "40.107.128.0", "Event": "ADD", "___username": "admin", "___serverport": 4444, "___serverprotocol": "HTTP", "hostgroupid": [ "EOP Range" ], "transactionid": "1102", "___serverip": "127.0.0.1" }'
opcode add_host -s nosync -t json -b '{ "APIVersion": "1700.1", "hostname": "eop-10", "updatehostgrp": "1", "ipfamily": "0", "Entity": "iphost", "mode": 51, "netmask": "255.252.0.0", "___component": "GUI", "hosttype": "9", "hostgroupid_cat": "hostgroup", "netid": "52.100.0.0", "Event": "ADD", "___username": "admin", "___serverport": 4444, "___serverprotocol": "HTTP", "hostgroupid": [ "EOP Range" ], "transactionid": "1102", "___serverip": "127.0.0.1" }'
opcode add_host -s nosync -t json -b '{ "APIVersion": "1700.1", "hostname": "eop-11", "updatehostgrp": "1", "ipfamily": "0", "Entity": "iphost", "mode": 51, "netmask": "255.255.255.0", "___component": "GUI", "hosttype": "9", "hostgroupid_cat": "hostgroup", "netid": "65.55.88.0", "Event": "ADD", "___username": "admin", "___serverport": 4444, "___serverprotocol": "HTTP", "hostgroupid": [ "EOP Range" ], "transactionid": "1102", "___serverip": "127.0.0.1" }'
opcode add_host -s nosync -t json -b '{ "APIVersion": "1700.1", "hostname": "eop-12", "updatehostgrp": "1", "ipfamily": "0", "Entity": "iphost", "mode": 51, "netmask": "255.255.255.0", "___component": "GUI", "hosttype": "9", "hostgroupid_cat": "hostgroup", "netid": "65.55.169.0", "Event": "ADD", "___username": "admin", "___serverport": 4444, "___serverprotocol": "HTTP", "hostgroupid": [ "EOP Range" ], "transactionid": "1102", "___serverip": "127.0.0.1" }'
opcode add_host -s nosync -t json -b '{ "APIVersion": "1700.1", "hostname": "eop-13", "updatehostgrp": "1", "ipfamily": "0", "Entity": "iphost", "mode": 51, "netmask": "255.255.255.192", "___component": "GUI", "hosttype": "9", "hostgroupid_cat": "hostgroup", "netid": "94.245.120.64", "Event": "ADD", "___username": "admin", "___serverport": 4444, "___serverprotocol": "HTTP", "hostgroupid": [ "EOP Range" ], "transactionid": "1102", "___serverip": "127.0.0.1" }'
opcode add_host -s nosync -t json -b '{ "APIVersion": "1700.1", "hostname": "eop-14", "updatehostgrp": "1", "ipfamily": "0", "Entity": "iphost", "mode": 51, "netmask": "255.255.128.0", "___component": "GUI", "hosttype": "9", "hostgroupid_cat": "hostgroup", "netid": "104.47.0.0", "Event": "ADD", "___username": "admin", "___serverport": 4444, "___serverprotocol": "HTTP", "hostgroupid": [ "EOP Range" ], "transactionid": "1102", "___serverip": "127.0.0.1" }'
opcode add_host -s nosync -t json -b '{ "APIVersion": "1700.1", "hostname": "eop-15", "updatehostgrp": "1", "ipfamily": "0", "Entity": "iphost", "mode": 51, "netmask": "255.255.255.0", "___component": "GUI", "hosttype": "9", "hostgroupid_cat": "hostgroup", "netid": "134.170.132.0", "Event": "ADD", "___username": "admin", "___serverport": 4444, "___serverprotocol": "HTTP", "hostgroupid": [ "EOP Range" ], "transactionid": "1102", "___serverip": "127.0.0.1" }'
opcode add_host -s nosync -t json -b '{ "APIVersion": "1700.1", "hostname": "eop-16", "updatehostgrp": "1", "ipfamily": "0", "Entity": "iphost", "mode": 51, "netmask": "255.255.255.0", "___component": "GUI", "hosttype": "9", "hostgroupid_cat": "hostgroup", "netid": "134.170.140.0", "Event": "ADD", "___username": "admin", "___serverport": 4444, "___serverprotocol": "HTTP", "hostgroupid": [ "EOP Range" ], "transactionid": "1102", "___serverip": "127.0.0.1" }'
opcode add_host -s nosync -t json -b '{ "APIVersion": "1700.1", "hostname": "eop-17", "updatehostgrp": "1", "ipfamily": "0", "Entity": "iphost", "mode": 51, "netmask": "255.255.255.0", "___component": "GUI", "hosttype": "9", "hostgroupid_cat": "hostgroup", "netid": "157.55.234.0", "Event": "ADD", "___username": "admin", "___serverport": 4444, "___serverprotocol": "HTTP", "hostgroupid": [ "EOP Range" ], "transactionid": "1102", "___serverip": "127.0.0.1" }'
opcode add_host -s nosync -t json -b '{ "APIVersion": "1700.1", "hostname": "eop-18", "updatehostgrp": "1", "ipfamily": "0", "Entity": "iphost", "mode": 51, "netmask": "255.255.254.0", "___component": "GUI", "hosttype": "9", "hostgroupid_cat": "hostgroup", "netid": "157.56.110.0", "Event": "ADD", "___username": "admin", "___serverport": 4444, "___serverprotocol": "HTTP", "hostgroupid": [ "EOP Range" ], "transactionid": "1102", "___serverip": "127.0.0.1" }'
opcode add_host -s nosync -t json -b '{ "APIVersion": "1700.1", "hostname": "eop-19", "updatehostgrp": "1", "ipfamily": "0", "Entity": "iphost", "mode": 51, "netmask": "255.255.255.0", "___component": "GUI", "hosttype": "9", "hostgroupid_cat": "hostgroup", "netid": "157.56.112.0", "Event": "ADD", "___username": "admin", "___serverport": 4444, "___serverprotocol": "HTTP", "hostgroupid": [ "EOP Range" ], "transactionid": "1102", "___serverip": "127.0.0.1" }'
opcode add_host -s nosync -t json -b '{ "APIVersion": "1700.1", "hostname": "eop-20", "updatehostgrp": "1", "ipfamily": "0", "Entity": "iphost", "mode": 51, "netmask": "255.255.255.192", "___component": "GUI", "hosttype": "9", "hostgroupid_cat": "hostgroup", "netid": "207.46.51.64", "Event": "ADD", "___username": "admin", "___serverport": 4444, "___serverprotocol": "HTTP", "hostgroupid": [ "EOP Range" ], "transactionid": "1102", "___serverip": "127.0.0.1" }'
opcode add_host -s nosync -t json -b '{ "APIVersion": "1700.1", "hostname": "eop-21", "updatehostgrp": "1", "ipfamily": "0", "Entity": "iphost", "mode": 51, "netmask": "255.255.255.0", "___component": "GUI", "hosttype": "9", "hostgroupid_cat": "hostgroup", "netid": "207.46.100.0", "Event": "ADD", "___username": "admin", "___serverport": 4444, "___serverprotocol": "HTTP", "hostgroupid": [ "EOP Range" ], "transactionid": "1102", "___serverip": "127.0.0.1" }'
opcode add_host -s nosync -t json -b '{ "APIVersion": "1700.1", "hostname": "eop-22", "updatehostgrp": "1", "ipfamily": "0", "Entity": "iphost", "mode": 51, "netmask": "255.255.255.0", "___component": "GUI", "hosttype": "9", "hostgroupid_cat": "hostgroup", "netid": "207.46.163.0", "Event": "ADD", "___username": "admin", "___serverport": 4444, "___serverprotocol": "HTTP", "hostgroupid": [ "EOP Range" ], "transactionid": "1102", "___serverip": "127.0.0.1" }'
opcode add_host -s nosync -t json -b '{ "APIVersion": "1700.1", "hostname": "eop-23", "updatehostgrp": "1", "ipfamily": "0", "Entity": "iphost", "mode": 51, "netmask": "255.255.255.0", "___component": "GUI", "hosttype": "9", "hostgroupid_cat": "hostgroup", "netid": "213.199.154.0", "Event": "ADD", "___username": "admin", "___serverport": 4444, "___serverprotocol": "HTTP", "hostgroupid": [ "EOP Range" ], "transactionid": "1102", "___serverip": "127.0.0.1" }'
opcode add_host -s nosync -t json -b '{ "APIVersion": "1700.1", "hostname": "eop-24", "updatehostgrp": "1", "ipfamily": "0", "Entity": "iphost", "mode": 51, "netmask": "255.255.255.192", "___component": "GUI", "hosttype": "9", "hostgroupid_cat": "hostgroup", "netid": "213.199.180.128", "Event": "ADD", "___username": "admin", "___serverport": 4444, "___serverprotocol": "HTTP", "hostgroupid": [ "EOP Range" ], "transactionid": "1102", "___serverip": "127.0.0.1" }'
opcode add_host -s nosync -t json -b '{ "APIVersion": "1700.1", "hostname": "eop-25", "updatehostgrp": "1", "ipfamily": "0", "Entity": "iphost", "mode": 51, "netmask": "255.255.254.0", "___component": "GUI", "hosttype": "9", "hostgroupid_cat": "hostgroup", "netid": "216.32.180.0", "Event": "ADD", "___username": "admin", "___serverport": 4444, "___serverprotocol": "HTTP", "hostgroupid": [ "EOP Range" ], "transactionid": "1102", "___serverip": "127.0.0.1" }'