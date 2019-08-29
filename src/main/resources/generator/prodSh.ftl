#!/bin/bash
source /etc/profile
source ~/.bash_profile
BUILD_ID=DONTKILLME

process_name="${atfId}-0.0.1-SNAPSHOT.jar"
process_path="/home/jar/${atfId}"
process_log="${atfId}.log"
project_name="${atfId}"

jvm_opts="-javaagent:/data/gwm/skywalking/agent/skywalking-agent.jar -Dskywalking.agent.service_name=${atfId}"
echo "---开始执行关闭${atfId}进程操作---"
pidlist=`ps -ef|grep $process_name|grep -v "grep"|awk '{print $2}'`
function stop(){
if [ "$pidlist" == "" ]
  then
    echo "----'$project_name'已经关闭----"
  else
    echo "'$project_name' 进程号 :$pidlist"
    kill -15 $pidlist
    echo "KILL $pidlist:"
fi
}

stop
pidlist2=`ps -ef|grep  $process_name|grep -v "grep"|awk '{print $2}'`
if [ "$pidlist2" == "" ]
  then
    echo "----关闭'$project_name'成功----"
  else
    echo "----关闭'$project_name'失败----"
    return 1
fi
echo "----睡眠5s开始----"
sleep 5s
echo "----睡眠5s结束----"
echo "---开始执行修改权限操作---"
cd /home/temp/test
chmod 755 $process_name
echo "---权限已修改---"

echo "---移除'$process_path'中的jar包和nohup.out---"
rm -rf $process_path/$process_name
rm -rf $process_path/$process_log
echo "---移除完毕---"

echo "---将/home/temp/test中的jar复制到'$process_path'---"
cp -rf /home/temp/test/$process_name $process_path/$process_name
echo "---复制完毕---"

echo "---启动'$project_name'进程---"
cd $process_path
nohup java $jvm_opts -jar $process_path/$process_name >> $process_path/$process_log 2>&1 &


