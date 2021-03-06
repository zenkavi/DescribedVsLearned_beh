set -e

# Default options
numOptimRounds=1
fixedParNames=none
fixedParVals=none
# parNames=d,sigma,alpha,delta

while getopts m:d:s:p:o:r:f:v: flag
do
    case "${flag}" in
        m) model=${OPTARG};;
        d) data=${OPTARG};;
        s) starts=${OPTARG};;
        p) parNames=${OPTARG};;
        o) outPath=${OPTARG};;
        r) numOptimRounds=${OPTARG};;
        f) fixedParNames=${OPTARG};;
        v) fixedParVals=${OPTARG};;
    esac
done

while IFS= read -r line;
do
    sed -e "s/{MODEL}/$model/g" -e "s/{START_VALS}/$line/g" -e "s|{DATA}|$data|g" -e "s/{PAR_NAMES}/$parNames/g" -e "s/{OUT_PATH}/$outPath/g" -e "s/{NUM_OPTIM_ROUNDS}/$numOptimRounds/g" -e "s/{FIX_PAR_NAMES}/$fixedParNames/g" -e "s/{FIX_PAR_VALS}/$fixedParVals/g" run_ddrl_Roptim.batch | sbatch
done < ./start_vals/$starts

# ./run_ddrl_Roptim.sh -m model1c -d sub_data/sub_data01 -s test.csv -o fit1 -p d,sigma,alpha,delta
# ./run_ddrl_Roptim.sh -m model1c -d sub_data/sub_data01 -s sub_start_vals01.csv -o fit1 -p d,sigma,alpha,delta
# ./run_ddrl_Roptim.sh -m model1c -d test_data/sim_single_sub_data1 -s ddrl_Roptim_start_vals1.csv -o sim1 -p d,sigma,alpha,delta
