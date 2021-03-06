context("Individual MCMC updates (cpp code)\n")

test_that("Dirichlet sampler", {
  # Generating arbitrary hyper-param
  phi0 <- 1:10; phi0 <- phi0/sum(phi0)
  set.seed(2018)
  x <- as.vector(BASiCS:::Hidden_rDirichlet(phi0))
  
  set.seed(2018)
  x0 <- rgamma(length(phi0), shape = phi0, scale = 1)
  x0 <- x0 / sum(x0)
  
  expect_that(all.equal(x, x0), is_true())
})

test_that("Spikes + no regression", {
  
  Data <- makeExampleBASiCS_Data(WithSpikes = TRUE)
  CountsBio <- assay(Data)[!isSpike(Data),]
  q0 <- nrow(CountsBio); n <- ncol(CountsBio)
  PriorParam <- list(s2.mu = 0.5, s2.delta = 0.5, a.delta = 1, 
                     b.delta = 1, p.phi = rep(1, times = n), 
                     a.s = 1, b.s = 1, a.theta = 1, b.theta = 1)
  set.seed(2018)
  Start <- BASiCS:::HiddenBASiCS_MCMC_Start(Data, PriorParam, WithSpikes = TRUE)
  uGene <- rep(0, times = q0)
  indGene <- rbinom(q0, size = 1, prob = 0.5)
  
  # Hidden_muUpdate
  mu1 <- pmax(0, Start$mu0[seq_len(q0)] + rnorm(q0, sd = 0.005))
  Aux <- BASiCS:::Hidden_muUpdate(mu0 = Start$mu0[seq_len(q0)], 
                                  prop_var = exp(Start$ls.mu0),
                                  Counts = CountsBio, invdelta = 1/Start$delta0, 
                                  phinu = Start$phi0 * Start$nu0,
                                  sum_bycell_bio = rowSums(CountsBio),
                                  s2_mu = PriorParam$s2.mu, q0 = q0, n = n,
                                  mu1 =  mu1, u = uGene, ind = indGene)
  
  mu1 <- c(14.47,  7.19,  5.20,  9.90, 19.82)
  mu1Obs <- round(Aux[1:5,1],2) 
  expect_that(all.equal(mu1, mu1Obs), is_true())

  ind <- c(1, 0, 1, 1, 1)
  indObs <- Aux[1:5,2]
  expect_that(all.equal(ind, indObs), is_true())  
})
