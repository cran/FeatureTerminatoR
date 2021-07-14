## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup, message=FALSE, echo=TRUE------------------------------------------
library(FeatureTerminatoR)
library(caret)
library(dplyr)
library(ggplot2)
library(randomForest)

## ----setup_test_data----------------------------------------------------------
df <- iris
print(head(df,10))

## ----rfe_model_fit------------------------------------------------------------
#Passing in the indexes as slices x values located in index 1:4 and y value in location 5
rfe_fit <- rfeTerminator(df, x_cols= 1:4, y_cols=5, alter_df = TRUE, eval_funcs = rfFuncs)
#Passing by column name
rfe_fit_col_name <- rfeTerminator(df, x_cols=1:4, y_cols="Species", alter_df=TRUE)
# A further example
ref_x_col_name <- rfeTerminator(df,
                                x_cols=c("Sepal.Length", "Sepal.Width",
                                        "Petal.Length", "Petal.Width"),
                                y_cols = "Species")

## ----rfe_model_fit_results----------------------------------------------------
#Explore the optimal model results
print(rfe_fit$rfe_model_fit_results)
#View the optimum variables selected
print(rfe_fit$rfe_model_fit_results$optVariables)

## ----rfe_orig_data------------------------------------------------------------
#Explore the original data passed to the frame
print(head(rfe_fit$rfe_original_data))

## ----reduced_data-------------------------------------------------------------
#Explore the data adapted with the less important features removed
print(head(rfe_fit$rfe_reduced_data))


## ----mult_co_fit--------------------------------------------------------------
#Fit a model on the results and define a confidence cut off limit
mc_term_fit <- FeatureTerminatoR::mutlicol_terminator(df, x_cols=1:4,
                                   y_cols="Species",
                                   alter_df=TRUE,
                                   cor_sig = 0.90)


## ----visualise, fig.width=8, fig.height=6-------------------------------------
# Visualise the quantile distributions of where the correlations lie
mc_term_fit$corr_quant_chart


## ----correlation_matrix-------------------------------------------------------
# View the correlation matrix
mc_term_fit$corr_matrix
# View the covariance matrix
mc_term_fit$cov_matrix
# View the quantile range
mc_term_fit$corr_quantile #This excludes the diagonal correlations, as this would inflate the quantile distribution

## ----reduced_data_mc----------------------------------------------------------
# Get the removed and reduced data
new_df_post_feature_removal <- mc_term_fit$feature_removed_df
glimpse(new_df_post_feature_removal)

