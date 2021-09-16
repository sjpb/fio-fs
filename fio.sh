#!/usr/bin/env bash
# Basic fio-powered filesystem random read/write test from single slurm node
# Requires sudo rights on compute node
# Run as e.g.:
#   sbatch -J <jobname> fio.sh <path>

#SBATCH -N 1
#SBATCH --output=%x.%j.out
#SBATCH --error=%x.%j.out
#SBATCH --exclusive

echo SLURMD_NODENAME: $SLURMD_NODENAME
echo SLURM_NODELIST: $SLURM_NODELIST

FIO_FILE=$1

rm -f $FIO_FILE
sudo yum install -y fio
fio --output-format=json+ --rw=randrw --rwmixread=75 --randrepeat=1 --bs=64k --numjobs=4 --iodepth=64 --ioengine=libaio --direct=1 --invalidate=1 --fsync_on_close=1 --randrepeat=1 --norandommap --exitall --name=$SLURM_JOB_NAME --filename=$FIO_FILE --size=4G
