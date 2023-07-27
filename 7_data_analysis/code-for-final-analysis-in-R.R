# code for data analysis of study on fragments

# set up
library("tidyverse")
library("tidyr")
library("ggplot2")
library("Rmisc")
library("lme4")
library("lmerTest")
library("emmeans")
library("dplyr")
library("pwr")
library("aida")

# read in data
all.dat <- read.csv("full_dataset_raw.csv", sep=",", header=TRUE) 

# information about participants 
# age
min(all.dat$age, na.rm=T)
# 19 
max(all.dat$age, na.rm=T)
# 73 
mean(all.dat$age, na.rm=T)
# 35.2549

# gender
table(all.dat$gender)/56 #divided by 56 because every participants had 56 trials
# divers  männlich  weiblich
# 2       70         31

# education
table(all.dat$education) /56 #divided by 56 because every participants had 56 trials
#H\xf6herer Abschluss     Abitur             Bachelor 
#35                       30                 29
#kein Abitur 
#9       

# number of participants in each between-subject condition, i.e., written and auditory
table(all.dat$modality)  /56
# auditory  written 
# 58         45

nrow(all.dat)
# 5768

# participants' comments on study
all.dat %>% pull(comments) %>% unique()

# data sorting and cleaning

# put all filler items in a seperate data set
fillerDat <- all.dat[all.dat$trial_type == "Filler",]

# rename column in filler dataset to varying acceptabiltiy of filler stimuli (A-E)
colnames(fillerDat)[colnames(fillerDat) == "fragmentType_Acceptability"] = "acceptability"

# only use critical items for analysis
dat <- all.dat[all.dat$trial_type == "Critical",]
# rename column with fragment type 
colnames(dat)[colnames(dat) == "fragmentType_Acceptability"] = "fragment_type"

nrow(dat) == nrow(fillerDat)
# TRUE



# -------------------- Data plotting --------------------

# emphasis
dat %>% 
  ggplot(aes(x = emphasis, y = as.numeric(response), color = emphasis)) +
  geom_jitter(height = 0) + 
  labs(title = "Perceived naturalness of stimuli with and wihtout emphasis",
       x = "emphasis", y = "perceived naturalness") +
  scale_y_continuous(breaks=c(1:8))

# modality
dat %>% 
  ggplot(aes(x = modality, y = as.numeric(response), color = modality)) +
  geom_jitter(height = 0) + 
  labs(title = "Perceived naturalness of auditory and written stimuli",
       x = "modality", y = "perceived naturalness") +
  scale_y_continuous(breaks=c(1:8))

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
  scale_y_continuous(breaks=c(1:8))

# modality and emphasis in one graph
dat %>% 
  ggplot(aes(x = emphasis, y = as.numeric(response), color = emphasis)) +
  geom_jitter(height = 0) + 
  labs(title = "Auditory and written stimuli with and without emphasis",
       x = "emphasis", y = "perceived naturalness") +
  facet_wrap(~modality) +
  scale_y_continuous(breaks=c(1:8))

# emphasis and fragment type in one graph
dat %>% 
  ggplot(aes(x = fragment_type, y = as.numeric(response), 
             color = fragment_type)) +
  geom_jitter(height = 0) + 
  labs(title = "Functional and lexical fragments with and without emphasis",
    x = "fragment type", y = "perceived naturalness", color = "fragment type") +
  scale_x_discrete(labels=c("functional", "lexical")) +
  scale_color_discrete(name = "fragment type", 
                       labels = c("functional", "lexical")) +
  facet_grid(~emphasis) +
  scale_y_continuous(breaks=c(1:8))

# modality and fragment type in one graph
dat %>% 
  ggplot(aes(x = fragment_type, y = as.numeric(response), 
             color = fragment_type)) +
  geom_jitter(height = 0) + 
  labs(title = "Auditory and written stimuli with functional and lexical fragments",
    x = "fragment type", y = "perceived naturalness", color = "fragment type") +
  scale_x_discrete(labels=c("functional", "lexical")) +
  scale_color_discrete(name = "fragment type", 
                    labels = c("functional", "lexical")) +
  facet_grid(~modality) +
  scale_y_continuous(breaks=c(1:8))

