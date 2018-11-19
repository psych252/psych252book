# Load packages -------------------------------------------------------------------------------

library(foreign) # for reading in SPSS file
library(tidyverse)

# Read in and structure data  -----------------------------------------------------------------

df.moral_data = read.spss("data/measuring_morality.SAV", to.data.frame=TRUE)

df.moral_labels = df.moral_data %>%
  attr("variable.labels") %>%
  as.data.frame() %>%
  set_names(c("description")) %>%
  rownames_to_column(var = "variable")
