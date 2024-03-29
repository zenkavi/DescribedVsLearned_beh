library(tidyverse)
library(here)
library(brms)
helpers_path = here('analysis/helpers/')

if (!exists('clean_beh_data')){
  source(paste0(helpers_path,'fit_twoValSystemsWithRL_hierarchical.R'))
  source(paste0(helpers_path,'add_inferred_pars.R'))
  clean_beh_data = add_inferred_pars(clean_beh_data, par_ests)
}

if(file.exists(paste0(helpers_path, 'logitOut_choiceLeft_mixedEffects_conflictCollapsed.RDS'))){
  out_choiceLeft = readRDS(paste0(helpers_path, 'logitOut_choiceLeft_mixedEffects_conflictCollapsed.RDS'))
} else {
  
  probFractalDrawVals = unique(clean_beh_data$probFractalDraw)
  out_choiceLeft = data.frame(probFractalDraw=NA,iv=NA,est=NA,u95=NA,l95=NA)
  
  for(i in 1:length(probFractalDrawVals)){
    curProbFractalDraw = probFractalDrawVals[i]
    
    dat = clean_beh_data %>%
      filter(probFractalDraw == curProbFractalDraw)
    
    m = brm(choiceLeft ~ leftQVAdv + leftEVAdv + (1|subnum),
            data=dat, family=bernoulli(link="logit"), silent=2, refresh=0)
    
    est = coef(m)$subnum[1,1,2]
    u95 = coef(m)$subnum[1,3,2]
    l95 = coef(m)$subnum[1,4,2]
    
    out_choiceLeft = rbind(out_choiceLeft, c(curProbFractalDraw, "leftQVAdv", est, u95, l95))
    
    est = coef(m)$subnum[1,1,3]
    u95 = coef(m)$subnum[1,3,3]
    l95 = coef(m)$subnum[1,4,3]
    
    out_choiceLeft = rbind(out_choiceLeft, c(curProbFractalDraw,  "leftEVAdv", est, u95, l95))
  }
  
  out_choiceLeft = out_choiceLeft %>%
    drop_na()
  
  saveRDS(out_choiceLeft, paste0(helpers_path, 'logitOut_choiceLeft_mixedEffects_conflictCollapsed.RDS'))
  rm(dat, m, probFractalDrawVals, curProbFractalDraw)
}