# all factors in one graph
dat %>% 
  ggplot(aes(x = fragment_type, y = as.numeric(response), 
             color = fragment_type)) +
  geom_jitter(height = 0) + 
  labs(title = "Participants' ratings of all critical items",
       x = "fragment type", y = "perceived naturalness", 
       color = "fragment type") +
  scale_x_discrete(labels=c("functional", "lexical")) +
  scale_color_discrete(name = "fragment type", 
                       labels = c("functional", "lexical")) +
  facet_grid(emphasis~modality) +
  scale_y_continuous(breaks=c(1:8))


# including means and standard deviation

# emphasis
sumStatsEmp <- summarySE(dat, measurevar ="response", groupvars = "emphasis")

sumStatsEmp %>%
  ggplot(aes(x = emphasis, y = as.numeric(response), color = emphasis)) + 
  geom_point() +
  labs(y="percevied naturalness")+
  geom_errorbar(aes(ymin = as.numeric(response)-ci, 
                    ymax = as.numeric(response)+ci), width = 0.1)+
  ylim(1,8)

# modality
sumStatsMod <- summarySE(dat, measurevar ="response", groupvars = "modality")
sumStatsMod %>%
  ggplot(aes(x = modality, y = as.numeric(response), color = modality)) + 
  geom_point() +
  labs(y="percevied naturalness")+
  geom_errorbar(aes(ymin = as.numeric(response)-ci, 
                    ymax = as.numeric(response)+ci), width = 0.1)+
  ylim(1,8)

# fragment type
sumStatsFrag <- summarySE(dat, measurevar ="response", groupvars = "fragment_type")
sumStatsFrag %>%
  ggplot(aes(x = fragment_type, y = as.numeric(response), color = fragment_type)) + 
  geom_point() +
  labs(x="fragment type", y="percevied naturalness")+
  scale_x_discrete(labels=c("functional", "lexical")) +
  scale_color_discrete(name = "fragment type", 
                       labels = c("functional", "lexical")) +
  geom_errorbar(aes(ymin = as.numeric(response)-ci, 
                    ymax = as.numeric(response)+ci), width = 0.1)+
  ylim(1,8)

# all factors included
sumStats <- summarySE(dat, measurevar ="response", 
                      groupvars = c("emphasis", "modality", "fragment_type"))
sumStats$ci <- sumStatsMod$ci 
#choosing one of the ci columns to ensure consistency when specifying ymin and ymax
sumStats %>%
  ggplot(aes(x= emphasis, y = as.numeric(response))) +
  geom_point() +
  labs(y="percevied naturalness") +
  geom_errorbar(aes(ymin = as.numeric(response) - ci, 
                    ymax = as.numeric(response) + ci), width = 0.1) +
  ylim(1, 8) +
  facet_grid(fragment_type ~ modality) 



# -------------------- Hypotheses testing --------------------

# z-score the responses
responses_z <- scale(as.numeric(dat$response))
dat$responses_z <- responses_z

# First hypothesis
# H0: There is no significant difference between stimuli with and without emphasis.
# H1: Stimuli with emphasis receive higher acceptability ratings than stimuli without emphasis.
# tested by linear mixed model
# as by this method:
modelemp <- lmer(data = dat, responses_z ~ emphasis + (1|submission_id))
summary(modelemp)
# p value = 0.0.00951
# We judge there to be evidence in favor of the first hypothesis, if the p-value is less than 0,05.

# Second hypothesis
# H0: There is no significant difference between auditory and written stimuli.
# H1: Auditory stimuli receive higher acceptability ratings than written stimuli.
# tested by linear mixed model
# as by this method:
modelmod <- lmer(data=dat, responses_z ~ modality + (1|submission_id))
summary(modelmod)
# p value = 0.00168
# We judge there to be evidence in favor of the second hypothesis, if the p-value is less than 0,05.

# Third hypothesis
# H0: There is no significant difference between stimuli with lexical and functional fragments.
# H1: Stimuli with lexical fragments receive higher acceptability ratings than stimuli with functional fragments
# tested by linear mixed model
# as by this method:
modelfrag <- lmer(data=dat, responses_z ~ fragment_type + (1|submission_id))
summary(modelfrag)
# p value = 0.00122
# We judge there to be evidence in favor of the third hypothesis, if the p-value is less than 0,05.


