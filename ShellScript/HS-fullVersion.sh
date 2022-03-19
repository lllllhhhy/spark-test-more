#!/bin/bash

shopt -s expand_aliases
source ./Benchmark_Parameters.sh

VERSION=`cat ./VERSION.txt`
# Setting Color codes
green='\e[0;32m'
red='\e[0;31m'
NC='\e[0m' # No Color

sep='==================================='

usage()
{
cat << EOF
TPCx-HS version $VERSION 
usage: $0 options

This script runs the TPCx-HS (Hadoop Sort) BigData benchmark suite

OPTIONS:
   -h  Help
   -g  <TPCx-HS Scale Factor option from below>
       1   Run TPCx-HS for 1GB (For test purpose only, not a valid Scale Factor)
       2   Run TPCx-HS for 5GB
       3   Run TPCx-HS for 10GB
       4   Run TPCx-HS for 20GB
       5   Run TPCx-HS for 30GB
       6   Run TPCx-HS for 40GB
       7   Run TPCx-HS for 50GB
       8   Run TPCx-HS for 100GB
       9   Run TPCx-HS for 200GB
       10  Run TPCx-HS for 250GB

   Example: $0 -g 1

EOF
}

while getopts "hwrscpg:" OPTION; do
     case ${OPTION} in
         h) usage
             exit 1
             ;;

         w) MAINCLASS="HSGen"
             ;;
         r) MAINCLASS="HSRead"
             ;;
         s) MAINCLASS="HSSort"
             ;;
         c) MAINCLASS="HSCheckpoint"
             ;;
         p) MAINCLASS="HSPersistToDisk"
             ;;

         g)  sze=$OPTARG
 			 case $sze in
				1) hssize="10000000"
				   prefix="1GB"
				     ;;
				2) hssize="50000000"
				   prefix="5GB"
					 ;;
				3) hssize="100000000"
				   prefix="10GB"
					 ;;	
				4) hssize="200000000"
				   prefix="20GB"
					 ;;	
				5) hssize="300000000"
				   prefix="30GB"
					 ;;	
				6) hssize="400000000"
				   prefix="40GB"
					 ;;	
				7) hssize="500000000"
				   prefix="50GB"
					 ;;	
				8) hssize="1000000000"
				   prefix="100GB"
					 ;;	
				9) hssize="1500000000"
				   prefix="150GB"
					 ;;	
				10) hssize="200000000"
				   prefix="200GB"
					 ;;						 					 					 
				?) hssize="50000000"
				   prefix="5GB"
				   ;;
			 esac
             ;;
         ?)  echo -e "${red}Please choose a vlaid option${NC}"
             usage
             exit 2
             ;;
    esac
done

echo -e "${green}- Starting ${MAINCLASS} Run ${NC}"
echo -e "${green}-- MAINCLASS: ${MAINCLASS} ${NC}"

if [ -z "$hssize" ]; then
    echo
    echo -e "${red}Please specify the scale factor to use (-g)${NC}"
    echo
    usage
    exit 2
fi

if [ "$YOUR_FILE_SIZE" != "#" ];then
   echo  -e "${green}use your own file size : ${YOUR_FILE_SIZE} ${NC}"
   echo  -e "${green}use your own prefix    : ${YOUR_PREFIX} ${NC}"
   hssize="$YOUR_FILE_SIZE"
   prefix="${YOUR_PREFIX}"
fi

