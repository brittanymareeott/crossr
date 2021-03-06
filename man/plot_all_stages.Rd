% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plots.R
\name{plot_all_stages}
\alias{plot_all_stages}
\title{Plot the Expression of One Orthogroup in Both Species}
\usage{
plot_all_stages(orthogroup, ogset, species, condition, main = "",
  use_annos = FALSE, annos_col = NULL, ...)
}
\arguments{
\item{orthogroup}{a \code{character} string}

\item{ogset}{an ogset class element}

\item{species}{a string used to encode the species info in
the design formula}

\item{condition}{a string used to encode the experimental
conditions of the samples in the columns of the dset}

\item{main}{the title of the plot}

\item{use_annos}{\code{logical}; if TRUE, functional annotation from og_annos will be displayed in
the plot subtitle. Defaults to FALSE}

\item{annos_col}{a \code{character} string with the name of the column of og_annos that contains
the functional annotation that should be displayed. Defaults to NULL. It must be provided if \code{use_annos}
is set to TRUE.}

\item{...}{arguments to be passed to \code{stripchart}}
}
\description{
\code{plot_all_stages} is a wrapper for \code{stripchart} and plots a stripchart
and a line plot of the expression of an orthogroup across all samples
}
\details{
This function takes an orthogroup ID and an ogset class element as arguments.
It plots a stripchart of the expression of all the stages; The title of the
stripchart contains details on: how many genes are in the orthogroup, the cluster
that contain the ogroup (if any), the F-value for the interaction term.
}
