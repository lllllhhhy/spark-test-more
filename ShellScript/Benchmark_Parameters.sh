# in ./Benchmark_Parameters.sh  -- contains all the parameters that you can change.

#----------------------------------- you should change them according your linux machine.
# the base directory mentioned above. Be sure it is mounted on specific disk.
FILE_BASE=hdfs-fast
# be sure `SPARK_DRIVER_MEMORY` + `SPARK_EXECUTOR_MEMORY` < your available memory
SPARK_DRIVER_MEMORY=3g
SPARK_EXECUTOR_MEMORY=12g
# myabe (1.0-2.0)*your CPU Cores.
SPARK_EXECUTOR_CORES=40 
# local[num] --> the num means the  number of CPU core used in local mode.
# it is better is keep it similar to `SPARK_EXECUTOR_CORES`
SPARK_MASTER_URL="local[40]"

#----------------------------------- you can change them if you would like to.
CHECKPOINTDIR="checkpointdir"
PERSISTDIR="persistdir"
INPUTDIR="input"
OUTPUTDIR="output"
 # change it if you need.
YOUR_FILE_SIZE="#"
# cahnge it if you need.
YOUR_PREFIX="#"
# when it is -1, use the `local[num]` num as partition, otherwise use the given value
YOUR_TEMPORARY_PARTITION=-1 
#----------------------------------- maybe keep them unchanged.
# keep it unchanged in local mode.
SPARK_EXECUTOR_INSTANCES=1
# DEPLOY_MODE one of 'cluster' or 'client'
SPARK_DEPLOY_MODE="client"
# the jar file containing the Main class.
HSFullVersion_JAR="HS-finalVersion.jar"
