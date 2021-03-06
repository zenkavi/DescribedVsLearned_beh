# Test fitting in interactive container

```
docker run --rm -it -v $DATA_PATH:/ddModels zenkavi/roptim:0.0.4 bash

Rscript --vanilla /ddModels/cluster_scripts/ddm_Roptim.R --model oneIntegrator_sepProbDistortion --start_vals=0.353243110299734,0.550765508242755 --data=sub_data_distV_noExt/sub01_data --par_names=d,sigma --out_path=fitOneIntnoExt --num_optim_rounds 1 --fix_par_names=none --fix_par_vals none
```

# Move files from s3 to cluster

```
aws s3 sync s3://described-vs-experienced/ddModels/cluster_scripts/start_vals /shared/ddModels/cluster_scripts/start_vals
```

# Move files from cluster to s3

```
aws s3 sync /shared/ddModels/cluster_scripts/optim_out/fitOneIntnoExt s3://described-vs-experienced/ddModels/cluster_scripts/optim_out/fitOneIntnoExt
```

# Move files from s3 to local (this is only converged parameter values)

```
docker run --rm -it -v ~/.aws:/root/.aws -v $(pwd):/fitOneIntnoExt amazon/aws-cli s3 sync s3://described-vs-experienced/ddModels/cluster_scripts/optim_out/fitOneIntnoExt /fitOneIntnoExt --exclude "*" --include "*optim_par*"
```

# Job submission commands

## Examples for one subjets

```
sh run_ddm_Roptim.sh -m oneIntegrator_sepProbDistortion -d sub_data_oneParamAsymmLinear/sub01_data -s sub_sv_oneInt01.csv -o fitOneInt_oneParamAsymmLinear -p d,sigma
sh run_ddm_Roptim.sh -m oneIntegrator_sepProbDistortion -d sub_data_oneParamAsymmLinear_noExt/sub01_data -s sub_sv_oneInt01.csv -o fitOneIntnoExt_oneParamAsymmLinear -p d,sigma
sh run_ddm_Roptim.sh -m oneIntegrator_sepProbDistortion -d sub_data_oneParamSymmLinear/sub01_data -s sub_sv_oneInt01.csv -o fitOneInt_oneParamSymmLinear -p d,sigma
sh run_ddm_Roptim.sh -m oneIntegrator_sepProbDistortion -d sub_data_oneParamSymmLinear_noExt/sub01_data -s sub_sv_oneInt01.csv -o fitOneIntnoExt_oneParamSymmLinear -p d,sigma
```

```
sh run_ddm_Roptim.sh -m twoIntegrators_sepProbDistortion -d sub_data_oneParamAsymmLinear/sub01_data -s sub_sv_twoInts01.csv -o fitTwoInts_oneParamAsymmLinear -p dLott,dFrac,sigmaLott,sigmaFrac
sh run_ddm_Roptim.sh -m twoIntegrators_sepProbDistortion -d sub_data_oneParamAsymmLinear_noExt/sub01_data -s sub_sv_twoInts01.csv -o fitTwoIntsnoExt_oneParamAsymmLinear -p dLott,dFrac,sigmaLott,sigmaFrac
sh run_ddm_Roptim.sh -m twoIntegrators_sepProbDistortion -d sub_data_oneParamSymmLinear/sub01_data -s sub_sv_twoInts01.csv -o fitTwoInts_oneParamSymmLinear -p dLott,dFrac,sigmaLott,sigmaFrac
sh run_ddm_Roptim.sh -m twoIntegrators_sepProbDistortion -d sub_data_oneParamSymmLinear_noExt/sub01_data -s sub_sv_twoInts01.csv -o fitTwoIntsnoExt_oneParamSymmLinear -p dLott,dFrac,sigmaLott,sigmaFrac
```

## Loop to submit for more subjects

```
for subnum in 04 05 06 07 08 09 10
do
sh run_ddm_Roptim.sh -m oneIntegrator_sepProbDistortion -d sub_data_oneParamAsymmLinear/sub$subnum\_data -s sub_sv_oneInt$subnum.csv -o fitOneInt_oneParamAsymmLinear -p d,sigma
done
```
