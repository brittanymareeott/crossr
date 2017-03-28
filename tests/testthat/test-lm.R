require(testthat)

context("linear model and ANOVA work correctly")

test_that("add_fit takes any design within coldata", {
    load(file = "sample_oges.Rdata")
    coldata <- data.frame(spc = substr(colnames(dat), 1, 2),
                          stg = substr(colnames(dat), 4, 4),
                          row.names = colnames(dat))

    expect_error(add_fit(dat = dat, coldata = coldata, design = ciao))
    expect_s3_class(add_fit(dat = dat,
                            coldata = coldata,
                            design = ~ 0 + spc + stg + spc:stg), "data.frame")
})