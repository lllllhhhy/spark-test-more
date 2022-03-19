# spark-test-more

The steps above can make you clear how to run the shell to start the spark programs to test the disk:
- ./HS-fullVersion.sh -w -g 1 # write with hadoop API.
- ./HS-fullVersion.sh -r -g 1 # read with hadoop API.
- ./HS-fullVersion.sh -s -g 1 # write and read with Hadoop API.
- ./HS-fullVersion.sh -c -g 1 # checkpoint data to disk.
- ./HS-fullVersion.sh -p -g 1 # persist(DISK_ONLY) data to disk.