if [ "$MAINCLASS" == "HSGen" ];then
    #创建保存数据的目录
    sudo mkdir -p /"${FILE_BASE}"/"${INPUTDIR}"
    ls /"${FILE_BASE}"/"${INPUTDIR}"/*
    if [ $? != 0 ] ;then
    sudo rm -rf /"${FILE_BASE}"/"${INPUTDIR}"/*
    fi
(time spark-submit --class ${MAINCLASS} --deploy-mode ${SPARK_DEPLOY_MODE} --master ${SPARK_MASTER_URL} --conf "spark.driver.memory=${SPARK_DRIVER_MEMORY}" --conf "spark.executor.memory=${SPARK_EXECUTOR_MEMORY}"  --conf "spark.executor.cores=${SPARK_EXECUTOR_CORES}" --conf "spark.executor.instances=${SPARK_EXECUTOR_INSTANCES}" ${HSFullVersion_JAR} ${hssize} "${YOUR_TEMPORARY_PARTITION}" /"${FILE_BASE}"/"${INPUTDIR}") 2>&1 
    ls /"${FILE_BASE}"/"${INPUTDIR}"/*
    result=$?
elif [ "$MAINCLASS" == "HSRead" ];then
    ls /"${FILE_BASE}"/"${INPUTDIR}"/*
    if [ $? != 0 ] ;then
        echo "no input file please run the HSGen first"
        exit 2
    fi
    (time spark-submit --class ${MAINCLASS} --deploy-mode ${SPARK_DEPLOY_MODE} --master ${SPARK_MASTER_URL} --conf "spark.driver.memory=${SPARK_DRIVER_MEMORY}" --conf "spark.executor.memory=${SPARK_EXECUTOR_MEMORY}"  --conf "spark.executor.cores=${SPARK_EXECUTOR_CORES}" --conf "spark.executor.instances=${SPARK_EXECUTOR_INSTANCES}" ${HSFullVersion_JAR} /"${FILE_BASE}"/"${INPUTDIR}") 2>&1 
    result=0
elif [ "$MAINCLASS" == "HSSort" ];then
    ls /"${FILE_BASE}"/"${INPUTDIR}"/*
    if [ $? != 0 ] ;then
        echo -e "no input file please run the HSGen first"
        exit 2
    fi
    sudo mkdir -p /"${FILE_BASE}"/"${OUTPUTDIR}"
    ls /"${FILE_BASE}"/"${OUTPUTDIR}"/*
    if [ $? != 0 ] ;then
    sudo rm -rf /"${FILE_BASE}"/"${OUTPUTDIR}"/*
    fi
    (time spark-submit --class ${MAINCLASS} --deploy-mode ${SPARK_DEPLOY_MODE} --master ${SPARK_MASTER_URL} --conf "spark.driver.memory=${SPARK_DRIVER_MEMORY}" --conf "spark.executor.memory=${SPARK_EXECUTOR_MEMORY}"  --conf "spark.executor.cores=${SPARK_EXECUTOR_CORES}" --conf "spark.executor.instances=${SPARK_EXECUTOR_INSTANCES}" ${HSFullVersion_JAR} /"${FILE_BASE}"/"${INPUTDIR}" /"${FILE_BASE}"/"${OUTPUTDIR}") 2>&1 
    ls  /"${FILE_BASE}"/"${OUTPUTDIR}"/*
    result=$?
elif [ "$MAINCLASS" == "HSCheckpoint" ];then
    echo -e "${green}it just generate data in memory and store it in disk by checkpoint${NC}"
    if [ ! -d /"${FILE_BASE}"/"${CHECKPOINTDIR}" ]; then
        sudo mkdir -p /"${FILE_BASE}"/"${CHECKPOINTDIR}"
    fi
    sudo rm -rf /"${FILE_BASE}"/"${CHECKPOINTDIR}"/*
    (time spark-submit --class ${MAINCLASS} --deploy-mode ${SPARK_DEPLOY_MODE} --master ${SPARK_MASTER_URL} --conf "spark.driver.memory=${SPARK_DRIVER_MEMORY}" --conf "spark.executor.memory=${SPARK_EXECUTOR_MEMORY}"  --conf "spark.executor.cores=${SPARK_EXECUTOR_CORES}" --conf "spark.executor.instances=${SPARK_EXECUTOR_INSTANCES}" ${HSFullVersion_JAR} ${hssize} "${YOUR_TEMPORARY_PARTITION}" /"${FILE_BASE}"/"${CHECKPOINTDIR}") 2>&1 
    ls /"${FILE_BASE}"/"${CHECKPOINTDIR}"/*
    result=$?
elif [ "$MAINCLASS" == "HSPersistToDisk" ];then
    echo -e  "${green}it just generate data in memory and persist it in disk. It will be deleted after the tasks are  finished${NC}"
    if [ ! -d /"${FILE_BASE}"/"${PERSISTDIR}" ]; then
        sudo mkdir -p /"${FILE_BASE}"/"${PERSISTDIR}"
    fi
    (time spark-submit --class ${MAINCLASS} --deploy-mode ${SPARK_DEPLOY_MODE} --master ${SPARK_MASTER_URL} --conf "spark.driver.memory=${SPARK_DRIVER_MEMORY}" --conf "spark.executor.memory=${SPARK_EXECUTOR_MEMORY}"  --conf "spark.executor.cores=${SPARK_EXECUTOR_CORES}" --conf "spark.executor.instances=${SPARK_EXECUTOR_INSTANCES}" ${HSFullVersion_JAR} ${hssize} "${YOUR_TEMPORARY_PARTITION}" /"${FILE_BASE}"/"${PERSISTDIR}") 2>&1 
   result=0

else 
    echo -e  "${red}no Main class matched , exit !${NC}"
    exit 2
fi
echo -e "${green}+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${NC}"

if [ "$result" -ne 0 ];then
echo -e "${red}======== ${MAINCLASS}  FAILURE ========${NC}"
else
echo -e "${green}========  "${MAINCLASS}" SUCCESS =============${NC}"
echo -e "${green} ${VERSION} ${NC}"
fi

