% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/parsers.R
\name{get_TPM}
\alias{get_TPM}
\title{Extracts TPM from a Salmon Output File}
\usage{
get_TPM(path)
}
\arguments{
\item{path}{a character string, the path to the (quant.sf) Salmon output}
}
\description{
\code{get_TPM} is a wrapper for \code{\link{read.csv}} that loads and extracts
TPM from a salmon output file (quant.sf) provided in \code{path}
}
