context("Parameter estimation and denoised data (spikes+regression)\n")

test_that("Estimates match the given seed (spikes+regression)", 
{
  # Data example
  Data <- makeExampleBASiCS_Data(WithSpikes = TRUE, WithBatch = TRUE)
  # Fixing starting values
  n <- ncol(Data); k <- 12
  PriorParam <- list(s2.mu = 0.5, s2.delta = 0.5, a.delta = 1, 
                     b.delta = 1, p.phi = rep(1, times = n), 
                     a.s = 1, b.s = 1, a.theta = 1, b.theta = 1)
  PriorParam$m <- rep(0, k); PriorParam$V <- diag(k) 
  PriorParam$a.sigma2 <- 2; PriorParam$b.sigma2 <- 2  
  PriorParam$eta <- 5
  set.seed(2018)
  Start <- BASiCS:::HiddenBASiCS_MCMC_Start(Data, PriorParam, WithSpikes = TRUE)
  # Running the sampler
  set.seed(12)
  Chain <- BASiCS_MCMC(Data, N = 1000, Thin = 10, Burn = 500, 
                       PrintProgress = FALSE, Regression = TRUE,
                       Start = Start, PriorParam = PriorParam)
  # Calculating a posterior summary
  PostSummary <- Summary(Chain)
  
  # Checking parameter names
  ParamNames <- c("mu", "delta", "phi", "s", "nu", "theta",
                  "beta", "sigma2", "epsilon")
  expect_that(all.equal(names(Chain@parameters), ParamNames), is_true())
  expect_that(all.equal(names(PostSummary@parameters), ParamNames), is_true())
            
  # Check if parameter estimates match for the first 5 genes and cells
  Mu <- c( 7.411,  4.917,  4.147,  4.609, 19.603)
  MuObs <- as.vector(round(displaySummaryBASiCS(PostSummary, "mu")[1:5,1],3))
  expect_that(all.equal(MuObs, Mu, tolerance = 1, scale = 1), is_true())
            
  Delta <- c(1.359, 2.153, 1.193, 1.686, 0.549)
  DeltaObs <- as.vector(round(displaySummaryBASiCS(PostSummary, 
                                                   "delta")[1:5,1],3))
  expect_that(all.equal(DeltaObs, Delta, tolerance = 1, scale = 1), is_true())
            
  Phi <- c( 1.060, 1.114, 0.575, 1.016, 0.806)
  PhiObs <- as.vector(round(displaySummaryBASiCS(PostSummary, "phi")[1:5,1],3))
  expect_that(all.equal(PhiObs, Phi, tolerance = 1, scale = 1), is_true())
            
  S <- c(0.301, 0.640, 0.102, 0.245, 0.582)
  SObs <- as.vector(round(displaySummaryBASiCS(PostSummary, "s")[1:5,1],3))
  expect_that(all.equal(SObs, S, tolerance = 1, scale = 1), is_true())
            
  Theta <- c(0.503, 0.607)
  ThetaObs <- as.vector(round(displaySummaryBASiCS(PostSummary, "theta")[,1],3))
  expect_that(all.equal(ThetaObs, Theta, tolerance = 1, scale = 1), is_true())
  
  Beta <- c(0.168, -0.349,  0.220,  0.210,  0.187)
  BetaObs <- as.vector(round(displaySummaryBASiCS(PostSummary, "beta")[1:5,1],3))
  expect_that(all.equal(BetaObs, Beta, tolerance = 1, scale = 1), is_true())
  
  Sigma2 <- 0.279
  Sigma2Obs <- round(displaySummaryBASiCS(PostSummary, "sigma2")[1],3)
  expect_that(all.equal(Sigma2Obs, Sigma2, tolerance = 1, scale = 1), is_true())
  
  # Obtaining denoised counts     
  DC <- BASiCS_DenoisedCounts(Data, Chain)
  
  # Checks for an arbitrary set of genes / cells
  DCcheck0 <- c(0.000, 0.000, 0.000, 4.968, 4.968)
  DCcheck <- as.vector(round(DC[1:5,1], 3))
  expect_that(all.equal(DCcheck, DCcheck0, tolerance = 1, scale = 1), is_true())
  
  # Obtaining denoised rates
  DR <- BASiCS_DenoisedRates(Data, Chain)
  
  # Checks for an arbitrary set of genes / cells
  DRcheck0 <- c(2.291, 2.808, 3.986, 2.669, 3.558)
  DRcheck <- as.vector(round(DR[10,1:5], 3))
  expect_that(all.equal(DRcheck, DRcheck0, tolerance = 1, scale = 1), is_true())
})

