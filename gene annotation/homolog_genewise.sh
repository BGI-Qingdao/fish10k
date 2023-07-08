helpdoc(){
    cat <<EOF
Description:
        run homolog annotation
Usage:

    $0 <dir>

EOF
}

if [ $# = 0 ]
then
    helpdoc
    exit 1
fi

input_dir=$1
if [ ! -d "$input_dir" ]; then
  mkdir $input_dir
else 
  echo "$input_dir exists and continue"
fi

#user=`whoami`
#property=`stat $input_dir|sed -n '4,4p'`




cd $input_dir
if [ ! -d "02.gene/homolog" ]; then
  mkdir -p 02.gene/homolog
else
  echo "02.gene exists and continue"
fi

blat_pipeline="/dellfsqd2/ST_OCEAN/USER/songyue/bin/01.pipeline/Annotation_2016a/bin/02.gene_finding/blat_homolog_annotation_pipeline/blat_homolog_annotation.pl"

cd 02.gene/homolog

for i in `ls /dellfsqd2/P18Z19700N0073/changyue/Fish10K/00.genome/WorkShell/ref_pep_for_genewise/*.pep` ; do
  dir=`basename $i` 
  mkdir $dir 
  cd $dir
  rm homolog.sh homolog.log nohup.out homolog_rerun.sh homolog_rerun.log 
  ln -s /dellfsqd2/P18Z19700N0073/changyue/Fish10K/14.MS/29.for_nature/00.data/$input_dir/*.fa ./genome.fa
  echo "export WISEDIR=\"/zfsqd1/biosoft/pipeline/DNA/DNA_annotation/software/gene/genewise/wise2.4.1\"" >> homolog.sh
  echo "export WISECONFIGDIR=\"/zfsqd1/biosoft/pipeline/DNA/DNA_annotation/software/gene/genewise/wise2.4.1/wisecfg\"" >> homolog.sh
  echo "nohup perl $blat_pipeline -p $i -r genome.fa -s 1234 -t 5 -a 0.3 -d 0.2 -c 50  -e 1000 -q \"-P P18Z19700N0069 -l num_proc=1\" > homolog.log & " >> homolog.sh
#  /bin/sh homolog.sh &
  echo $input_dir has been running Homology clean
  cd ../
done 
cd -
