


data {
  int<lower=1> num_subjs; // number of trials per subject
  int<lower=1> num_trials[num_subjs]; // number of trials per subject
  int<lower=-1, upper=1> choices[num_subjs, 300]; // choices cast for each trial in columns
  real fractal_outcomes_left[num_subjs, 300];
  real fractal_outcomes_right[num_subjs, 300];
  real ev_left[num_subjs, 300];
  real ev_right[num_subjs, 300];
  real trial_pFrac[num_subjs, 300];
}

transformed data {
  vector[2] init_v;  
  init_v = rep_vector(0.0, 2); // initial values for EV
}

parameters {
  // Declare all parameters as vectors for vectorizing
  real<lower=0, upper=1> alpha[num_subjs];
  real<lower=0, upper=20> probDistortion[num_subjs];
  real<lower=0, upper=20> delta[num_subjs];
  real<lower=0, upper=5> beta[num_subjs];
}


model {
  vector[2] opt_val; 
  vector[2] qv; // expected value
  vector[2] PE; // prediction error
  int num_trials_for_subj;
  real w_pi;
  
  // priors
  alpha ~ beta(1, 1);
  probDistortion ~ gamma(1, 5);
  delta ~ gamma(1, 5);
  beta ~ gamma(1, 2);
  
  for(i in 1:num_subjs){
    num_trials_for_subj = num_trials[i];
    qv = init_v;
    
    for (t in 1:num_trials_for_subj) {
      
      w_pi = (delta[i]*(trial_pFrac[i, t]^probDistortion[i])) / ((delta[i]*(trial_pFrac[i, t]^probDistortion[i])) + (1-trial_pFrac[i, t])^probDistortion[i]);
      
      opt_val[1] = ((1-w_pi) * ev_left[i, t]) + (w_pi * qv[1]);
      opt_val[2] = ((1-w_pi) * ev_right[i, t]) + (w_pi * qv[2]) ;
      
      // increment target with the following likelihood function:
      choices[i, t] ~ bernoulli_logit(beta[i] * (opt_val[1]-opt_val[2]));
      // p(choice left = 1) = exp(a)/(1+exp(a)) = 1/(1+exp(-a))
      // a = beta * (V_left-V_right)
      // The higher V_left - V_right, the higher p(choice left)
      // The larger abs(beta), the more the value difference is amplified
      
      PE[1] = fractal_outcomes_left[i, t] - qv[1];
      PE[2] = fractal_outcomes_right[i, t] - qv[2];
      
      // value updating (learning) of both options
      qv[1] += alpha[i] * PE[1];
      qv[2] += alpha[i] * PE[2];
      
    }
  }
}