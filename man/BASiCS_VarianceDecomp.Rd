% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/BASiCS_VarianceDecomp.R
\name{BASiCS_VarianceDecomp}
\alias{BASiCS_VarianceDecomp}
\title{Decomposition of gene expression variability according to BASiCS}
\usage{
BASiCS_VarianceDecomp(Chain, OrderVariable = "BioVarGlobal", Plot = TRUE,
  ...)
}
\arguments{
\item{Chain}{an object of class \code{\linkS4class{BASiCS_Chain}}}

\item{OrderVariable}{Ordering variable for output. 
Possible values: \code{'GeneName'}, \code{'BioVarGlobal'},
 \code{'TechVarGlobal'} and \code{'ShotNoiseGlobal'}. 
Default: \code{OrderVariable = "BioVarGlobal"}.}

\item{Plot}{If \code{TRUE}, a barplot of the variance decomposition 
(global and by batches, if any) is generated. Default: \code{Plot = TRUE}.}

\item{...}{Other arguments to be passed to \code{\link[graphics]{barplot}}}
}
\value{
A \code{\link[base]{data.frame}} whose first 4 columns correspond to
\describe{
\item{\code{GeneName}}{Gene name (as indicated by user)}
\item{\code{BioVarGlobal}}{Percentage of variance explained by a biological 
                           component (overall across all cells)}
\item{\code{TechVarGlobal}}{Percentage of variance explained by the technical 
                            component (overall across all cells)}
\item{\code{ShotNoiseGlobal}}{Percentage of variance explained by the shot 
                              noise component (baseline Poisson noise, 
                              overall across all cells)}
}
If more than 1 batch of cells are being analysed, the remaining columns 
contain the corresponding variance decomposition calculated within each batch.
}
\description{
Function to decompose total variability of gene 
expression into biological and technical components.
}
\details{
See vignette
}
\examples{

# For illustration purposes we load a built-in 'BASiCS_Chain' object 
# (obtained using the 'BASiCS_MCMC' function)
data(ChainSC)

VD <- BASiCS_VarianceDecomp(ChainSC)

}
\references{
Vallejos, Marioni and Richardson (2015). PLoS Computational Biology.
}
\seealso{
\code{\linkS4class{BASiCS_Chain}}
}
\author{
Catalina A. Vallejos \email{cnvallej@uc.cl}
}
