#######################
# Usage
#######################

# For scatter plots
# Rscript --vanilla par_recovery_plots.R --data_names sim_single_sub_data1,sim_single_sub_data2,sim_single_sub_data3,sim_single_sub_data4,sim_single_sub_data5,sim_single_sub_data6,sim_single_sub_data7,sim_single_sub_data8,sim_single_sub_data9,sim_single_sub_data10,sim_single_sub_data11,sim_single_sub_data12,sim_single_sub_data13,sim_single_sub_data14,sim_single_sub_data15,sim_single_sub_data16 --scatter

# For histograms
# Rscript --vanilla par_recovery_plots.R --histogram --data_names sim_single_sub_data1,sim_single_sub_data2,sim_single_sub_data3,sim_single_sub_data4,sim_single_sub_data5,sim_single_sub_data6,sim_single_sub_data7,sim_single_sub_data8,sim_single_sub_data9,sim_single_sub_data10,sim_single_sub_data11,sim_single_sub_data12,sim_single_sub_data13,sim_single_sub_data14,sim_single_sub_data15,sim_single_sub_data16,sim_single_sub_data17,sim_single_sub_data18,sim_single_sub_data19,sim_single_sub_data20

# For diff_pct
# Rscript --vanilla par_recovery_plots.R --diff_pct --data_names sim_single_sub_data1,sim_single_sub_data2,sim_single_sub_data3,sim_single_sub_data4,sim_single_sub_data5,sim_single_sub_data6,sim_single_sub_data7,sim_single_sub_data8,sim_single_sub_data9,sim_single_sub_data10,sim_single_sub_data11,sim_single_sub_data12,sim_single_sub_data13,sim_single_sub_data14,sim_single_sub_data15,sim_single_sub_data16,sim_single_sub_data17,sim_single_sub_data18,sim_single_sub_data19,sim_single_sub_data20,sim_single_sub_data21,sim_single_sub_data22,sim_single_sub_data23,sim_single_sub_data24 --fig_fn ddrl_recovery_sim1 --optim_out_path="ddrlModels/cluster_scripts/optim_out/sim1/" --true_pars_path="ddrlModels/cluster_scripts/test_data/" --model model1c

#######################
# Setup
#######################

library(here)
library(optparse)
library(gridExtra)
helpers_path = here('analysis/helpers/')
cpueaters_paths = '/Users/zeynepenkavi/CpuEaters/DescribedVsLearned_beh/analysis/helpers/'

#######################
# Parse input arguments
#######################
option_list = list(
  make_option("--data_names", type="character", default = c('sim_single_sub_data1', 'sim_single_sub_data2')),
  make_option("--optim_out_path", type="character", default = 'ddModels/cluster_scripts/optim_out/'),
  make_option("--true_pars_path", type="character", default = 'ddModels/cluster_scripts/test_data/'),
  make_option("--par_names", type="character", default = c("d", "sigma", "alpha", "delta")),
  make_option("--fig_out_path", type="character", default = '/outputs/fig/'),
  make_option("--fig_fn", type="character", default = 'ddm_recovery_sim0'),
  make_option("--model", type="character", default = 'model1a'),
  make_option("--scatter", type="logical", action = 'store_true', default=FALSE),
  make_option("--histogram", type="logical", action = 'store_true', default=FALSE),
  make_option("--diff_pct", type="logical", action = 'store_true', default=FALSE)
) 

opt_parser = OptionParser(option_list=option_list)
opt = parse_args(opt_parser)

#######################
# Initialize parameters from input arguments
#######################

# If using string input must be separated by "," 
data_names = opt$data_names
if(length(data_names) == 1){
  if(grepl(',', data_names)){
    data_names = strsplit(data_names, ',')[[1]] 
  }
}

optim_out_path = paste0(cpueaters_paths, opt$optim_out_path)
true_pars_path = paste0(helpers_path, opt$true_pars_path)

par_names = opt$par_names
# If using string input convert to vector
if(length(par_names) == 1){
  if(grepl(',', par_names)){
    par_names = gsub(" ", "", par_names) #remove spaces
    par_names = strsplit(par_names, ',')[[1]]
  }
}
param_dict = data.frame(Param1=par_names[1], Param2=par_names[2], Param3=par_names[3], Param4=par_names[4], Result="nll")

# Must end with /
# out_path = opt$out_data
fig_out_path = paste0(here(), opt$fig_out_path)
fig_fn = opt$fig_fn

model = opt$model

scatter = opt$scatter
histogram = opt$histogram
diff_pct = opt$diff_pct

#######################
# Loop through datasets
#######################

source(paste0(helpers_path, 'optimPostProcess/par_recovery_report.R'))
# sem <- function(x) {sd(x, na.rm=T) / sqrt(length(x))}

n_datasets = length(data_names)

scatter_rows = list()
hist_rows = list()
diff_pct_plots = list()

for(i in 1:n_datasets){
  
  if(diff_pct){
    tmp = par_recovery_report(model_ = model, data_ = data_names[i], optim_out_path_ = optim_out_path, diff_pct_plots_ = TRUE, true_pars_path_=true_pars_path, param_dict_=param_dict)
    
    if(length(tmp) > 0){
      cur_diff_pct_plot = tmp$plots[[1]]
      diff_pct_plots[[i]] = cur_diff_pct_plot
    } else {
      next
    }
    
  } else if (scatter){
    tmp = par_recovery_report(model_ = model, data_ = data_names[i], optim_out_path_ = optim_out_path, diff_pct_plots_ = FALSE, start_end_scatter_ = TRUE, true_pars_path_=true_pars_path, param_dict_=param_dict)
    
    if(length(tmp) > 0){
      cur_scatter_row = arrangeGrob(grobs=tmp$plots, nrow=1, top = tmp$true_pars)
      scatter_rows[[i]] = cur_scatter_row
    } else {
      next
    }
    
  } else if (histogram){
    tmp = par_recovery_report(model_ = model, data_ = data_names[i], optim_out_path_ = optim_out_path,  diff_pct_plots_ = FALSE, par_hist_ = TRUE, true_pars_path_=true_pars_path, param_dict_=param_dict)
    
    if(length(tmp) > 0){
      cur_hist_row = arrangeGrob(grobs=tmp$plots, nrow=1, top = tmp$true_pars)
      hist_rows[[i]] = cur_hist_row
    } else {
      next
    }
  }
  
}

if(diff_pct){
  g = marrangeGrob(grobs = diff_pct_plots, nrow=4, ncol=4)
  ggsave(file=paste0(fig_out_path, fig_fn, '_diff_pct.pdf'), g, height = 8, width=11, units="in")
}

if(scatter){
  g = marrangeGrob(grobs = scatter_rows, nrow=4, ncol=1)
  ggsave(file=paste0(fig_out_path, fig_fn, '_scatter.pdf'), g, height = 8, width=11, units="in")
}

if(histogram){
  g = marrangeGrob(grobs = hist_rows, nrow=4, ncol=1)
  ggsave(file=paste0(fig_out_path, fig_fn, '_hist.pdf'), g, height = 8, width=11, units="in")
}
