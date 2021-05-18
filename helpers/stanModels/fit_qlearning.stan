
data {
  int<lower=1> num_subjs; // number of trials per subject
  int<lower=1> num_trials[num_subjs]; // number of trials per subject
  int<lower=1> total_trials;
  int<lower=0, upper=1> choices[total_trials]; // choices cast for each trial in columns
  real outcomes[total_trials, 2];  // for all subjects for both fractals
}

transformed data {
  vector[2] init_v;  
  init_v = rep_vector(0.0, 2); // initial values for EV
}

parameters {
  // Declare all parameters as vectors for vectorizing
  real<lower=0, upper=1> alphas[num_subjs];
  real<lower=0, upper=5> betas[num_subjs];
}


model {
  vector[2] ev; // expected value
  vector[2] PE; // prediction error
  int num_trials_for_subj;
  
  // priors
  alphas ~ beta(1, 1);
  betas ~ gamma(1, 2);
  
  for(i in 1:num_subjs){
    ev = init_v;
    
    num_trials_for_subj = num_trials[i];
    
    for (t in 1:num_trials_for_subj) {
      // compute action probabilities
      choices[t] ~ bernoulli_logit(betas[i] * (ev[1]-ev[2]));

      // prediction error
      PE[1] = outcomes[t, 1] - ev[1];
      PE[2] = outcomes[t, 2] - ev[2];
      
      // value updating (learning)
      ev[1] += alphas[i] * PE[1];
      ev[2] += alphas[i] * PE[2];
    }
  }
}
