# code for data analysis of study on fragments

# set up
library("tidyverse")
library("tidyr")
library("brms")
library("faintr")
library("aida")
library("ggplot2")

# these options help Stan run faster
options(mc.cores = parallel::detectCores())

# read in data
dat <- read.csv("results_3_MA+study+on+fragments_MS.csv", sep=",", header=TRUE) 

# information about participants 
# age
min(dat$age, na.rm=T)
# 
max(dat$age, na.rm=T)
# 
mean(dat$age, na.rm=T)
# 

# gender
table(dat$gender)
# 
# die Zahlen pro Spalte müssen dann aber erstmal durch 56 geteilt werden oder Code nochmal überarbeiten??

# education
table(dat$education)
#   

nrow(dat)
#

# participants' comments on study
dat %>% pull(comments) %>% unique()

# data sorting and cleaning
# only analyze criticl items
dat <- dat[dat$trial_type == "Critical",]

nrow(dat)
# 
# The number of rows should be half of what it says in line 39 
# line 39 counts the total of items, i.e., critical and filler items
# but now only the critical items are relevant
# there are 50% filler items and 50% critical items in the study


# Data plotting

# number of participants in each between-subject condition, i.e., written and auditory
dat %>% 
  ggplot(aes(x = modality, fill = response)) +
  geom_bar(position ="dodge") + theme_aida() +
  labs(x = "modality", y = "number of participants", fill = "response")

# differences in modality
dat %>% 
  group_by(modality) %>% 
  summarize(
    mean = mean(as.numeric(response)),
    SD = sd(as.numeric(response))
  )

dat %>% 
  ggplot(aes(x = modality, y = as.numeric(response), color = "modality")) +
  geom_jitter(height = 0) + 
  labs(title = "Perceived naturalness of auditory and written stimuli",
       x = "modality", y = "perceived naturalness") +
  scale_y_continuous(breaks=c(1:7))

# differences in emphasis
dat %>% 
  group_by(emphasis) %>% 
  summarize(
    mean = mean(as.numeric(response)),
    SD = sd(as.numeric(response))
  )

dat %>% 
  ggplot(aes(x = emphasis, y = as.numeric(response), color = emphasis)) +
  geom_jitter(height = 0) + 
  labs(title = "Perceived naturalness of stimuli with and wihtout emphasis",
       x = "emphasis", y = "perceived naturalness") +
  scale_y_continuous(breaks=c(1:7))

# differences in fragment type
dat %>% 
  group_by(fragmentType_Acceptability) %>% 
  summarize(
    mean = mean(as.numeric(response)),
    SD = sd(as.numeric(response))
  )

dat %>% 
  ggplot(aes(x = fragmentType_Acceptability, y = as.numeric(response), color = fragmentType_Acceptability)) +
  geom_jitter(height = 0) + 
  labs(title = "Perceived naturalness of functional and lexical fragments",
    x = "fragment type", y = "perceived naturalness") +
  scale_x_discrete(labels=c("functional", "lexical")) +
  scale_color_discrete(name = "fragment type", 
                       labels = c("functional", "lexical"))+
  scale_y_continuous(breaks=c(1:7))


# modality and emphasis in one graph
dat %>% 
  ggplot(aes(x = emphasis, y = response, color = emphasis)) +
  geom_jitter(height = 0) + 
  labs(title = "Auditory and written stimuli with and without emphasis",
       x = "emphasis", y = "perceived naturalness") +
  facet_wrap(~modality) +
  scale_y_continuous(breaks=c(1:7))

# emphasis and fragment type in one graph
dat %>% 
  ggplot(aes(x = fragmentType_Acceptability, y = response, color = fragmentType_Acceptability)) +
  geom_jitter(height = 0) + 
  labs(title = "Functional and lexical fragments with and without emphasis",
    x = "fragment type", y = "perceived naturalness", color = "fragment type") +
  scale_x_discrete(labels=c("functional", "lexical")) +
  scale_color_discrete(name = "fragment type", 
                       labels = c("functional", "lexical")) +
  facet_grid(~emphasis) +
  scale_y_continuous(breaks=c(1:7))

# modality and fragment type in one graph
dat %>% 
  ggplot(aes(x = fragmentType_Acceptability, y = response, color = fragmentType_Acceptability)) +
  geom_jitter(height = 0) + 
  labs(title = "Auditory and written stimuli with functional and lexical fragments",
    x = "fragment type", y = "perceived naturalness", color = "fragment type") +
  scale_x_discrete(labels=c("functional", "lexical")) +
  scale_color_discrete(name = "fragment type", 
                    labels = c("functional", "lexical")) +
  facet_grid(~modality) +
  scale_y_continuous(breaks=c(1:7))


# Hypotheses testing

# first hypothesis
# Stimuli with emphasis receive higher acceptability ratings than stimuli without emphasis
# tested by linear mixed model
# as by this method:

# second hypothesis
# auditory stimuli receive higher acceptability ratings than written stimuli
# tested by linear mixed model
# as by this method:

# third hypothesis
# Stimuli with lexical fragments receive higher acceptability ratings than stimuli with functional fragments
# tested by linear mixed model
# as by this method:

