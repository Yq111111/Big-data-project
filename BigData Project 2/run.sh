#!/bin/bash
cd src/Final3/target
spark-submit --master local[*] --driver-memory 16g --executor-memory 4g --class crossvalidation Final3-1.0-SNAPSHOT.jar