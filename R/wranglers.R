#' Sum Expression of Orthologs
#'
#' \code{sum_groups} takes an expression matrix and a list of orthogroups.
#' It sums the expression of all the genes in one orthogroup across the samples
#' and outputs a orthogroup-wise expression matrix
#'
#' Some step are considerably slow and are parallelized with the function
#' \code{mclapply} from the package \code{parallel} the number of threads defaults to 1.
#' The gene/transcripts IDs in the orthogroups are searched for a match in the \code{rownames}
#' of the expressiom matrix using \code{\link{grep}}
#'
#' @param eset a \code{data.frame} with the a gene-wise  or transcript-wise expression matrix
#' @param ogroups a \code{list} of orthogroups, the gene names in the list should match the \code{row.names} of the datasets
#' @param mc.cores \code{numeric}, the number of threads

sum_groups <- function(eset, ogroups, mc.cores = 1)
{
    ogroups_es <- parallel::mclapply(ogroups, function(i) eset[ grep( paste( i, collapse = "|" ), rownames(eset)), ] ,
                                     mc.cores = mc.cores)
    ### This fills with NA the expression of the orthogroups with no genes for this species
    ogroups_es <- parallel::mclapply(ogroups_es, function(i) if(nrow(i) == 0) i[1, ] else i,
                                     mc.cores = mc.cores)
    ogroups_es <- parallel::mclapply(ogroups_es, function(i) apply(i, 2, sum),
                                     mc.cores = mc.cores)
    ogroups_es <- do.call(rbind, ogroups_es)
    return(ogroups_es)
}

#' Sum Expression of Orthologs in an ogset class elements
#'
#' #' \code{collapse_orthologs} takes ogset class element as input
#' It sums the expression of all the genes in one orthogroup across the samples
#' and outputs an ogset class element containing the orthologs expression matrix
#'
#'#' Some step are considerably slow and are parallelized with the function
#' \code{mclapply} from the package \code{parallel} the number of threads defaults to 1.
#'
#' @param og_set a \code{ogset} class element
#' @param mc.cores \code{numeric}, the number of threads
#'
#' @export

collapse_orthologs <- function(og_set, mc.cores = 1)
{
    if(sum(dim(og_set@spec1_exp)) == 0 |
       sum(dim(og_set@spec2_exp)) == 0 |
       length(og_set@og) == 0) {
        stop("the slots spec1_exp or spec1_exp or og are empty,
             please fill these slot with gene-wise expression
             data and orthogroup information before collapsing
             orthogroups")
    }
    ogroups_es1 <- sum_groups(eset = og_set@spec1_exp,
                              ogroups = og_set@og,
                              mc.cores = mc.cores)
    ogroups_es2 <- sum_groups(eset = og_set@spec2_exp,
                              ogroups = og_set@og,
                              mc.cores = mc.cores)
    og_eset_df <- merge(ogroups_es1, ogroups_es2,
                        by = "row.names", all = TRUE)
    rownames(og_eset_df) <- og_eset_df$Row.names; og_eset_df$Row.names <- NULL
    og_set@og_nomatch <- og_eset_df[!stats::complete.cases(og_eset_df), ]
    og_set@og_exp <- og_eset_df[stats::complete.cases(og_eset_df), ]
    return(og_set)
}


#' Utility for Converting Ids
#'
#' \code{switch_ids} is a small utility function that can be used to convert protein ID to transcript ID in an orthogroups
#'
#' @param ogroups a \code{list} of orthogroups
#' @param ids_table a \code{data.frame} that matches the protein ID to transcript ID
#' @param tx_id a \code{character} string indicating the name of the column of transcript ids in the annotation file
#' @param px_id a \code{character} string indicating the name of the column of protein ids in the annotation file
#' @param mc.cores \code{numeric}, the number of threads used for \code{mclapply}
#'
#' @export

switch_ids <- function(ogroups, ids_table, px_id, tx_id, mc.cores = 1)
{
    switcher <- function(id)
    {
        if(id %in% as.character(ids_table[, px_id])) {
            return(ids_table[which(as.character(ids_table[, px_id]) == id), tx_id])
        } else return(id)
    }
    ogroups <- parallel::mclapply(ogroups, function(i) {
        og <- unname(sapply(i, switcher))
        og[og == ""] <- "NO_MATCH"
        return(og)
        },
        mc.cores = mc.cores)
    return(ogroups)
}

