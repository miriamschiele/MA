# code for data analysis of study on fragments

# set up
library("tidyverse")
library("tidyr")
library("ggplot2")
library("Rmisc")
library("lme4")
library("lmerTest")
library("emmeans")

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
# put all filler items in a seperate data set
fillerDat <- dat[dat$trial_type == "Filler",]
nrow(fillerDat)
# rename column in filler dataset to varying acceptabiltiy of filler stimuli (A-E)
colnames(fillerDat)[colnames(fillerDat) == "fragmentType_Acceptability"] = "Acceptability"

# only use critical items for analysis
dat <- dat[dat$trial_type == "Critical",]
# rename column with fragment type 
colnames(dat)[colnames(dat) == "fragmentType_Acceptability"] = "fragment_type"

#delete the following two lines after pilot study (because then trial number is added)
trial_number = c(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28)
dat$trial_number = trial_number

nrow(dat)
#
# The number of rows should be half of what it says in line 39 
# line 39 counts the total of items, i.e., critical and filler items
# but now only the critical items are relevant
# there are 50% filler items and 50% critical items in the study


# number of participants in each between-subject condition, i.e., written and auditory
dat %>% 
  ggplot(aes(x = modality, fill = response)) +
  geom_bar(position ="dodge") + theme_aida() +
  labs(x = "modality", y = "number of participants", fill = "response")


# Data plotting

# emphasis
dat %>% 
  ggplot(aes(x = emphasis, y = as.numeric(response), color = emphasis)) +
  geom_jitter(height = 0) + 
  labs(title = "Perceived naturalness of stimuli with and wihtout emphasis",
       x = "emphasis", y = "perceived naturalness") +
  scale_y_continuous(breaks=c(1:7))

# modality
dat %>% 
  ggplot(aes(x = modality, y = as.numeric(response), color = "modality")) +
  geom_jitter(height = 0) + 
  labs(title = "Perceived naturalness of auditory and written stimuli",
       x = "modality", y = "perceived naturalness") +
  scale_y_continuous(breaks=c(1:7))

# fragment type
dat %>% 
  ggplot(aes(x = fragment_type, y = as.numeric(response), 
             color = fragment_type)) +
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
  ggplot(aes(x = fragment_type, y = response, 
             color = fragment_type)) +
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
  ggplot(aes(x = fragment_type, y = response, 
             color = fragment_type)) +
  geom_jitter(height = 0) + 
  labs(title = "Auditory and written stimuli with functional and lexical fragments",
    x = "fragment type", y = "perceived naturalness", color = "fragment type") +
  scale_x_discrete(labels=c("functional", "lexical")) +
  scale_color_discrete(name = "fragment type", 
                    labels = c("functional", "lexical")) +
  facet_grid(~modality) +
  scale_y_continuous(breaks=c(1:7))

# differences in emphasis
dat %>% 
  group_by(emphasis) %>% 
  summarize(
    mean = mean(as.numeric(response)),
    SD = sd(as.numeric(response))
  )

# differences in modality
dat %>% 
  group_by(modality) %>% 
  summarize(
    mean = mean(as.numeric(response)),
    SD = sd(as.numeric(response))
  )

# differences in fragment type
dat %>% 
  group_by(fragment_type) %>% 
  summarize(
    mean = mean(as.numeric(response)),
    SD = sd(as.numeric(response))
  )


# including means and standard deviation

#emphasis
sumStatsEmp <- summarySE(dat, measurevar ="response", groupvars = "emphasis")

sumStatsEmp %>%
  ggplot(aes(x = emphasis, y = response, color = emphasis)) + 
  geom_point() +
  labs(y="percevied naturalness")+
  geom_errorbar(aes(ymin = response-ci, ymax = response+ci), width = 0.1)+
  ylim(1,7)

#modality
sumStatsMod <- summarySE(dat, measurevar ="response", groupvars = "modality")
#
sumStatsMod %>%
  ggplot(aes(x = modality, y = response, color = modality)) + 
  geom_point() +
  labs(y="percevied naturalness")+
  geom_errorbar(aes(ymin = response-ci, ymax = response+ci), width = 0.1)+
  ylim(1,7)

#fragment type
sumStatsFrag <- summarySE(dat, measurevar ="response", groupvars = "fragment_type")

sumStatsFrag %>%
  ggplot(aes(x = fragment_type, y = response, color = fragment_type)) + 
  geom_point() +
  labs(x="fragment type", y="percevied naturalness")+
  scale_x_discrete(labels=c("functional", "lexical")) +
  scale_color_discrete(name = "fragment type", 
                       labels = c("functional", "lexical")) +
  geom_errorbar(aes(ymin = response-ci, ymax = response+ci), width = 0.1)+
  ylim(1,7)


# Hypotheses testing


# first hypothesis
# Stimuli with emphasis receive higher acceptability ratings than stimuli without emphasis
# tested by linear mixed model
# as by this method:
modelemp <- lmer(data=dat, response ~ emphasis + (1|submission_id))
summary(modelemp)
# p value = 0.154

# include variance between items
modelemp2 <- lmer(data=dat, response ~ emphasis + (1|submission_id) + (1|trial_number))
summary(modelemp2)
# p value = 0.172

emmeans(modelemp2, pairwise ~ emphasis)


# second hypothesis
# auditory stimuli receive higher acceptability ratings than written stimuli
# tested by linear mixed model
# as by this method:
modelmod <- lmer(data=dat, response ~ modality + (1|submission_id))
summary(modelmod)
# p value = 0.2293

# include variance between items
modelmod2 <- lmer(data=dat, response ~ modality + (1|submission_id) + (1|trial_number))
summary(modelmod2)
# p value = 0.22925


# third hypothesis
# Stimuli with lexical fragments receive higher acceptability ratings than stimuli with functional fragments
# tested by linear mixed model
# as by this method:
modelfrag <- lmer(data=dat, response ~ fragment_type + (1|submission_id))
summary(modelfrag)
# p value = 0.543

# include variance between items
modelfrag2 <- lmer(data=dat, response ~ fragment_type + (1|submission_id) + (1|trial_number))
summary(modelfrag2)
# p value = 0.523

