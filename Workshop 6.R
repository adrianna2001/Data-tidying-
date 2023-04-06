# Week 6
# 27.02.2023

#Adrianna Podolak


# 1. Philosophy of tidy data -----------------------------------------------

# The basic structure of tidy data is the table
 # Each row is an observation
 # Each column is a variable
 # Each value has its own cell

# Organising your data in this way ensures that values of different variables 
# from the same observation are always paired.

# use read.table and adjust header, separator, row.names etc to read in data sets 

# Example 

beetles1 <- read.csv("dung_beetles_v1.csv")
beetles1


# Can represent the same data in multiple ways without changing actual values 

# 1st way
beetles2 <- read.csv("dung_beetles_v2.csv")
beetles2


# 2nd way
beetles3 <- read.csv("dung_beetles_v3.csv")
beetles3

# 3rd way 
beetles4 <- read.csv("dung_beetles_v4.csv")
beetles4

# Let’s say you want to count the number of unique sites
# Select the ‘Site’ column from beetles1, 
# pass it to the ‘unique’ function to get all the unique values,
# and count the length of the vector

usites <- unique(beetles1$Site)
length(usites)

# What about counting the number of species from ‘beetles1’?
colnames(beetles1)[3:ncol(beetles1)]

# Just no. We should not have to use two different ways
# to perform the same calculation on different parts of the dataset.

# use the ‘unique’ and ‘length’ functions to count the number of species using ‘beetles3’.
# how many beetle species are there?

uspecies <- unique(beetles3$spp)
length(uspecies)

# which ‘beetles’ table lets you count all unique values for Sites, Months and Species?

# table beetles 4 

unique_sites <- unique(beetles4$Site)
length(unique_sites)

unique_species <- unique(beetles4$spp)
length(unique_species)

unique_months <- unique(beetles4$Month)
length(unique_months)


# Overview of a dataset ---------------------------------------------------

# Not all datasets can be viewed directly in the console; 
# for larger tables R provides you with a range of different functions to get an overview of the data.
# You need to understand your messy data before you can clean it.

# We can take a look at this data with a number of different functions:
# 1. str() 
# 2. summary()
# 3. head()
# 4. View()   # <-- this one is in Rstudio only


# Take a look at the ‘beetles4’ table with each of these functions

str(beetles4) # shows number of variables, class of the object

summary(beetles4) # shows class and length for characters, calculates min,max and 
# mean for integers, however also for the datapoints that are not measurements but just order numbers, 
# does  not show individual values in each cell 
?summary

head(beetles4) # just shows the top part of your table 

View(beetles4) # shows you the whole table 


# Reading tables ----------------------------------------------------------

# Let’s read in a larger table. 
# This time we’re going to use ‘read.table’;
# this is what ‘read.csv’ actually uses under the hood.

beetlesdf <- read.table("dung_beetles_read_1.csv",
                        sep=",",
                        header=T)  # notice how we set the separator

# Notice how we had to set the separator and tell ‘read.table’ that this file has a header.
# These were set by default in ‘read.csv’.

# ‘read.table’ is a bit more complex, but a lot more flexible.
# Changing the default arguments lets us read in files in many different formats.

dung_beetles_read_2 <- read.table("dung_beetles_read_2.txt",
                                  sep = '\t',
                                  header = T) # tab is the whitespace in this text file 
?read.table

dung_beetles_read_3 <- read.table("dung_beetles_read_3.txt", 
                                  sep = '\t',
                                  header = T,
                                  skip = 1) # skip tells to skip the first line as it is not the true header 
str(dung_beetles_read_3)



# Fill  -------------------------------------------------------------------

# ‘beetlesdf’ has a common problem; 
# to aid readability the people generating this table printed each site number only once. 
# This is good for humans, bad for computers. 
# We need to fill these blank spaces with the values above.

# This is a common enough problem that someone else has made a function for you.
# Logically enough, it is called ‘fill’. 
# Fill is in a package called ‘tidyr’. 

# Load the library and take a look at the help page for ‘fill’:

# install.packages("tidyr")
library(tidyr)

?fill 

# The usage page tells you how to fill values using this function; 
# replace ‘data’ with your table name, and the ‘…’ with the names of the columns to fill. 
# Give it a go:

fill(beetlesdf,Site)  

# If you’re happy with this table, you can overwrite the original table with your fixed version

beetlesdf <- fill(beetlesdf,Site)  #careful - this is a common source of errors

# This code should read this file in and fill in the missing values. It does not. Why not?

beetlesdf2 <- read.table("dung_beetles_read_4.txt") # in this table the first line
# is a header but by default header in this code is false, so it takes it as a value 

fill(beetlesdf2,Site) # does not work cause the column site does not exist as header is set to false 

# fix this code so it reads the file in and fills in the missing values

beetlesdf2_corrected <- read.table('dung_beetles_read_4.txt',
                                   header = TRUE,
                                   sep = '\t',
                                   na.strings = "-") # you need NA to use fill function effectively
# in this dataset it is a '-', tell R every time there is a '-' substitute it with na by na.string 

# beetlesdf2_corrected[beetlesdf2_corrected$Site == "-",]$Site <- NA

fill(beetlesdf2_corrected, Site)

beetlesdf2_corrected <- fill(beetlesdf2_corrected, Site)


# The pipe ----------------------------------------------------------------

# Where we have more than one function applied to a table,
# R has a way to take the output of one function, 
#and shove it straight into the next. This is called piping.

# The symbol we use for a pipe is: ‘%>%’

# We can join a read.table directly to a fill as follows:

beetlesdf <- read.table("dung_beetles_read_1.csv", sep=",",header=T) %>% fill(Site)

# notice how the output of both functions is now placed in the variable ‘beetlesdf’

# We will use this more as we start to join these data tidying operations together.


# Pivoting ----------------------------------------------------------------

# Now we can read in and fill files, what else do we need to tidy them?
  
# As we saw in section 2, the beetles data set has one of the common problems in untidy data:
# column headers are values, not variable names. 
# ‘tidyr’ has more functions designed to deal with this issue. Welcome to pivoting.


# Pivot longer ------------------------------------------------------------

#Have a look at the help page to see how it works. 
?pivot_longer

# For this next step we’re going to use the function ‘pivot_longer’, 
# this will manipulate your table so those column names become variables. 


pivot_longer(data=beetlesdf, cols = c("Caccobius_bawangensis", "Catharsius_dayacus", "Catharsius_renaudpauliani", "Copis_agnus", "Copis_ramosiceps", "Copis_sinicus", "Microcopis_doriae", "Microcopis_hidakai"),names_to="Spp")

# perform this same pivot, but select columns using their numerical index

pivot_longer(data = beetlesdf, cols = 3:10)


# Selecting columns can be done in many ways. Some of them are very complex.
# In the help page, click on the link that says <tidy_select>.
# There’s lots of functions like ‘starts_with()’, ‘ends_with()’, ‘last_col()’. 
# These can replace your list of columns like this:

pivot_longer(data=beetlesdf, 
             cols = starts_with("C") ) # This code is neater, but it’s not selecting all our values is it?

# look through the possible ways of selecting columns, 
# can you find a selection helper that selects all your values?

beetlesdf_pivot_species <- pivot_longer(data = beetlesdf,
                                        cols = matches('_')) # select all columns which have '_', 
# this is found in all species columns, use matches () to match this expression 

# OK, so now we can pivot our table, but ‘value’ is very generic.

# using the help page for pivot_longer, figure out how to change ‘value’ to ‘count’

beetlesdf_pivot_species <- pivot_longer(data = beetlesdf, 
                                        cols = matches('_'),
                                        values_to = 'count') # add values_to = 'count' 


# Pivot wider -------------------------------------------------------------

# What about the opposite problem? where multiple variables are stored in one column.

# Let’s take a look at a new data set. 
# This is from the W.H.O. World Malaria Report. 
# A dataset that is produced every year detailing the number of reported malaria cases 
# and other information to help plan disease control measures.

# This is a real-world application of Data Science that literally saves lives.
# But we can only do this… if we have cleaned the data.


casesdf <- read.table("WMR2022_reported_cases_1.txt",
                      sep="\t")
casesdf

# first, use what you know about ‘read.table’ and ‘fill’ to fix this piece of code

str(casesdf)

casesdf <- read.table("WMR2022_reported_cases_1.txt",
                      sep="\t",
                      header=TRUE,
                      na.strings = '')
fill(casesdf, country)

casesdf <- fill(casesdf,country)

# Here each row isn’t a single observation - instead each country is one observation, 
# and the different numbers of suspected / examined / confirmed cases are variables of that observation. 
# So we want to take values from the ‘method’ column, 
# and spread them out as individual columns: the number of columns this makes 
# will depend on the number of unique values in ‘method’.

# The function we use for this is ‘pivot_wider’

pivot_wider(casesdf,
            names_from="method",
            values_from ="n")


# Big challenge -----------------------------------------------------------

# We often have to use many of these functions together.
# If you look at a larger section of the malaria cases data 
# you’ll see that the full table has the data for all years between 2010 and 2021.

malaria_cases <- read.table("WMR2022_reported_cases_2.txt",
                            sep="\t", 
                            header = TRUE,
                            na.strings = '')

# 1. Fill empty cells in the country column

malaria_cases <- fill(malaria_cases, country)

# 2. Use pivot_longer to move all years into a single column

malaria_cases_pivot_year <- pivot_longer(data = malaria_cases,
                                         cols = starts_with('X'), 
                                         names_to = 'year')

# 3. Use pivot_wider move all the method variables into their own column

malaria_cases_pivoted_twice <- pivot_wider(data = malaria_cases_pivot_year,
                                           names_from = 'method', 
                                           values_from = 'value')
?pivot_wider()
# 4. Use the gsub() to remove X that is in front of the year 

malaria_years_column <- gsub(pattern = '^X',
                             replacement = '',
                             x = malaria_cases_pivoted_twice$year)

malaria_cases_pivoted_twice$year <- malaria_years_column

# 4. Can you use the pipe function to achieve this in a single command?

malaria_cases <- read.table("WMR2022_reported_cases_2.txt",
                            sep="\t",
                            header = TRUE,
                            na.strings = '') %>% 
  fill(country) %>% 
  pivot_longer(cols = starts_with('X'),
               names_to = 'year') %>%
  pivot_wider(names_from = 'method',
              values_from = 'value')
