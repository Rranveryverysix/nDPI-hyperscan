#!/bin/bash

# 定义测试包路径和ndpiReader路径
pcap_file="/root/home/mike/PcapDoc/CS3Sthlm-KraftCERT-171025.pcap"
ndpiReader="/root/home/mike/nDpi/nDPI/example/ndpiReader"

# 运行ndpiReader，不使用Hyperscan记录运行时间、内存占用和CPU利用率到before_hs.txt
echo "Running ndpiReader without Hyperscan..."
(time $ndpiReader -i $pcap_file -s 10 > /dev/null) 2> before_hs.txt
ps -p $$ -o rss=,pcpu= >> before_hs.txt

# 运行ndpiReader，使用Hyperscan记录运行时间、内存占用和CPU利用率到after_hs.txt
echo "Running ndpiReader with Hyperscan..."
(time $ndpiReader -i $pcap_file -s 10 -h /root/home/mike/hs_build/libhs.so > /dev/null) 2> after_hs.txt
ps -p $$ -o rss=,pcpu= >> after_hs.txt

# 统计匹配流的数量
before_match_num=$(grep "Total flows processed:" before_hs.txt | awk '{print $4}')
after_match_num=$(grep "Total flows processed:" after_hs.txt | awk '{print $4}')

# 输出结果
echo "Before Hyperscan: ${before_match_num} flows matched in $(grep "real" before_hs.txt | awk '{print $2}') seconds"
echo "After Hyperscan: ${after_match_num} flows matched in $(grep "real" after_hs.txt | awk '{print $2}') seconds"
